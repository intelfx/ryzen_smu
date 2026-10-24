MOD 				:= ryzen_smu
VERSION				:= 0.1.7

ifneq ($(KERNELRELEASE),)

# ------------------------------------------------------------------------------
# Kbuild
# ------------------------------------------------------------------------------

obj-m				:= $(MOD).o
$(MOD)-y		 	:= drv.o smu.o

else

# ------------------------------------------------------------------------------
# dev Makefile
# ------------------------------------------------------------------------------

DESTDIR				?=
DKMS_ROOT_PATH			:= $(DESTDIR)/usr/src/$(MOD)-$(VERSION)

TARGET				:= $(shell uname -r)
KERNEL_MODULES			:= /lib/modules/$(TARGET)

ifneq ("","$(wildcard /usr/src/linux-headers-$(TARGET)/*)")
	KERNEL_BUILD		:= /usr/src/linux-headers-$(TARGET)
else
ifneq ("","$(wildcard /usr/src/kernels/$(TARGET)/*)")
	KERNEL_BUILD		:= /usr/src/kernels/$(TARGET)
else
	KERNEL_BUILD		:= $(KERNEL_MODULES)/build
endif
endif

KMAKE				:= $(MAKE) -C $(KERNEL_BUILD) M=$(CURDIR)
SUDO				:= sudo

.PHONY: all modules modules_install install clean dkms-install dkms-uninstall insmod checkmod

all: modules

debug:
	$(KMAKE) ccflags-y+=-DDEBUG modules

modules:
	$(KMAKE) modules

# Kbuild compresses and signs the module as configured for the target kernel
# and runs depmod.
modules_install: modules
	$(KMAKE) INSTALL_MOD_DIR=extra modules_install

install: modules_install

clean:
	@$(KMAKE) clean
	rm -rf *.o

dkms-install:
	install -Dm644 $(CURDIR)/Makefile -t $(DKMS_ROOT_PATH)
	install -Dm644 $(CURDIR)/*.[ch] -t $(DKMS_ROOT_PATH)

	sed -e "s/@VERSION@/$(VERSION)/" $(CURDIR)/dkms.conf \
		| install -Dm644 /dev/stdin $(DKMS_ROOT_PATH)/dkms.conf

dkms: dkms-install
	dkms add $(MOD)/$(VERSION)
	dkms build $(MOD)/$(VERSION)
	dkms install $(MOD)/$(VERSION)

dkms-uninstall:
	dkms remove $(MOD)/$(VERSION) --all
	rm -r $(DKMS_ROOT_PATH)

insmod:
	$(SUDO) rmmod $(MOD).ko; true
	$(SUDO) insmod $(MOD).ko

checkmod:
	lsmod | grep $(MOD)
	cat /proc/modules | grep $(MOD)
	cat /sys/kernel/$(MOD)_drv/drv_version
	modinfo $(MOD)

endif
