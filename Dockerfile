# Default release is 18.04
ARG BASE_IMAGE_RELEASE=18.04
# Default base image 
ARG BASE_IMAGE=abcdesktopio/oc.ubuntu.18.04
# Default TAG is dev 
ARG TAG=dev


# use FROM BASE_IMAGE
# define FROM befire use ENV command
FROM $BASE_IMAGE:$TAG

# define ARG 
ARG BASE_IMAGE_RELEASE
ARG BASE_IMAGE

# 
# gpg-agent used to verify external deb source
# gnupg for external trust
RUN apt-get update &&  apt-get install -y --no-install-recommends  \
        gpg-agent		\
        gnupg			\
	&& apt-get clean   	\
    	&& rm -rf /var/lib/apt/lists/*                   



# Use VNC 0.9.14 update
# depend for x11vnc
RUN apt-get update &&  apt-get install -y --no-install-recommends  \
   		tk		\
		libvncserver1 	\
    && apt-get clean	\
    && rm -rf /var/lib/apt/lists/*


# Add all lib for tigervnc
# RUN apt-get update &&  apt-get install -y --no-install-recommends  \
# 	xkb-data x11-xkb-utils xauth libaudit1 libbsd0 libc6 libgcc1 libgcrypt20 libgl1-mesa-glx libfile-readbackwards-perl libgl1 libgnutls30 libjpeg8 libpam0g libpixman-1-0 libselinux1 libstdc++6 libsystemd0 libxau6 libxdmcp6 libxfont2 zlib1g \
#    && apt-get clean \
#    && rm -rf /var/lib/apt/lists/*

# source for tiger vnc is 
# https://bintray.com/tigervnc/stable/download_file?file_path=tigervnc-1.10.1.x86_64.tar.gz
# RUN cd /tmp &&	\
#	wget "https://bintray.com/tigervnc/stable/download_file?file_path=tigervnc-1.11.0.x86_64.tar.gz" -O /tmp/tigervnc-1.11.0.x86_64.tar.gz && \


# if tigervnc-standalone-server=1.11.0+dfsg-2 exists then install the distrib tigervnc-standalone package
# else use the tigervnc-1.11.0.x86_64.tar.gz file
# ubuntu 18.04 does not provide tigervnc version 1.11
# ubuntu 20.04 does not provide tigervnc version 1.11
# ubuntu 21.04 does provide tigervnc version 1.11
# COPY	tigervnc-1.11.0.x86_64.tar.gz /tmp
# WORKDIR /tmp
# RUN	apt-get update && \
#	 	( 	apt-get install -y tigervnc-standalone-server=1.11.0+dfsg-2 || 				\ 
#		( 	tar -xvf tigervnc-1.11.0.x86_64.tar.gz && cp -r tigervnc-1.11.0.x86_64/usr/* /usr/ ) ) 	\
#	&& rm -rf tigervnc* \
#	&& apt-get clean \
#    	&& rm -rf /var/lib/apt/lists/*

RUN echo TARGETPLATFORM=$TARGETPLATFORM


#COPY --from=tigervncserver /deb/* /tmp
#RUN apt-get update \
#    && apt-get install --no-install-recommends -y /tmp/tigervncserver*.deb \ 
#    && rm -rf /tmp/tigervnc* \
#    && apt-get clean \
#    && rm -rf /var/lib/apt/lists/* 

#
# Download and install tigervnc 1.12.0 
RUN curl --output /tmp/download.deb "https://sourceforge.net/projects/tigervnc/files/stable/1.12.0/ubuntu-$(lsb_release -sr)LTS/$(dpkg --print-architecture)/tigervncserver_1.12.0-1ubuntu1_$(dpkg --print-architecture).deb/download" && \
    apt-get update && \
    apt-get install --no-install-recommends /tmp/download.deb && \
    rm /tmp/download.deb && \ 
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 


# ADD package for mimeopen used by spawner-service to detect application from a mimetype
# xclip is used by spwaner
# kterminal is used for built-in terminal
# desktop-file-utils desktop-file-utils contains a few command line utilities for working with desktop entries
# python?-nautilus matchs python-nautilus and python3-nautilus
# python?-nautilus   is used by .local/share/nautilus-python/extensions/desktop_download.py
# python-shellescape is used by .local/share/nautilus-python/extensions/desktop_download.py
# read https://gist.github.com/MatteoRagni/d339305d8dac0dbd6c51b4e085b8e526

RUN apt-get update &&  apt-get install -y --no-install-recommends  \
        	libfile-mimeinfo-perl		\
        	xclip  				\
		xauth				\
		desktop-file-utils		\
		shared-mime-info		\
		imagemagick			\
		eterm				\
        	qterminal			\
		xdg-user-dirs			\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# 
# Nautilus is a dedicated application
# comment 10/26/2021
# RUN apt-get update &&  apt-get install -y --no-install-recommends  \
#	nautilus     \
#    &&  apt-get install -y --no-install-recommends  python-nautilus     || true     \
#    &&  apt-get install -y --no-install-recommends  python3-nautilus    || true     \
#    &&  apt-get install -y --no-install-recommends  python-shellescape  || true     \
#    &&  apt-get install -y --no-install-recommends  python3-shellescape || true     \
#    && apt-get clean \
#    && rm -rf /var/lib/apt/lists/*

## add curses games
# RUN apt-get update &&  apt-get install  -y --no-install-recommends  \
#		ninvaders			\
#		bastet				\
#		libncurses5-dev			\
#		groff				\
#    && apt-get clean

## section 
# libnss-ldap
## section 
# libnss-ldap
RUN apt-get update &&  apt-get install -y --no-install-recommends \
		sasl2-bin			\
		libsasl2-2 			\
		libsasl2-modules 		\
		libsasl2-modules-gssapi-mit	\
        	krb5-user               	\
 		libnss3-tools           	\
        	ldap-utils              	\
		libgssglue1			\
		libgssrpc4			\
		libgss3				\
        	libgssapi-krb5-2        	\
		libnss3-tools	 		\
		gss-ntlmssp			\
		ca-certificates			\
		ncurses-term			\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# krb5 is set in etc no need to copy 
# ADD krb5.conf  /etc

# apt install iproute2 install ip command
# iputils-ping and vim can be removed
RUN apt-get update && apt-get install -y --no-install-recommends	\
		iputils-ping			\
		vim				\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# this package nodejs include npm 
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \ 
	&& apt-get update && 				\
	apt-get install -y --no-install-recommends	\
        	nodejs					\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
        dbus					\
        dbus-x11				\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
