#include "types.h"
#include "defs.h"
#include "param.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);


int
clockticks(void) {
 uint xticks;
 acquire(&tickslock);
 xticks = ticks;
 release(&tickslock);
 return xticks;
}

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}


// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack if possible.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;
  
  // Set up new context to start executing at forkret,
  // which returns to trapret (see below).
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;


  p->ctime = clockticks();
  p->rtime = 0;
  p->priority = 0;
  //cprintf("%d",clockticks());

  return p;
}

// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
  initproc = p;
  if(!(p->pgdir = setupkvm()))
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  p->state = RUNNABLE;
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz = proc->sz;
  if(n > 0){
    if(!(sz = allocuvm(proc->pgdir, sz, sz + n)))
      return -1;
  } else if(n < 0){
    if(!(sz = deallocuvm(proc->pgdir, sz, sz + n)))
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
    return -1;

  // Copy process state from p.
  if(!(np->pgdir = copyuvm(proc->pgdir, proc->sz))){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
 
  pid = np->pid;
  np->state = RUNNABLE;
  safestrcpy(np->name, proc->name, sizeof(proc->name));
  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  iput(proc->cwd);
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  proc->etime = clockticks();
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
	p->rtime = 0;
	p->ctime = 0;
	p->etime = 0;
	p->priority = 0;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}

int
wait2(int* wtime, int* rtime)
{
  struct proc *p;
  int havekids, pid;
	
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
	*wtime = ((p-> etime) - (p-> ctime)) - (p->rtime);
	*rtime = (p->rtime); 
	//cprintf("\nwtime: %d\n",*wtime);
	//cprintf("rtime: %d\n",*rtime);
	p->rtime = 0;
	p->ctime = 0;
	p->etime = 0;
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
	p->priority = 0;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}

// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
#ifdef RR2
  int loop = 0;
  proc* lowPriorityRunnable;
  proc* lastHighPri;
  proc* lastLowPri = -1;
#elif FAIR2Q
  proc* min_low_pri;
  proc* min_high_pri;
  int mechane;
  int ratio;
  int smallHighRatio = -1;
  int smallLowRatio = -1;
#endif
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
#ifdef RR2
/* I run on all the processes and check a few cases: 
	1. if they are of high priority and runnable then run them
	2. if they are of high priority but not runnable then continue over them
	3. if they are of low priority  but I havent passed through all of the proccesses then continue
	4. if I passed through all of the processes and no high priority was runnable I go over all the low priorities
	   and check if any of them is runnable, the first that is, I will choose him.
	   if none are runnable I will go back to step 1.
	   if i get one that is runnable and low priority i will choose him then go back to step 1 

	I must keep a mechanism that saves the last low priority I was at and the last High priority I was at
	so then I can return to that index when needed */
      if((p->state != RUNNABLE) && (p->priority == 0)) {
	loop++;
        continue;
	}
      else if((p->priority != 0) && loop < 64)
	{
	loop++;
	continue;
	}
      else if(loop == 64)
	{
	lastHighPri = p;
	if(lastLowPri == -1) {
	lowPriorityRunnable = p;
	}
	else {
	lowPriorityRunnable = lastLowPri;
	}
	while(!((lowPriorityRunnable->priority !=0) && (lowPriorityRunnable->state == RUNNABLE))) {
	lowPriorityRunnable++;
	loop++;
	if(loop == 128)
	break;
	}
	if(loop < 128)
	p = lowPriorityRunnable;
	lastLowPri = lowPriorityRunnable;
	loop = 0;
	}
	else {
	loop = 0;
	lastHighPri = p;
	}
#elif FAIR2Q
/* I run on all the processes and check a few cases: 
	1. if they are runnable and of high priority and I havent passed all of the processes,
	   I check if its ratio is smaller than the current smallest ratio of high priority
	   if it is then I save it as the new current smallest ratio, else I continue.
	2. if they are runnable and of low priority and I havent passed all of the processes,
	   I check if its ratio is smaller than the current smallest ratio of low priority
	   if it is then I save it as the new current smallest ratio, else I continue.
	3. if I passed all of the processes I choose the process with the smallest ratio of high priority,
	   if there isnt one that was runnable, I choose the process with the smallest ratio of low priority,
	   if there isnt one I go back to step 1. */	
      if((p->state == RUNNABLE) && (p->priority == 0) && (loop<64)) {
	mechane = clockticks() - p->ctime;
	if(mechane == 0)
	mechane = 0.01;

	ratio = p->rtime / mechane;

	if((smallHighRatio == -1) || (ratio < smallHighRatio)) {
	smallHighRatio = ratio;
	min_high_pri = p;
	}

	loop++;
        continue;
	}
      else if((p->state == RUNNABLE) && (p->priority != 0) && (loop<64))
	{
	mechane = clockticks() - p->ctime;
	if(mechane == 0)
	mechane = 0.01;

	ratio = p->rtime / mechane;

	if((smallLowRatio == -1) || (ratio < smallLowRatio)) {
	smallLowRatio = ratio;
	min_low_pri = p;
	}

	loop++;
        continue;
	}
      else if(loop == 64)
	{
	if(smallHighRatio != -1)
	p = min_high_pri;
	else if((smallHighRatio == -1) && (smallLowRatio != -1))
	p = min_low_pri;
	else {
	loop = 0;
	continue;
	}
	}
      else {
	loop++;
	continue;
	}
	

#else
      if(p->state != RUNNABLE) 
        continue;
#endif /* scheduling policies */


      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
      p->state = RUNNING;

      swtch(&cpu->scheduler, proc->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;

#ifdef RR2
      p=lastHighPri;
#endif
    }
    release(&ptable.lock);

  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  proc->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
  
  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
  proc->state = SLEEPING;
  sched();

  // Tidy up.
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

int
nice()
{
  int bef = proc->priority;
  if(bef == 0)
  bef = 1;
  else 
  bef = 0;
  acquire(&ptable.lock);
  proc->priority = (1 - (proc->priority));
  release(&ptable.lock);
  return (proc->priority == bef);  
}
