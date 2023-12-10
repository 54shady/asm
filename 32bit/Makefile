OBJS = time-int-att time-int-intel time-syscall-att time-syscall-intel
all:$(OBJS)

time-int-att:
	gcc -m64 time-int-att.c -o time-int-att

time-int-intel:
	gcc -m64 time-int-intel.c -o time-int-intel -masm=intel

time-syscall-att:
	gcc -m64 time-syscall-att.c -o time-syscall-att -masm=att

time-syscall-intel:
	gcc -m64 time-syscall-intel.c -o time-syscall-intel -masm=intel

clean:
	rm -rf $(OBJS)
