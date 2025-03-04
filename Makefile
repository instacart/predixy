.PHONY : default debug clean

make = make
plt = $(shell uname)
ifeq ($(plt), FreeBSD)
	make = gmake
else ifeq ($(plt), OpenBSD)
	make = gmake
endif

default:
ifeq ($(plt), Darwin)
	@$(make) -C src -f Mac.mk
	@$(make) -C src -f Makefile predixy
else
	@$(make) -C src -f Makefile
endif

debug:
ifeq ($(plt), Darwin)
	@$(make) -C src -f Mac.mk
	@$(make) -C src -f Makefile LVL=-g predixy
else
	@$(make) -C src -f Makefile LVL=-g
endif

clean:
	@$(make) -C src -f Makefile clean
