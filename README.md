感谢原作者，在原作者基础上更新了KodExplorer版本，修复AriaNg链接问题，重新打包上传镜像

### Docker + debian + Aria2 + KodExplorer

#### default ENV

* `RPC_PORT` `6800`
* `KODE_PORT` `80`
* `ARIANG_PORT` `6801`
* `RPC_SECRET` `123456`
* `GOSU_VERSION` `1.11`
* `KODE_VERSION` `4.39`
* `ARIANG_VERSION` `1.0.1`


#### run default aria2 docker

```
$ docker run --name kode -d -p 6800:6800 -p 6801:6801 -p 6860:80 tozehu/debian-aria2-kode
```

#### run custom aria2 docker

```
$ docker run --name kode -d -e "RPC_PORT=6820" -e "RPC_SECRET=987654" -p 6821:6820 -p 6822:6801 -p 6860:80 -v /home/tiger/kode:/app tozehu/debian-aria2-kode
```
