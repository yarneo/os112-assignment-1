#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

struct pinfo
{
  int cid;
  int wait_time;
  int run_time;
  int ta_time;
};



struct pinfo forkarr[30];


void
charCat(char* str, char c) {
char* point = str;
while((*point) != '\0') {
point++;
}
(*point) = c;
point++;
(*point) = '\0'; 
}

int
fileOffset(int fd,char* filename,int buffer)
{
char temp[buffer];
close(fd);
int fd2 = open(filename,O_RDWR);
read(fd2,temp,buffer);
return fd2;
}


void
fibonacci(int numOfPs)
{
  int n, pid, temp;


  printf(1,"fibonacci test\n");

  for(n=0; n<numOfPs; n++) {
    pid = fork();
    if(pid == 0) { //children
      if((n%2) == 0) {
	  char* strfile1 = "FibTest";
	  char strfile2[11];
	  int cpid = getpid();
	  int read_off;
	  itoa(cpid,strfile2);
	  strcat(strfile1,strfile2);
	  int fd = open(strfile1,(O_RDWR | O_CREATE));
	  char num1[11];
	  char num2[11];
	  char readbuf;
	  int nnum1;
	  int nnum2;
	  int nnum3;
	  char num3[11];
	  int readbuffer=0;
	  if(fd < 0) {
	  	printf(1,"problem opening file",fd);
	  	exit();
          }
	  else {
	  	if(numOfPs==0) {
	  		write(fd,"0",1);
	  		printf(1,"FibTest%d %d,none\n",cpid,0);
	  	}
	  	else {
	  		read_off = 0;
	  		write(fd,"2,3,",4);
	  		printf(1,"FibTest%d %d,%d\n",cpid,1,0);
	  		int aggr = 1;
	  		while(aggr < numOfPs) {
	  			fd = fileOffset(fd,strfile1,read_off);//fd->off = read_off;
	  			for(;;) {
	  				read(fd,&readbuf,1);
					readbuffer++;
	  				if(readbuf != ',') {
	  					charCat(num1,readbuf); //add char to string
	  				}
	  				else {
	  					read_off = readbuffer;
	  					for(;;) {
	  						read(fd,&readbuf,1);
							readbuffer++;
	  						if(readbuf != ',') {
	  							charCat(num2,readbuf); //add char to string
	  						}	
	  						else {
	  							break;

	  						}
	  					}//end inner for
	  					break;
	  				}
	  			}//end outer for
	  			nnum1 = atoi(num1);
	  			nnum2 = atoi(num2);
				//printf(1,"\n%d TEST %d TEST\n",cpid,nnum1);
				//printf(1,"\n%d TEST %d TEST\n",cpid,nnum2);
	  			nnum3 = nnum1 + nnum2;
	  			printf(1,"FibTest%d %d,%d\n",cpid,nnum2,nnum1);	  
	  			itoa(nnum3,num3);
				charCat(num3,',');
				//printf(1,"\n%d TEST %s TEST\n",cpid,num3);
	  			write(fd,num3,strlen(num3));
	  			aggr++;
				memset(num1,0,11);
				memset(num2,0,11);
				memset(num3,0,11);
				readbuffer = read_off;	  		
			}
	  	}
	  	printf(1,"%d cid finished its calculation\n",cpid);
		close(fd);
	  }
	
	
     }//end even processes
     else {
	  int cpid = getpid();
	  int num1 = 0;
	  int num2 = 1;
	  int aggr = 1;
	  if(numOfPs != 1) {
	  	while(aggr < numOfPs) {
			num1 = num2 + num1;
			aggr++;
	  	}
	  }
	  printf(1,"%d cid finished its calculation\n",cpid);  
     }//end odd processes
     exit();
   }//end children
   else if(pid > 0) {//parent
	continue;
   }
   else //fork error
	printf(1,"fork error");
      exit();
   }


if(pid > 0) {
    for(n=0; n<numOfPs; n++) {
	temp = wait();
	if(temp == -1) { //error 
	printf(1,"wait error");
	exit();
	}
        else {

	}
    }
}


}



int
main(int argc, char *argv[])
{
  if(argc == 2) {
  char* pStr = argv[1];
  int numPs = atoi(pStr);
  if(numPs > 0)
  fibonacci(numPs);
  else {
  printf(1,"insert valid argument\n");
  exit();
  }
  }
  else {
  printf(1,"insert argument\n");
  }
exit();
return 0;
}
