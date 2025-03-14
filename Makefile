CC ?= gcc
CXX ?= g++
PKG_CONFIG ?= pkg-config

# To disable DBUS notifications, run:
# make USE_DBUS=0
# To disable faad2, run:
# make USE_FAAD=0

# Detect system and architecture
UNAME_S := $(shell uname -s)
ARCH := $(shell uname -m)

# Default USE_DBUS to auto-detect if not set by user
ifeq ($(origin USE_DBUS), undefined)
  ifeq ($(UNAME_S), Darwin)
    USE_DBUS = 0
  else
    USE_DBUS = 1
  endif
endif

# Adjust the PREFIX for macOS and Linux
ifeq ($(UNAME_S), Darwin)
    ifeq ($(ARCH), arm64)
        PREFIX ?= /usr/local
        PKG_CONFIG_PATH := /opt/homebrew/lib/pkgconfig:/opt/homebrew/share/pkgconfig:$(PKG_CONFIG_PATH)
    else
        PREFIX ?= /usr/local
        PKG_CONFIG_PATH := /usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:$(PKG_CONFIG_PATH)
    endif
else
    PREFIX ?= /usr
    PKG_CONFIG_PATH := /usr/lib/pkgconfig:/usr/share/pkgconfig:$(PKG_CONFIG_PATH)
endif

# Default USE_FAAD to auto-detect if not set by user
ifeq ($(origin USE_FAAD), undefined)

  USE_FAAD = $(shell PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) $(PKG_CONFIG) --exists faad && echo 1 || echo 0)

  ifeq ($(USE_FAAD), 0)
    # If pkg-config fails, try to find libfaad dynamically in common paths
    USE_FAAD = $(shell [ -f /usr/lib/libfaad.so ] || [ -f /usr/local/lib/libfaad.so ] || \
                       [ -f /opt/local/lib/libfaad.so ] || [ -f /opt/homebrew/lib/libfaad.dylib ] || \
                       [ -f /opt/homebrew/opt/faad2/lib/libfaad.dylib ] || \
                       [ -f /usr/local/lib/libfaad.dylib ] || [ -f /lib/x86_64-linux-gnu/libfaad.so.2 ] && echo 1 || echo 0)
  endif
endif

# Compiler flags
COMMONFLAGS = -I/usr/include -I/opt/homebrew/include -I/usr/local/include -I/usr/lib -Iinclude/minimp4 \
         -I/usr/include/chafa -I/usr/lib/chafa/include -I/usr/include/ogg -I/usr/include/opus \
         -I/usr/include/stb -Iinclude/stb_image -I/usr/include/glib-2.0 \
         -I/usr/lib/glib-2.0/include -Iinclude/miniaudio -I/usr/include/gdk-pixbuf-2.0 -O2

COMMONFLAGS += $(shell PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) $(PKG_CONFIG) --cflags gio-2.0 chafa fftw3f opus opusfile vorbis ogg glib-2.0 taglib)
COMMONFLAGS += -fstack-protector-strong -Wformat -Werror=format-security -fPIE -D_FORTIFY_SOURCE=2
COMMONFLAGS += -Wall -Wextra -Wpointer-arith -flto

CFLAGS = $(COMMONFLAGS)

# Compiler flags for C++ code
CXXFLAGS = $(COMMONFLAGS) -std=c++11

# Libraries
LIBS = -L/usr/lib -lm -lopusfile -lglib-2.0 -lpthread $(shell PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) $(PKG_CONFIG) --libs gio-2.0 chafa fftw3f opus opusfile ogg vorbis vorbisfile glib-2.0 taglib)
LIBS += -lstdc++

LDFLAGS = -logg -lz -flto

ifeq ($(UNAME_S), Linux)
  CFLAGS += -fPIE
  CXXFLAGS += -fPIE
  LDFLAGS += -pie -Wl,-z,relro -s
endif

# Conditionally add  USE_DBUS is enabled
ifeq ($(USE_DBUS), 1)
  DEFINES += -DUSE_DBUS
endif

# Conditionally add faad2 support if USE_FAAD is enabled
ifeq ($(USE_FAAD), 1)
  ifeq ($(ARCH), arm64)
    CFLAGS += -I/opt/homebrew/opt/faad2/include
    LIBS += -L/opt/homebrew/opt/faad2/lib -lfaad
  else
    CFLAGS += -I/usr/local/include
    LIBS += -L/usr/local/lib -lfaad
  endif
  DEFINES += -DUSE_FAAD
endif

ifeq ($(origin CC),default)
    CC := gcc
endif

ifneq ($(findstring gcc,$(CC)),)
    ifeq ($(UNAME_S), Linux)
        LIBS += -latomic
    endif
endif

OBJDIR = src/obj

SRCS = src/common_ui.c src/sound.c src/directorytree.c src/notifications.c src/soundcommon.c src/m4a.c src/search_ui.c src/playlist_ui.c src/player.c \
       src/soundbuiltin.c src/mpris.c src/playerops.c src/utils.c src/file.c src/imgfunc.c src/cache.c src/songloader.c \
       src/playlist.c src/term.c src/settings.c src/visuals.c src/rpd.c
OBJS = $(SRCS:src/%.c=$(OBJDIR)/%.o)

# Add the C++ wrapper to the list of object files
WRAPPER_SRC = src/tagLibWrapper.cpp
WRAPPER_OBJ = $(OBJDIR)/tagLibWrapper.o

MAN_PAGE = rpd.1
MAN_DIR ?= $(PREFIX)/share/man

all: rpd

$(OBJDIR)/%.o: src/%.c Makefile | $(OBJDIR)
	$(CC) $(CFLAGS) $(DEFINES) -c -o $@ $<

# Compile the C++ wrapper with g++
$(WRAPPER_OBJ): $(WRAPPER_SRC) Makefile | $(OBJDIR)
	$(CXX) $(CXXFLAGS) -c -o $@ $<

$(OBJDIR):
	mkdir -p $(OBJDIR)

# Link all objects together
rpd: $(OBJS) $(WRAPPER_OBJ) Makefile
	$(CC) -o rpd $(OBJS) $(WRAPPER_OBJ) $(LIBS) $(LDFLAGS)

.PHONY: install
install: all
	mkdir -p $(DESTDIR)$(MAN_DIR)/man1
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	install -m 0755 rpd $(DESTDIR)$(PREFIX)/bin/rpd
	install -m 0644 docs/rpd.1 $(DESTDIR)$(MAN_DIR)/man1/rpd.1

.PHONY: uninstall
uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/rpd
	rm -f $(DESTDIR)$(MAN_DIR)/man1/rpd.1

.PHONY: clean
clean:
	rm -rf $(OBJDIR) rpd
