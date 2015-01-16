# Makefile for AI registry tools:
# - regserver (registry server)
# - regclient (registry client)


# Variables
# =========
NAME_SERVER 			=		regserver
NAME_CLIENT 			= 	regclient
NAME_INITD 				=		regserver
NAME_SYSTEMD 			=		regserver.service

PATH_ROOT 				=		.
PATH_SOURCE 			=		./source
PATH_INCLUDE 			=		./include

INSTALL_PATH 			= 	/ocadrone/apps/registry
INSTALL_INITD 		= 	/etc/init.d
INSTALL_SYSTEMD 	=		/usr/lib/systemd/system

# Sources
# =======
SRC_SERVER 				= 	$(PATH_SOURCE)/main_server.cpp 	\
											$(PATH_SOURCE)/server.cpp
SRC_CLIENT 				= 	$(PATH_SOURCE)/main_client.cpp
SRC_INITD 				=		$(PATH_SOURCE)/regserver.initd
SRC_SYSTEMD 			=		$(PATH_SOURCE)/regserver.systemd

# Compilation options
# ===================
CC 			= 	g++
CFLAGS 	= 	-W -Wall -ansi -pedantic -O3 -std=c++11 -Wl,-rpath /usr/local/lib/
CLIBS 	= 	-lKNM -lAIRegistry -lpthread


# Rules configuration
# ===================
.PHONY:		help clean 															\
					build build-server build-client 				\
					install install-server install-client 	\
					install-initd install-systemd						\
					remove remove-server remove-client

.SILENT:	help clean 															\
					build build-server build-client 				\
					install install-server install-client 	\
					install-initd install-systemd						\
					remove remove-server remove-client


# Basic Rules
# ===========
$(NAME): 	help

help:
			@echo "Registry tools' Makefile help"
			@echo "============================="

			@echo "[*] Compilation"
			@echo "    Type 'make build' to build the tools."
			@echo "    To build only server: 'make build-server'"
			@echo "    To build only client: 'make build-client'"
			@echo ""
			@echo "[*] Installation"
			@echo "    Type 'make install' (as root)."
			@echo "    To install initd script: make install-initd"
			@echo "    To install systemd script: make install-systemd"
			@echo ""
			@echo "[*] Removing"
			@echo "    Type 'make remove'."
			@echo ""
			@echo "Note: Two libraries are needed:"
			@echo "'libKNM' and 'libAIRegistry'."


# Compilation rules
# =================
build:
			make --no-print-directory build-server
			make --no-print-directory build-client

build-server:
			@echo "--------------------------------------------"
			@echo "Building server"
			@echo "Compiler       : $(CC)"
			@echo "Compiler flags : $(CFLAGS)"
			@echo "Libraries      : $(CLIBS)"
			@echo "--------------------------------------------"
			$(CC) $(CFLAGS) $(CLIBS) $(SRC_SERVER) -I $(PATH_INCLUDE) -o $(NAME_SERVER)

build-client:
			@echo "--------------------------------------------"
			@echo "Building client"
			@echo "Compiler       : $(CC)"
			@echo "Compiler flags : $(CFLAGS)"
			@echo "Libraries      : $(CLIBS)"
			@echo "--------------------------------------------"
			$(CC) $(CFLAGS) $(CLIBS) $(SRC_CLIENT) -I $(PATH_INCLUDE) -o $(NAME_CLIENT)


# Installation rules
# ==================
install:
			if [ ! -d $(INSTALL_PATH) ]; then mkdir -p $(INSTALL_PATH); fi
			make --no-print-directory install-server
			make --no-print-directory install-client

install-server:
			@echo "---"
			@echo "Installing registry server 'regserver'"
			@echo "Installation directory: $(INSTALL_PATH)"
			cp $(NAME_SERVER) $(INSTALL_PATH)
			@echo "Done."

install-client:
			@echo "---"
			@echo "Installing registry client 'regclient'"
			@echo "Installation directory: $(INSTALL_PATH)"
			cp $(NAME_CLIENT) $(INSTALL_PATH)
			@echo "Done."

install-initd:
			@echo "---"
			@echo "Installing registry server init.d script"
			if [ -e $(SRC_INITD) ]; then cp $(SRC_INITD) $(INSTALL_INITD)/$(NAME_INITD); fi
			@echo "Done."

install-systemd:
			@echo "---"
			@echo "Installing registry server systemd script"
			if [ -e $(SRC_SYSTEMD) ]; then cp $(SRC_SYSTEMD) $(INSTALL_SYSTEMD)/$(NAME_SYSTEMD); fi
			@echo "Done."



# Removing & cleaning rules
# =========================
remove:
			make --no-print-directory remove-server
			make --no-print-directory remove-client

remove-server:
			@echo "Removing server"
			if [ -e $(INSTALL_PATH)/$(NAME_SERVER) ]; then rm $(INSTALL_PATH)/$(NAME_SERVER); fi
			if [ -e $(INSTALL_INITD)/$(NAME_INITD) ]; then rm $(INSTALL_INITD)/$(NAME_INITD); fi
			if [ -e $(INSTALL_SYSTEMD)/$(NAME_SYSTEMD) ]; then rm $(INSTALL_SYSTEMD)/$(NAME_SYSTEMD); fi
			@echo "Done."

remove-client:
			@echo "Removing client"
			if [ -e $(INSTALL_PATH)/$(NAME_CLIENT) ]; then rm $(INSTALL_PATH)/$(NAME_CLIENT); fi
			@echo "Done."

clean:
			if [ -e $(NAME_SERVER) ]; then rm $(NAME_SERVER); fi
			if [ -e $(NAME_CLIENT) ]; then rm $(NAME_CLIENT); fi
