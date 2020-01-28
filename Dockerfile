FROM rust:latest

WORKDIR /setup

# aput update
RUN apt -y update

# Add cross compilation target for RISC-V
RUN rustup target add riscv32imac-unknown-none-elf

# Install riscv-gnu-toolchain
RUN apt -y install \
    autoconf \
    automake \
    autotools-dev \
    curl \
    libmpc-dev \
    libmpfr-dev \
    libgmp-dev \
    gawk \
    build-essential \
    bison \
    flex \
    texinfo \
    gperf \
    libtool \
    patchutils \
    bc \
    zlib1g-dev \
    libexpat-dev
RUN git clone --recursive https://github.com/riscv/riscv-gnu-toolchain
RUN cd riscv-gnu-toolchain && \
    ./configure --prefix=/opt/riscv --with-arch=rv32gc --with-abi=ilp32 && \
    make linux
ENV PATH $PATH:/opt/riscv/bin

# Install qemu
RUN apt -y install \
    libglib2.0-dev \
    libfdt-dev \
    libpixman-1-dev \
    zlib1g-dev
RUN wget https://download.qemu.org/qemu-3.0.0.tar.xz && \
    tar xf qemu-3.0.0.tar.xz && \
    cd qemu-3.0.0/ && \
    mkdir build && \
    cd build/ && \
    ../configure --target-list=riscv32-softmmu --prefix=/opt/qemu-riscv && \
    make && \
    make install
ENV PATH $PATH:/opt/qemu-riscv/bin

WORKDIR /source
CMD ["bash"]
