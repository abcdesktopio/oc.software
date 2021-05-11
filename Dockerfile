# Default release is 18.04
ARG BASE_IMAGE_RELEASE=18.04
# Default base image 
ARG BASE_IMAGE=abcdesktopio/oc.ubuntu.18.04:dev

# use FROM BASE_IMAGE
# define FROM befire use ENV command
FROM ${BASE_IMAGE}

# define ARG 
ARG BASE_IMAGE_RELEASE
ARG BASE_IMAGE

# 
# gpg-agent used to verify external deb source
# gnupg for external trust
RUN apt-get update &&  apt-get install -y --no-install-recommends  \
        gpg-agent		\
        gnupg			\
	&& apt-get clean                      



# Use VNC 0.9.14 update
# depend for x11vnc
RUN apt-get update &&  apt-get install -y --no-install-recommends  \
   		tk		\
		libvncserver1 	\
    && apt-get clean


# Add all lib for tigervnc
RUN apt-get update &&  apt-get install -y --no-install-recommends  \
		libx11-6			\
		xkb-data			\
		x11-xkb-utils			\
		xauth				\
		libfile-readbackwards-perl 	\
		netbase				\
		libaudit1			\
		libbsd0				\
		libgcrypt20			\
		libgl1				\
		libgnutls30			\
		libturbojpeg			\
		libjpeg8			\
		libpam0g			\
		libpixman-1-0			\
		libselinux1			\
		libstdc++6 			\
		libsystemd0 			\
		libunwind8 			\
		libxau6 			\
		libxdmcp6 			\
		libxfont2 			\
		zlib1g 				\
		libgl1-mesa-dri 		\
		x11-xserver-utils		\  
		xfonts-scalable  		\      
    && apt-get clean


# source for tiger vnc is 
# https://bintray.com/tigervnc/stable/download_file?file_path=tigervnc-1.10.1.x86_64.tar.gz
# RUN cd /tmp &&	\
#	wget "https://bintray.com/tigervnc/stable/download_file?file_path=tigervnc-1.11.0.x86_64.tar.gz" -O /tmp/tigervnc-1.11.0.x86_64.tar.gz && \

COPY	tigervnc-1.11.0.x86_64.tar.gz /tmp
RUN	( 	apt install tigervnc-standalone-server=1.11.0+dfsg-2 || 						\ 
		( cd /tmp && tar -xvf tigervnc-1.11.0.x86_64.tar.gz && cp -r tigervnc-1.11.0.x86_64/usr/* /usr/ ) 	\
	) && rm -rf /tmp/tigervnc*

# ADD package for mimeopen used by spawner-service to detect application from a mimetype
# xclip is used by spwaner
# kterminal is used for built-in terminal
# desktop-file-utils desktop-file-utils contains a few command line utilities for working with desktop entries
RUN apt-get update &&  apt-get install -y --no-install-recommends  \
		nautilus			\
        	python3-nautilus			\
		python3-shellescape		\	
        	libfile-mimeinfo-perl		\
        	xclip  				\
		desktop-file-utils		\
		shared-mime-info		\
		imagemagick			\
		eterm				\
        	qterminal			\
		xdg-user-dirs			\
    && apt-get clean


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
	&& apt-get clean

# krb5 is set in etc no need to copy 
# ADD krb5.conf  /etc

# apt install iproute2 install ip command
# iputils-ping and vin can be removed
RUN apt-get update && apt-get install -y --no-install-recommends	\
		iputils-ping			\
		iproute2			\
    && apt-get clean

# this package nodejs include npm 
RUN curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - \ 
	&& apt-get update && 				\
	apt-get install -y --no-install-recommends	\
        	nodejs					\
        && apt-get clean

RUN apt-get update && apt-get install -y	\
        dbus					\
        dbus-x11				\
        && apt-get clean
