#!/bin/bash
read -p "輸入IMAGE名稱「EX：repo/應用:版本」：" image
read -p "請輸入容器命名：" name
docker run -d --rm --name $name -p 5000:5000 -p 8888:8888 $image
