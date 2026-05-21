FROM m.daocloud.io/docker.io/debian:latest as builder
RUN apt update -y
RUN apt install -y apt-transport-https lsb-release ca-certificates
RUN apt install -y build-essential clang unzip xmake
# RUN pip install conan
ENV project_path /data/shadow/
COPY / ${project_path}
WORKDIR ${project_path}
RUN xmake f --root -k static -y -p linux -a x64 -m release
RUN xmake --root -w coroutine

FROM m.daocloud.io/docker.io/debian:latest as runner
WORKDIR /opt/shadow/engine/
COPY --from=builder /data/shadow/build/linux/x64/release/* ./
VOLUME ["/opt/shadow/engine/conf/","/opt/shadow/engine/log/"]
CMD ["/opt/shadow/coroutine /opt/shadow/engine/conf/world"]
