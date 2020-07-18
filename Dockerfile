FROM ghokun/opencv:latest
LABEL maintainer="ghokun.github.io"

ARG DEBIAN_FRONTEND="noninteractive"
ARG LLVM=11
ENV HOME="/config" \
  LANGUAGE="en_US.UTF-8" \
  LANG="en_US.UTF-8" 

# Install code-server
RUN \
  echo "**** install node repo ****" && \
  apt-get update && \
  apt-get install -y \
  gnupg && \
  curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
  echo 'deb https://deb.nodesource.com/node_12.x bionic main' \
  > /etc/apt/sources.list.d/nodesource.list && \
  curl -s https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo 'deb https://dl.yarnpkg.com/debian/ stable main' \
  > /etc/apt/sources.list.d/yarn.list && \
  echo "**** install build dependencies ****" && \
  apt-get update && \
  apt-get install -y \
  build-essential \
  libx11-dev \
  libxkbfile-dev \
  libsecret-1-dev \
  pkg-config && \
  echo "**** install runtime dependencies ****" && \
  apt-get install -y \
  git \
  wget \
  jq \
  nano \
  net-tools \
  nodejs \
  sudo \
  yarn && \
  echo "**** install code-server ****" && \
  if [ -z ${CODE_RELEASE+x} ]; then \
  CODE_RELEASE=$(curl -sX GET "https://api.github.com/repos/cdr/code-server/releases/latest" \
  | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  CODE_VERSION=$(echo "$CODE_RELEASE" | awk '{print substr($1,2); }') && \
  yarn --production global add code-server@"$CODE_VERSION" && \
  yarn cache clean && \
  ln -s /node_modules/.bin/code-server /usr/bin/code-server && \
  echo "**** clean up ****" && \
  apt-get purge --auto-remove -y \
  build-essential \
  libx11-dev \
  libxkbfile-dev \
  libsecret-1-dev \
  pkg-config && \
  apt-get clean && \
  rm -rf \
  /tmp/* \
  /var/lib/apt/lists/* \
  /var/tmp/*

# Install clangd and clang-tidy from the public LLVM PPA (nightly build / development version)
# and the GDB debugger from the Ubuntu repos
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
  && echo "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic main" > /etc/apt/sources.list.d/llvm.list \
  && apt-get update \
  && apt-get install -y \
  clang-tools-$LLVM \
  clangd-$LLVM \
  clang-tidy-$LLVM \
  gcc-multilib \
  g++-multilib \
  && gdb  \
  && pkg-config \
  && apt-get clean \
  rm -rf \
  /tmp/* \
  /var/lib/apt/lists/* \
  /var/tmp/* \
  && ln -s /usr/bin/clang-$LLVM /usr/bin/clang \
  && ln -s /usr/bin/clang++-$LLVM /usr/bin/clang++ \
  && ln -s /usr/bin/clang-cl-$LLVM /usr/bin/clang-cl \
  && ln -s /usr/bin/clang-cpp-$LLVM /usr/bin/clang-cpp \
  && ln -s /usr/bin/clang-tidy-$LLVM /usr/bin/clang-tidy \
  && ln -s /usr/bin/clangd-$LLVM /usr/bin/clangd

RUN ln -s /usr/local/include/opencv4/opencv2 /usr/local/include/opencv2 \
  && ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime

# add local files
COPY /root /

# ports and volumes
EXPOSE 8443