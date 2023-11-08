#include <stdio.h>



int main(int argc, char *argv[]) {
	unsigned long num = 300000000;
	while(1){ 
          int prime = 1;
	  for (unsigned long i = 2; i < num;i++) {
            if((num % i) ==0 ) {
	      prime = 0;
	    }            
	  }
	  if(prime) {
            // printf("prime:%lu", num);
          } 
	  num = num + 1;
	}
        return 0;
}
