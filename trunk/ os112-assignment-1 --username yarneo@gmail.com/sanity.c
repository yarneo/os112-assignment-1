#include "types.h"
#include "stat.h"
#include "user.h"

#define N  30

struct pinfo
{
  int cid;
  int wait_time;
  int run_time;
  int ta_time;
};



struct pinfo forkarr[30];

void
sanity(void)
{
  int n, pid, i, temp;
  int wtime=0; 
  int rtime=0;

  printf(1,"sanity test\n");

  for(n=0; n<N; n++) {
    pid = fork();
    if(pid == 0) { //children
      if((n%2) == 0) {
	nice();
	}
	for(i = 0; i < 20; i++) {
	printf(1,"%d\n",n);
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
main(void)
{
  int j;
  double ave_wtime=0,ave_rtime=0,ave_tatime=0;
  sanity();
  for(j=0;j<N;j++) {
  ave_wtime += forkarr[j].wait_time;
  ave_rtime += forkarr[j].run_time;
  ave_tatime += forkarr[j].ta_time;

  printf(1,"\npid: %d",forkarr[j].cid);
  printf(1,"    wtime: %d",forkarr[j].wait_time);
  printf(1,"    rtime: %d",forkarr[j].run_time);
  printf(1,"    tatime: %d",forkarr[j].ta_time);

  }
  ave_wtime /= 30;
  ave_rtime /= 30;
  ave_tatime /= 30;
  printf(1,"\n\nAVE wtime: %d",(int)ave_wtime);
  printf(1,"    AVE rtime: %d",(int)ave_rtime);
  printf(1,"    AVE tatime: %d",(int)ave_tatime);
  exit();
}
