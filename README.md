About
-----

*This is an updated version of the original repo, supporting the newest Raspbian (state 2023-04-10)*

The HC-SRO4 is an ultrasonic distance sensor to be attached on 2 5V GPIO pins. 
This driver uses the interrupt logic of the GPIO driver to measure the 
distance in a non-blocking, precise and load-independend way. Unlike 
user land measurement methods you can even compile a linux kernel 
while doing measurements without getting weird results.

The driver has been tested using a Raspberry Pi 1, but in theory should
work on any device that supports GPIO hardware. 

Keep in mind that the HC-SRO4 is a 5 volts device so attatching it directly
to the raspberry (3.3 Volts) pins is probably not a good idea. There
are tutorials on the net explaining how to solder 2 resistors such that
it works with the 3.3 Volts pins.



Building on the raspberry
--------
Make sure, you set your Raspbian kernel to 32bit in config.txt, as getting the 64bit build on the Raspberry is currently not supported

```[pi4]
arm_64bit=0```

Install the raspberry linux headers:
```apt-get install raspberry-linux-headers```

Make sure its version matches the installed kernel.

You have two options to compile this driver for the Raspberry Pi:

- either compile it on a linux host using a cross development environment
   (not tested)
- or directly on the raspberry

To compile it using a cross development environment you'll need to install
a cross development environment first (ARM cross compiler) and then obtain
the raspberry pi kernel sources (these are different from the vanilla 
kernel), see https://www.raspberrypi.org/documentation/linux/kernel
for instructions. Once the kernel is compiled and installed on the 
raspberry edit the Makefile of this repo so it says something like:

```
ARCH=arm
KERNEL_DIR=/lib/modules/`uname -r`/build
CROSS_COMPILE=arm-linux-gnueabihf-
KERNEL=kernel7l
```

Type 

```
  make 
```

and keep your fingers crossed ;) The result should be a file named hc-sro4.ko
which is the linux kernel module to be inserted using:

```
#Load module on a startup:
	#copy into modules dir (or any subdirectory) 
	sudo cp hc-sro4.ko /lib/modules/`uname -r`/
	#append into modules.order
	sudo echo hc-sro4.ko >> /lib/modules/`uname -r`/modules.order 
	#Probe all modules
	sudo depmod -a
	#Set to startup
	sudo echo "hc-sro4" >> /etc/modules 

#One time load of a module
sudo modprobe hc-sro4
```

on the raspberry. 

Note that the kernel version running on the raspberry *must* match the 
version the module is built against, else insmod/modprobe will not work.


Using the driver
----------------

Once insmod/modprobe works, you'll find a new directory under /sys/class/distance
(subject to change).

This supports an (in theory) unlimited number of HC-SRO4 devices.
To add a device, do a (as root):

```
   # echo 23 24 1000 > /sys/class/distance-sensor/configure
```

(23 is the trigger GPIO, 24 is the echo GPIO and 1000 is a timeout in
milliseconds)

Then a directory appears with a file measure in it. To measure, do a

```
   # cat /sys/class/distance-sensor/distance_23_24/measure
```

You'll receive the length of the echo signal in usecs. To convert (roughly)
to centimeters multiply by 17150 and divide by 1e6.

To deconfigure the device, do a

```
   # echo -23 24 > /sys/class/distance-sensor/configure
```

(normally not needed).

That's all.

Enjoy and please Star this repo if you like it.

- Johannes


