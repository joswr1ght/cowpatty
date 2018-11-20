##################################
# <jwright> Well, I may be doing stupid things with make
# <jwright> OK, it was Makefile stupid'ness
# <jwright> I don't really understand what the hell I am doing with Make, I'm
#           just copying other files and seeing what works.
# <dragorn> heh
# <dragorn> i think thats all anyone does
# <dragorn> make is a twisted beast
##################################
LDLIBS		= -lpcap
CFLAGS		= -pipe -Wall -DOPENSSL
CFLAGS		+= -O2
LDLIBS		+= -lcrypto
CFLAGS		+= -g3 -ggdb
#CFLAGS		+= -static
PROGOBJ		= md5.o sha1.o utils.o
PROG		= cowpatty genpmk
MANUALS		= cowpatty.1 genpmk.1
BINDIR		= /usr/local/bin
MANDIR		= /usr/local/man/man1
CC			= clang

.PHONY: all clean strip install-man install-bin install

all: $(PROG)

cowpatty: cowpatty.c cowpatty.h $(PROGOBJ)
	$(CC) $(CFLAGS) $< -o $@ $(PROGOBJ) $(LDLIBS)

genpmk: genpmk.c cowpatty.h utils.o sha1.o
	$(CC) $(CFLAGS) $< -o $@ utils.o sha1.o $(LDLIBS)

utils.o: utils.c utils.h radiotap.h
	$(CC) $(CFLAGS) $< -c

md5.o: md5.c md5.h common.h
	$(CC) $(CFLAGS) $< -c

sha1.o: sha1.c sha1.h common.h
	$(CC) $(CFLAGS) $< -c

clean:
	$(RM) $(PROGOBJ) $(PROG)

strip:
	@ls -l $(PROG)
	@strip $(PROG)
	@ls -l $(PROG)

install-man: $(MANUALS)
	install -d $(DESTDIR)$(MANDIR)
	install -m 644 $(MANUALS) $(DESTDIR)$(MANDIR)

install-bin: $(PROG)
	install -d $(DESTDIR)$(BINDIR)
	install -m 755 $(PROG) $(DESTDIR)$(BINDIR)

install: install-bin install-man
