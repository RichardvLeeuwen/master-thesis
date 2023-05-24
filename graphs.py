import matplotlib.pyplot as plt



x=list(range(0, 5100, 100))

with open("powerconsumed.txt") as file:

    data = file.read()

y1=list(data.split(','))

y2=y1[:-1]

y3=[float(i) for i in y2]

plt.plot(x,y3)

plt.ylim(0, max(y3)+50)

plt.xlabel('Alpine containers in steps of 100')

plt.ylabel('Power in watts')

plt.title('Power the chassis consumed in watts')

plt.savefig('/home/richard/measurements/powerconsumed.png')

plt.close()



with open("mem.txt") as file:

    data = file.read()

y1=list(data.split(','))

y2=y1[:-1]

y3=[float(i) for i in y2]

plt.plot(x,y3)

plt.ylim(0, max(y3)+5000)

plt.xlabel('Alpine containers in steps of 100')

plt.ylabel('RAM usage in MB')

plt.title('RAM usage of the chassis in MB')

plt.savefig('/home/richard/measurements/ram.png')

plt.close()



with open("cpu.txt") as file:

    data = file.read()

y1=list(data.split(','))

y2=y1[:-1]

y3=[float(i) for i in y2]

plt.plot(x,y3)

plt.ylim(0, 100)

plt.xlabel('Alpine containers in steps of 100')

plt.ylabel('CPU utilisation in %')

plt.title('CPU utilisation of chassis in %')

plt.savefig('/home/richard/measurements/cpu.png')

plt.close()



with open("poweralloc.txt") as file:

    data = file.read()

y1=list(data.split(','))

y2=y1[:-1]

y3=[float(i) for i in y2]

plt.plot(x,y3)

plt.ylim(0)

plt.xlabel('Alpine containers in steps of 100')

plt.ylabel('Power in watts')

plt.title('Power the chassis allocated in watts')

plt.savefig('/home/richard/measurements/poweralloc.png')

plt.close()
