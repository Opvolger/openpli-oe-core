FROM ubuntu:20.04

# 
RUN apt-get update && DEBIAN_FRONTEND='noninteractive' apt-get upgrade -y && \
  DEBIAN_FRONTEND='noninteractive' apt-get install -y sed wget cvs subversion git-core \
  coreutils unzip texi2html texinfo docbook-utils \
  gawk python-pysqlite2 diffstat help2man make gcc build-essential g++ \
  desktop-file-utils chrpath default-jre gettext zip libssl-dev

RUN DEBIAN_FRONTEND='noninteractive' apt-get install -y cpio locales python3-distutils

ENV MACHINE="h9"
ENV ENIGMA2_BRANCH="develop"
ENV MAKE_INSTRUCTION="image"

RUN echo "cd openpli-oe-core && ENIGMA2_BRANCH=\${ENIGMA2_BRANCH} MACHINE=\${MACHINE} make \${MAKE_INSTRUCTION}" > dockerbuild.sh

RUN chmod 777 dockerbuild.sh

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8     

ARG UNAME=builder
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID -o $UNAME
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME

USER $UNAME

CMD [ "sh", "dockerbuild.sh" ]
