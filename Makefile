MKDIR_P = mkdir -p
RM      = rm
INSTALL = install

CC     ?= gcc
CFLAGS  = -std=gnu99 -O2 -Wall -Wshadow -Isrc
LDFLAGS = $(CFLAGS)

PREFIX  = /usr/local
LIBDIR  = $(PREFIX)/lib64
INCDIR  = $(PREFIX)/include

libfathom.so: obj/tbprobe.o
	$(CC) $(LDFLAGS) -shared $^ -o $@

obj/tbprobe.o: src/tbprobe.c src/tbchess.c src/stdendian.h src/tbprobe.h
	@$(MKDIR_P) obj
	$(CC) $(CFLAGS) -fPIC -c $< -o $@

clean:
	$(RM) -f libfathom.so
	$(RM) -rf obj

install: libfathom.so
	$(MKDIR_P) $(DESTDIR)$(LIBDIR)
	$(MKDIR_P) $(DESTDIR)$(INCDIR)
	$(INSTALL) -m 0644 libfathom.so $(DESTDIR)$(LIBDIR)
	$(INSTALL) -m 0644 src/{stdendian,tbconfig,tbprobe}.h $(DESTDIR)$(INCDIR)

uninstall:
	$(RM) -f $(DESTDIR)$(LIBDIR)/libfathom.so
	$(RM) -f $(DESTDIR)$(INCDIR)/{stdendian,tbconfig,tbprobe}.h

.PHONY: clean install uninstall
