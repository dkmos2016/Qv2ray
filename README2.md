


### build Qv2ray for linux
#### build grpc & grpc++ 
``` shell
# Grpc Version: 1.49.x

cd /workspace
# 构建grpc grpc++以及安装依赖包
bash env.sh
```
#### build Qv2ray 
``` shell

cd QV2ray
# 使用build.sh进行构建和打包
bash build.sh
```