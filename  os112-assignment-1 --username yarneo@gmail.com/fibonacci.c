#include "types.h"
#include "stat.h"
#include "user.h"

struct pinfo
{
  int cid;
  int wait_time;
  int run_time;
  int ta_time;
};



struct pinfo forkarr[30];

void
fibonacci(int numOfPs)
{
  int n, pid, i, temp;
  int wtime=0; 
  int rtime=0;

  printf(1,"fibonacci test\n");

  for(n=0; n<numOfPs; n++) {
    pid = fork();
    if(pid == 0) { //children
      if((n%2) == 0) {
	  char* strfile1 = "FibTest";
	  char* strfile2;
	  int cpid = getpid();
	  itoa(cpid,strfile2);
	  strcar(strfile1,strfile2);
	  int fd = open(strfile1,(O_RDWR | O_CREATE));
	  if(fd < 0) {
	  printf(1,"problem opening file",fd);
	  exit();
      }
	  else {
	  if(n==0) {
	  write(fd,"0",1);
	  printf(1,"FibTest%d %d,none",cpid,0);
	  }
	  else {
	  write(fd,"0,1,",4);
	  printf(1,"FibTest%d %d,%d",cpid,1,0);
	  int aggr = 1;
	  while(aggr < n) {
	  fd->off -= 4;
	  read(
	  
	  
	  aggr++;
	  }
	  }
	  }
	
	
	  }
	  else {
	  
	  
	  
	  }
	for(i = 0; i < 500; i++) {
	printf(1,"%d\n",i);
	}
      exit();
   }
   else if(pid > 0) {//parent
	continue;
    }
   else //fork error
	printf(1,"fork error");
      exit();
  }


if(pid > 0) {
    for(n=0; n<N; n++) {
	temp = wait2(&wtime,&rtime);
	if(temp == -1) { //error 
	printf(1,"wait2 error");
	exit();
	}
        else {
  	//printf(1,"wtime: %d",wtime);
  	//printf(1,"rtime: %d",rtime);
	forkarr[n].cid = temp;
	forkarr[n].wait_time = wtime;
	forkarr[n].run_time = rtime;
	forkarr[n].ta_time = wtime+rtime;

	}
    }
}


}



int
main(int argc, char *argv[])
{
  char* pStr = argv[1];
  int numPs = atoi(pStr);
  fibonacci(numPs);
  }

}
