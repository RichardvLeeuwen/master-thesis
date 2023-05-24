import matplotlib.pyplot as plt

y=[]



for x in range(1, 5000, 100):

	averages=[]

	for i in range(x,x+100):

		with open("pingmeasures/"+str(i)) as file:

	    		data = file.readlines()

	    		if(len(data) == 0):

	    			break

	    		columns = data[-1].split()

	    		avg = columns[3].split('/')[1]

	    		averages.append(float(avg))

	if len(averages) == 0:

		break

	y.append((sum(averages)/len(averages)))

x = list(range(0, len(y) * 100, 100))

plt.plot(x,y)

plt.ylim(0, max(y)+0.5)

plt.xlabel('Alpine containers in steps of 100')

plt.ylabel('Average ping in milliseconds')

plt.title('Relation of latency to total amount amount alpine containers')

plt.savefig('/home/richard/measurements/ping.png')

plt.close()
