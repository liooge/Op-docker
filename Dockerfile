# 使用官方的 Ubuntu 基础镜像
FROM ubuntu:20.04

# 设置环境变量，防止交互式安装
ENV DEBIAN_FRONTEND=noninteractive

# 更新包列表并安装必要的依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    wget \
    build-essential \
    yasm \
    pkg-config \
    libpng-dev \
    libjpeg-dev \
    libx264-dev \
    libx265-dev \
    libnuma-dev \
    libvpx-dev \
    libfdk-aac-dev \
    libmp3lame-dev \
    libopus-dev \
    git \
    cmake \
    autoconf \
    automake \
    libtool \
    zlib1g-dev \
    nasm \
    libass-dev \
    libfreetype6-dev \
    libvorbis-dev \
    libxvidcore-dev \
    curl \
    apngasm \
    libbluray-dev \
    libcdio-dev \
    libebur128-dev \
    libfontconfig1-dev \
    libfribidi-dev \
    libgnutls28-dev \
    libgme-dev \
    libgsm1-dev \
    libopenjp2-7-dev \
    libopenmpt-dev \
    libpulse-dev \
    librubberband-dev \
    libshine-dev \
    libsnappy-dev \
    libsoxr-dev \
    libspeex-dev \
    libssh-dev \
    libtheora-dev \
    libtwolame-dev \
    libwavpack-dev \
    libwebp-dev \
    libzmq3-dev \
    libzvbi-dev \
    libopenal-dev \
    libgl1-mesa-dev \
    libsdl2-dev \
    libdc1394-22-dev \
    libiec61883-dev \
    frei0r-plugins-dev \
    libopencv-dev \
    libchromaprint-dev \
    libaom-dev \
     && apt-get clean && rm -rf /var/lib/apt/lists/*
     
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"


# 编译安装 FFmpeg
RUN mkdir /ffmpeg_sources && \
    cd /ffmpeg_sources && \
    git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg && \
    cd ffmpeg && \
    ./configure \
    --enable-gpl \
    --enable-libx264 \
    --enable-libx265 \
    --enable-libvpx \
    --enable-libfdk-aac \
    --enable-libmp3lame \
    --enable-libopus \
    --enable-libvorbis \
    --enable-libass \
    --enable-libfreetype \
    --enable-nonfree \
    --disable-stripping \
    --enable-gnutls \
    --enable-libbluray \
    --enable-libfontconfig \
    --enable-libfribidi \
    --enable-libgme \
    --enable-libgsm \
    --enable-libopenjpeg \
    --enable-libopenmpt \
    --enable-libpulse \
    --enable-librubberband \
    --enable-libshine \
    --enable-libsnappy \
    --enable-libsoxr \
    --enable-libspeex \
    --enable-libssh \
    --enable-libtheora \
    --enable-libtwolame \
    --enable-libwebp \
    --enable-libxvid \
    --enable-libzmq \
    --enable-libzvbi \
    --enable-sdl2 \
    && make -j$(nproc) && \
    make install && \
    make clean && \
    hash -r

ENV RUSTFLAGS="-C target-feature=+crt-static"

RUN git clone --recursive https://github.com/kornelski/pngquant.git && \
    cd pngquant && \
    RUSTFLAGS="-C target-feature=+crt-static" cargo build --release --target aarch64-unknown-linux-gnu && \
    cp target/release/pngquant /usr/local/bin/pngquant && \
    cd .. && \
    rm -rf pngquant && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --recursive https://github.com/sayanarijit/xplr.git && \
    cd xplr && \
    RUSTFLAGS="-C target-feature=+crt-static" cargo build --release --target aarch64-unknown-linux-gnu && \
    cp target/release/xplr /usr/local/bin/xplr && \
    cd .. && \
    rm -rf xplr && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --recursive https://github.com/Chleba/netscanner.git && \
    cd netscanner && \
    RUSTFLAGS="-C target-feature=+crt-static" cargo build --release --target aarch64-unknown-linux-gnu && \
    cp target/release/netscanner /usr/local/bin/netscanner && \
    cd .. && \
    rm -rf netscanner && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --recursive https://github.com/imsnif/bandwhich.git && \
    cd bandwhich && \
    RUSTFLAGS="-C target-feature=+crt-static" cargo build --release --target aarch64-unknown-linux-gnu && \
    cp target/release/bandwhich /usr/local/bin/bandwhich && \
    cd .. && \
    rm -rf bandwhich && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /workspace

# 设置默认命令
CMD ["bash"]
