#!/bin/bash
read -p "請輸入repo名稱（帳號）：" id
read -p "請輸入應用名稱：" name
read -p "請輸入版本號：" ver
echo "產出命令\"docker build -t iii-docker/flask:$ver .\""
echo "命令執行中................."
docker build -t $id/$name:$ver .
