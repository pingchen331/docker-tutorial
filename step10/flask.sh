#!/bin/bash
read -p "請輸入IMAGE資訊：" image
echo "開始執行\"docker run -d --name flask --rm -p 5000:5000 $image\""
docker run -d --name flask --rm -p 5000:5000 $image
echo "執行完成！"
docker ps 
