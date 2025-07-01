ARG VER=20.04
FROM registry.cn-shenzhen.aliyuncs.com/infrasync/v2025:library--ubuntu---${VER}
ARG TARGETPLATFORM
ENV \
  DEBIAN_FRONTEND=noninteractive
RUN \
  # sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources; \
  sudo apt update; sudo apt remove git; sudo apt autoremove; \
  # ubt-latest: E: Package 'python3-distutils' has no installation candidate
  sudo apt install -y git build-essential uuid-dev iasl git nasm python3-distutils gcc-aarch64-linux-gnu

RUN \
  mkdir -p workspace-edk2; cd workspace-edk2; \
  git config --global protocol.file.allow always; \
  git clone https://github.com/tianocore/edk2.git -b edk2-stable202002 --recursive --depth=1; \
  git clone https://github.com/tianocore/edk2-platforms.git -o cfdc7f907d545b14302295b819ea078bc36c6a40 --recursive --depth=1; \
  git clone https://github.com/strongtz/edk2-rk3399;
        
RUN \
    cd workspace-edk2/edk2-rk3399; \
    bash build.sh --device polaris; \
    ls -lh workspace-edk2/edk2-rk3399/workspace/Build/sdm845Pkg/DEBUG_GCC5/FV/SDM845PKG_UEFI.fd