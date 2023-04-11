obj-m += hc-sro4.o

ARCH=arm
KERNEL_DIR=/lib/modules/`uname -r`/build
CROSS_COMPILE=arm-linux-gnueabihf-
KERNEL=kernel7l


all:
		make -C $(KERNEL_DIR) M=$(PWD) modules ARCH=$(ARCH)  CROSS_COMPILE=$(CROSS_COMPILE) KERNEL=$(KERNEL)  V=1

clean:
		make -C $(KERNEL_DIR) M=$(PWD) clean ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE)
