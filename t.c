#include <stdio.h>
#include <pthread.h>


void *primeThread(void *data)
{
	unsigned long num = 300000000;
        while(1) {
		//printf("hi:%lu\n", num);
        	int prime = 1;
        	for (unsigned long i = 2; i < num;i++) {
                	if((num % i) ==0 ) {
                		prime = 0;
                	}

        	}
        	if(prime) {
        		//printf("prime:%lu", num);
        	}

        	num = num + 1;
	}
	//printf("end\n");
}


int main(int argc, char *argv[]) {
	pthread_t id;
    for(int i = 0; i<100;i++) {
    	pthread_create(&id, NULL, primeThread, NULL);
    }
    pthread_join(id, NULL);
    return 0;
}
