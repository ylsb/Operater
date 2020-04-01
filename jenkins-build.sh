#集成操作:根据当前工作区的Dockerfile构建最新版的镜像，镜像的tag为当前此项目的git版本号,并推到项目下
#!/bin/sh

#创建Dockerfile
cat >Dockerfile<<EOF

#从harbor仓库拉去基础镜像
FROM {your_harbor_ip}/xxx/python-service:base
LABEL maintainer="Commaaiops Docker Maintainers <xxx>"
WORKDIR /python-service
COPY ./ /python-service
RUN xxxxxxxx
STOPSIGNAL SIGTERM
EXPOSE 360
CMD  python3 main.py -v "$(git rev-parse --short HEAD)"
EOF

#构建该版本镜像，上传harbor
docker build -t {your_harbor_ip}/xxx/$JOB_NAME:v1 .
docker push {your_harbor_ip}/xxx/$JOB_NAME:v1
