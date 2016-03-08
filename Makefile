#export
export LD_LIBRARY_PATH=.

# commands
VC = valac
GIR = g-ir-compiler

# file names
SRC = src/*.vala
TEST_SRC = tests/*.vala
TEST_OUT = debug/libjaa_test

NAMESPACE = Jaa
LIBNAME = libjaa
LIBFILE = $(LIBNAME).so
HFILE   = $(LIBNAME).h
VAPIFILE= $(LIBNAME).vapi
VERSION = 0.1

GIRFILE = $(NAMESPACE)-$(VERSION).gir
TYPEFILE = $(NAMESPACE)-$(VERSION).typelib

# paths
LIBFLAGS = --thread --pkg libsoup-2.4 --pkg json-glib-1.0 --pkg gee-0.8

VFLAGS = --library=$(LIBNAME) -H $(HFILE) $(SRC)  -X -fPIC -X -shared -o $(LIBFILE) $(LIBFLAGS)  --gir=$(GIRFILE)

DFLAGS =  $(VAPIFILE) -X $(LIBFILE)  $(LIBFLAGS) -X -I. -o demo

GIRFLAGS = --shared-library=$(LIBFILE) --output=$(TYPEFILE) $(GIRFILE)

DEBUG_FLAGS = $(LIBFLAGS) -g --save-temps -X -w $(SRC) $(TEST_SRC) -o $(TEST_OUT)


all: demo libjaa.so $(TYPEFILE)

demo: libjaa.so
	$(VC) $(DFLAGS) demo.vala

libjaa.so:
	$(VC) $(VFLAGS)

$(TYPEFILE):
	$(GIR) $(GIRFLAGS)

debug:
	mkdir debug
	$(VC) $(DEBUG_FLAGS)
	mv src/*.c debug/
	mv tests/*.c debug/

clean:
	rm -fr $(shell cat .gitignore)
	rm -fr debug
