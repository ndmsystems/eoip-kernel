.PHONY: all distclean clean

VERSION				= `git describe --tag | sed -e 's/-g/-/'`
VERSION_FILE		:= eoip_version.h

ifneq ($(KERNELRELEASE),)

KERNEL_PFX			:= $(shell echo "$(KERNELRELEASE)" | head -c 3)

ifeq ($(KERNEL_PFX),4.9)
eoip				:= 4.9/eoip.o
else
eoip				:= eoip.o
endif

obj-m				:= $(eoip)

else

PWD					:= $(shell pwd)
KERNELDIR			?= /lib/modules/$(shell uname -r)/build

all: version
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

version:
	@echo "#ifndef __EOIP_VERSION_H__"					> $(VERSION_FILE)
	@echo "#define __EOIP_VERSION_H__"					>> $(VERSION_FILE)
	@echo "#define EOIP_VERSION \""$(VERSION)"\"" 		>> $(VERSION_FILE)
	@echo "#endif /* __EOIP_VERSION_H__ */"				>> $(VERSION_FILE)
	@echo ""											>> $(VERSION_FILE)

distclean: clean

clean:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) clean
	@rm -f $(VERSION_FILE)

endif
