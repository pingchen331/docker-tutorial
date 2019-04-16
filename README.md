**Dropbox Paper 講義：** https://paper.dropbox.com/doc/Docker--AbW03wZ~vAXgW0JY_OfaRcQPAQ-DQsqCQF3CY7PdHe5mnG92  
Docker安裝
安裝方式可以參考官方文件：https://docs.docker.com/install/linux/docker-ce/centos/
本範例以Centos 進行操作
切換到docker-tutorial/step0資料夾

    cd docker-tutorial/step0

執行`dockerinstall.sh`

    ./dockerinstall.sh

dockerinstall.sh

    #從docker官方下載安裝腳本檔並執行
    curl -fsSL get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    #安裝完成，開啟(start)及預設開啟(enable)docker服務
    sudo systemctl start docker.service
    sudo systemctl enable docker.service
    #將現在使用者加入docker群組，具備操作docker的權限(不用sudo)
    sudo usermod -aG docker `whoami`

完成後exit退出連線並重新登入

Docker Cli 操作示範

Step1: Docker Hello World

    # 所有的學習都是從hello-world開始的（笑）
    # 開始Docker的hello-world
    # 試試ㄒㄧ下下面的指令：
    docker run hello-world
    #如果你非常懶惰的話...
    ./step1.sh
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1544689550859_image.png)


docker run
Step2: 第一次docker run
試想：我們今天需要一個python3.7的測試環境，但是本機只有python2.7，你可以怎麼做？
(A)升級本機的python環境→可能導致很多與python相依的服務(例如yum…等)錯誤，修改設定麻煩。
(B)用pipenv創立虛擬環境→設定繁瑣，還是很麻煩。
(C)直接用Docker開一個Container，測試完畢後關閉並刪除→開啟方便快速，用完即刪，選我選我。
現在，讓我們來嘗試一下
用docker快速開啟一個python3.7的環境

    docker run -it --rm python:3.7 /bin/bash
    #謎之音：docker 我需要一個python3.7的環境，我需要交互模式進行互動(-it)，用完即丟(--rm)，環境開啟之後進到/bin/bash。
    #再次
    提供偷懶腳本
    ./step2.sh
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1544691778887_image.png)

環境開啟後，我們來測試一下python版本
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1544691847475_image.png)

step3: 參數介紹：-v(--volume list)參數
環境開好了，該怎麼把

程式碼放進去呢？

-v 參數可以把在本機的指定資料夾掛載到容器內，讓本機與容器資料同步，常常用來處理設定檔，程式碼…運行服務時需要的檔案及資料夾。
目標：
將code資料夾掛載到container內/tpm位置，並改名為py_code
python開啟py_code資料夾內的hello.py並查看運行結果
開啟容器：
    docker run -it --rm -v $(pwd)/code:/tmp/py_code python:3.7 /bin/bash
    #偷懶專用
    ./step3.sh

查看/tmp下有沒有py_code資料夾及hello.py

![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1544695613546_image.png)


執行hello.py，並查看運行結果：

    python /tmp/py_code/hello.py
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1544695702508_image.png)


沒錯～～又是Hello-world
step4：-p (--publish list)端口映射
現在，我們已經可以把程式碼放進去container內了，接下來我們想在container內運行一個Flask服務，讓我們試試看吧。

    docker run -it --rm -v $(pwd)/code:/tmp/py_code python:3.7 /bin/bash
    #偷懶
    ./step4.sh

進入container 後安裝flask

    pip
    pip install flask==0.12
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1544859487633_image.png)


container ip查詢

    ip a
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1544859858844_image.png)


運行程式碼

    python /tmp/py_code/app.py
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1544859685934_image.png)


在本機（虛擬機)內使用瀏覽器或curl工具連線`continer-ip:5000`
瀏覽器：pi

![](/static/img/pixel.gif)


Ｃurl

![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1544860274893_image.png)


如果想要開放外網連線呢？ 我們必須要用到iptables 進行轉址

    sudo iptables -t nat .......................... 指令實在太長了 很麻煩

所以 docker 提供我們一個簡單的參數 <-p>，我們可以用-p參數來做端口映射，省去前面麻煩的內容，專注於開發及部署。
再一次重新開始吧！！

    docker run -it --rm -v $(pwd)/code:/tmp/py_code -p 5000:5000 python:3.7 /bin/bash 

進入container後

    pip install flask
    python /tmp/py_code/app.py

直接從本機瀏覽器瀏覽`192.168.56.111:5000`

![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1544860864310_image.png)


這樣是不是簡單多了呢！！！

![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1544860976731_image.png)


其實< -p >這個參數，就是讓docker自動幫我們做iptables 的動作

![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1544861284030_image.png)


補充 docker run 可以基於bash 或sh 進行多行指令：
每次都要進入container再安裝flask太麻煩了，有沒有辦法可以在docker run 執行的時候順便安裝並開啟app.py呢？
答案是：YES!
試試下面的指令：
‘docker run -it --rm -v $(pwd)/code:/tmp/py_code -p 5000:5000 python:3.7 /bin/bash -c 'pip install flask==0.12 && python /tmp/py_code/app.py'

    #bash -c: 讓bash 後面的指令已字串讀入，並以&&做區隔
    #偷懶：
    ./try.sh
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1544863432401_image.png)


step5 docker run 其他參數：
-d, --detach：前面我們已經可以用一個指令安裝Flask並執行app.py了，如果我們不想上她佔用我們的畫面的話，我們可以用-d讓他在背景執行。

    docker run -dit --rm -v $(pwd)/code:/tmp/py_code -p 5000:5000 python:
    3.7 /bin/bash -c 'pip install flask==0.12 && python /tmp/py_code/app.py'
    #偷懶：
    ./detach.sh

--name：當我們有很多個container 時可以針對個別container進行命名，這樣就不用每次都要查`container_id`了

    docker run -dit --rm --name flask_test -v $(pwd)/code:/tmp/py_code -p 5000:5000 python:3.7 /bin/bash -c 'pip install flask==0.12 && python /tmp/py_code/app.py'
    #偷懶：
    ./name.sh
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545030162828_image.png)


docker run 小結整理
指令：docker run [參數] <image> <命令>

    docker run -dit --name flask --rm -v $(pwd)/code:/code -p 5000:5000 python:3.6 /bin/bash -c 'pip install flask==0.12 && python /tmp/py_code/app.py'
    常用參數：
    -v, --volume list 在容器中掛載檔案（或資料夾）
    -p, --publish list：端口(Port)映射，格式<本地端口>:<容器端口>
    -it：互動式tty，交互互動模式
    --rm：容器結束後自動刪除。
    
    
    -d, --detach：背景執行，不顯示log
    --name：容器命名，命名為唯一不可重複
    --restart：如果容器運行失敗，重新運行。

Step6：docker exec：連入已開啟的容器。
現在我們有一個容器正在背景執行，如果我們想要連入進行操作，該怎麼做呢？
這時候我們就需要用到`docker exec`這個指令了
連入容器：

    docker exec -it flask_test /bin/bash
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545033019462_image.png)


或是，直接讓容器執行指定命令：

    docker exec flask_test echo "HI"
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545033063866_image.png)


其他：對docker 容器進行操作

- kill/stop：停止
  - 指令：docker kill/stop <container_id>/<container_name>
  - 區別：stop 會按照程序停止；kill 會強制停止
    docker kill flask_test
    docker stop flask_test
- start/restart：開啟
  - 指令：docker start/restart <container_id>/<container_name>
  - 兩個都是開啟的意思，通用
    docker start flask_test
    docker restart flask_test
- rm：刪除
  - 完全刪除容器（容器內的資料不會被保留！！）
  - 有需要留存的資料須先放到-v所mapping的資料夾內。
  - docker rm <container_id>/<container_name>
    docker rm flask_test

docker 查詢
針對容器進行查詢：docker ps：
前面，我們把我們的docker背景執行了，那我們要怎麼查看container現在有沒有在運行呢？試試`docker ps`這個指令吧。

    docker ps <參數>
    -a 查看所有（包括停止）的容器
    -q 只顯示容器的 id，常搭配docker kill或docker rm 使用。
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545034919113_image.png)

Step7：Dockerfile：訂製Image

Dockerfile基本介紹
前面，我們有提到過VM常會遇到的問題：我們無法很明確的知道誰對這台虛擬機做了什麼，是不是有人更改過檔案或設定。在前面練習`docker run`或`docker exec`的過程中，似乎也沒有解決相對應的問題，因此我們需要用dockerfile來統一我們對image所做的設定，進而達到Infrastructure-as-code (IaC) 的目的。

> Dockerfile是一個文本文件，其內包含了一條條的指令(Instruction)，每一條指令構建一層，因此每一條指令的內容，就是描述該層應當如何構建。
> 在Dockerfile註解使用”#”字號

FROM：指定基礎鏡像

> FROM：所謂定製鏡像，那一定是以一個鏡像為基礎，在其上進行定制。就像我們之前運行了一個`nginx`鏡像的容器，再進行修改一樣，基礎鏡像是必須指定的。而`FROM`就是指定基礎鏡像，因此一個`Dockerfile`中`FROM`是必備的指令，並且必須是第一條指令。

將前面的`docker run` Image 的部分寫成dockerfile會變成這樣：

    #基於IMAGE python:3.7
    FROM python:3.7

RUN：執行命令

> RUN指令是用來執行命令行命令的。由於命令行的強大能力，`RUN`指令在定製鏡像時是最常用的指令之一。

前面，我們在練習`docker run`的時候，每一次都需要先安裝flask，那我們可不可以基於Dockerfile的概念，建構一個有以`python:3.7`為基礎，並安裝好flask的Image呢？

    #基於IMAGE python:3.7
    FROM python:3.7
    #安裝Flask 0.12版
    RUN pip install flask==0.12
- 在dockerfile中使用RUN的重要概念：
  - 前面有提到dockerfile會“每一條指令構建一層”，因此使用RUN時應該把相應的指令寫在同一層，減少容器建構時的程序及佔用的空間。
- 舉例：在安裝flask之前我們想要先更新apt-get套件庫，並使用pip安裝flask 0.12版本及使用apt-get安裝vim方便做程式碼的編輯。
  - 錯誤示範：
    #基於IMAGE python:3.7
    FROM python:3.7
    ##更新apt套件庫
    RUN apt-get update -qq
    ##安裝Flask 0.12版
    RUN pip install -q flask==0.12
    #安裝vim
    RUN apt-get install vim -qqy
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545131297477_image.png)

  - 正確寫法
    #基於IMAGE python:3.7
    FROM python:3.7
    ##更新apt套件庫、安裝Flask 0.12版、安裝VIM
    RUN apt-get update -qq \
        && pip install -q flask==0.12 \
        && apt-get install vim apt-utils -qqy
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545131288946_image.png)


ADD：複製文件
更進一步，每次都要用-v 掛載實在是太麻煩了，如果我們想要把我們的程式碼包進去Image中，可不可以呢？
這時候需要用到ADD語法

    #基於IMAGE python:3.7
    FROM python:3.7
    #更新apt套件庫、安裝Flask 0.12版、安裝VIM
    RUN apt-get update -qq \
        && pip install -q flask==0.12 \
        && apt-get install vim apt-utils -qqy
    #將./code複製到image的/tmp內，並重新命名為py_code
    COPY ./code /tmp/py_code
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545132109972_image.png)

![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545132300339_image.png)

- 使用ADD功能須謹慎，尤其是可能會將IMAGE公開（上傳到github、docker hub….等平台)，上傳前需檢查是否包含一些私人資訊，如：帳號、密碼、key等不應該暴露在公共環境下的訊息。
- 如果加入的檔案為壓縮檔，例如`.tar`、`.tar.xz`docker 會在build的時候自行解壓縮。

WORKDIR：預設工作目錄
開啟容器後我們有可能需要編輯app.py檔案，每次都要切換到`/tmp/py_code`實在是太麻煩了，而且，當把image給別人時，還要特別交代程式碼放在哪邊，有沒有更便捷的方法呢？
我們可以使用WORKDIR來預設工作目錄，當容器啟動時，會自動切換到我們指定的目錄，如此方便許多。

    #基於IMAGE python:3.7
    FROM python:3.7
    #更新apt套件庫、安裝Flask 0.12版、安裝VIM
    RUN apt-get update -qq \
        && pip install -q flask==0.12 \
        && apt-get install vim apt-utils -qqy
    #將./code複製到image的/tmp內，並重新命名為py_code
    COPY ./code /tmp/py_code
    #切換到預設工作目錄/tmp/py_code
    WORKDIR /tmp/py_code
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545133355683_image.png)

![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545133423070_image.png)


ENV：設置環境變數
這個指令很簡單，就是設置環境變數而已，無論是後面的其它指令，如`RUN`，還是運行時的應用，都可以直接使用這裡定義的環境變數。
EX：在撰寫Dockerfile時將Flask版本以變數的方式呈現，方便後續做修改。

    #基於IMAGE python:3.7
    FROM python:3.7
    #添加FLASK_VER為環境變數，並設置版本為0.12
    ENV FLASK_VER 0.12
    #更新apt套件庫、安裝Flask，版本由FLASK_VER讀入、安裝VIM
    RUN apt-get update -qq \
        && pip install -q flask==$FLASK_VER \
        && apt-get install vim -qqy
    #將./code複製到image的/tmp內，並重新命名為py_code
    COPY ./code /tmp/py_code
    #切換到預設工作目錄/tmp/py_code
    WORKDIR /tmp/py_code
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545134119802_image.png)

![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545134248538_image.png)


CMD：預設開啟container執行的動作
我們可以透過CMD的指令，來指定開啟container後預設的動作，如下：

    #基於IMAGE python:3.7
    FROM python:3.7
    #添加FLASK_VER為環境變數，並設置版本為0.12
    ENV FLASK_VER 0.12
    #更新apt套件庫、安裝Flask，版本由FLASK_VER讀入、安裝VIM
    RUN apt-get update -qq \
        && pip install -q flask==$FLASK_VER \
        && apt-get install vim apt-utils -qqy
    #將./code複製到image的/tmp內，並重新命名為py_code
    COPY ./code /tmp/py_code
    #切換到預設工作目錄/tmp/py_code
    WORKDIR /tmp/py_code
    #預設開啟container時執行app.py
    CMD python ./app.py
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545138258404_image.png)

- 如果執行`docker run` 時有指定動作，會自動忽略CMD該執行的動作。如下：
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545138189750_image.png)


dockerfile小結：
透過dockerfile自訂IMAGE我們將原本冗長的指令

    docker run -idt --rm --name flask -v $(pwd)/code:/tmp/py_code -p 5000:5000 python:3.7 /bin/bash -c 'pip install flask==0.12 && python /tmp/py_code/app.py'

縮減成

    docker run -d --rm --name flask -p 5000:5000 <image>

是不是簡潔及快速多了呢？

Step8：撰寫Dockerfile

由於用VIM寫python實在太麻煩了，因此我們改用jupyter/base-notebook作為python的開發環境，試著寫一個以Jupyter/base-notebook為基礎的dockerfile。

- Dockerfile
  - 用pip更新pip版本
  - 用pip安裝flask0.12版、requests
  - 預設工作目錄為/home/jovyan/work
  - 預設執行start-notebook.sh --NotebookApp.token=''禁用所有身份驗證機制
- docker run
  - 映射5000及8888 port
  - 映射code資料夾到/home/jovyan/work

dockerfile

    FROM jupyter/base-notebook
    #使用pip 套件庫更新pip 並安裝flask 0.12 requests
    RUN pip install --upgrade pip \
     && pip install flask==0.12 requests
    #指定預設工作目錄/home/jovyan/work
    WORKDIR /home/jovyan/work
    #開啟notebook並設定token為空
    CMD start-notebook.sh --NotebookApp.token=''
Docker image相關操作
build

撰寫完dockerfile後我們需要建構image，這時候需要用到`docker build`指令
指令：docker build [參數] <dockerfile位置>
回到step7試試第一次寫的docker file吧

    docker build -t iii_docker/flask:0.1 .
    . 在同一層資料夾尋找檔名為dockerfile的檔案構建
    常用參數：fl
    -t：給images 加上標籤，一般建議格式為 <docker hub帳號>/<IMAGE名稱>:<版本>
    偷懶一點：
    ./build.sh
- dockerfile 每一條指令都會建構一層
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545536332361_image.png)


探討幾個問題：
Q1. 不加上tag會怎麼樣？

  > build還是會正常執行，但是<REPOSITORY>及<TAG>會變成<none>造成管理問題。

Q2. 不加上版本號呢？

  > 不加上版本號預設會是latest，但是當下次以相同的TAG構建時，這一版的TAG會被取消。

Q3. 一定要叫做dockerfile嗎？

  > 如果有多個dockerfile檔案放在同一個資料夾內，可以使用`-f`參數，指定dockerfile
  > EX：docker build -t test/test:0.1 test ./code
docker images管理與操作

針對映像檔(image)進行查詢：docker images：
前面，我們提到docker 容器都是基於映像檔(image)所建構的，那我們該如何管理本機的映像檔呢？
Docker 提供了`docker images`這個指令讓我們進行映像檔查詢

    docker images [參數] [REPOSITORY][:TAG]
    -q 只顯示映像檔id，通常配合docker rmi 批次刪除映像檔。
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545035921325_image.png)


針對映像檔(image)進行刪除：docker rmi：
使用docker越久，本機內一定會有很多用不到的映像檔，是時候來個大掃除了，這時候我們使用`docker rmi`這個指令，來刪除用不到的映像檔。
指令：docker rmi <參數> <IMAGE ID>/<REPOSITORY>:<TAG>

- 常用參數：-f 強制刪除
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545036132063_image.png)

![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545036181069_image.png)

> 註1：移除image前，要先移除相要先移除相對應的container
> 註2：如果image的TAG為latest，可以不加上<TAG>
> 註3：當一個image有多個tag時，使用`image id`無法直接移除，若要強制移除，使用`-f`參數

docker tag 貼個標籤吧
我們在build的時候會用`-t`來加入Tag，方便我們整理。但是，實務上我們可能需要不只一個Tag，那我們可不可以對一個IMAGE下多個Tag呢?
這時候可以使用`docker tag`這個指令來對image新增Tag
指令：docker tag <原本IMAGE資訊(REPO:TAG 或是ID> <新的TAG資訊>

    例如：
    docker tag jupyter/base-notebook:latest pynb
    也可以用IMAGE ID
    docker tag 8253370cbe2d jupyter
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545541368763_image.png)


TAG常用的應用場景：版本複雜時，可以對大版本及最後版本下標籤，方便管理
TAG的移除
移除Tag使用docker rmi 指令，例如：

    docker rmi jupyter:latest 
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545541809530_image.png)

- 當一個IMAGE存在多個標籤的時候`docker rmi`當作移除標籤使用
- 當對象為唯一標籤時，`docker rmi`會直接刪除IMAGE
- 用`docker rmi`移除標籤時”不可以使用`IMAGE ID`”
Image匯入匯出

Step9：docker image 本地環境匯入匯出
dockerfile十分方便也便於攜帶，但是如果我們要到一個沒有網路的環境呢？
 我們可以先將我們製作好的IMAGE包成`.tar`檔匯出，到我們的目標主機再匯入。
 這樣做的好處是包裝好的tar檔解壓後的環境，跟我們原本製作的環境一樣，而且不需要像Dockerfile建構的時候有些更新或安裝套件的命令還需要聯網。

- 匯出：
  - 指令：docker save -o <匯出的檔名> <IMAGE資訊或ID>
  - 不建議使用`IMAGE ID`做匯出，TAG資訊會消失
    EX:使用IMAGE資訊
    docker save -o python3.7.tar python:3.7
    或用IMAGE ID
    docker save -o python3.7.tar 1e80caffd59e 
- 匯入
  - 指令：docker load < `xxx.tar檔`
        docker load --input `xxx.tar檔`
    EX:
    docker load < python3.7.tar
    docker load --input python3.7.tar
- docker load 如果出現重複名稱時系統的處理方式
  - 現存的IMAGE 建構時間較舊：會被直接覆蓋
  - 現存的IMAGE 建構的時間較新：現存的IMAGE會被untag，load的檔案會生成指定的IMAGE
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545552372990_image.png)


練習：
先將剛剛做的jupyter 用`docker save`打包，打包完成後，用`docker rmi`刪除原本的IMAGE，再用`docker load`匯入`.tar`檔。

![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545552782579_image.png)

    #偷懶用
    #step9資料夾
    #匯出
    ./save.sh
    #刪除
    ./rm.sh
    #匯入
    ./load.sh

將IMAGE上傳到docker hub
如果，我們今天想把我們製作的IMAGE公開出去我們有兩種方式：

  - 用上面提到的`docker save`指令，把我們的IMAGE打包成`tar`檔，放到雲端空間上在給出連結，讓人下載。
  - 上傳到docker hub

上傳到docker hub有什麼好處呢：

  - 可以直接使用docker run 指定IMAGE docker 會自動下載匯入並使用。

開始使用之前須先至docker hub進行註冊
註冊完成後，使用`docker login`登入到docker hub

    docker login
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545554170048_image.png)

- 上傳到docker hub
  - 現在讓我們試著把step7製作的flask IMAGE上傳到自己的docker hub吧！
  - 指令：docker push <docker hub 帳號>/<應用名稱>:<TAG>
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545554972191_image.png)

![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545554982503_image.png)

- 從docker hub 上抓取image

接著，我們試著把本機上的image刪除從docker hub上拉下我們剛上傳的image進行應用。

    #刪除image
    docker rmi <image>
    #從docker hub 上拉取image
    docker pull <image資訊>
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545555544178_image.png)

    #或是可以用docker run指定剛剛上傳的image
    docker run -d --rm --name flask -p 5000:5000 <image資訊>
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545555579679_image.png)

Step10：container互聯

前面，我們應用的都是單comtainer的應用，那如果我們的服務是需要用到一台以上的container呢？
EX：網頁服務需包含伺服器與資料庫，ELK須包含Elasticsearch、Logstash、 Kibana、Beats等服務。

> 容器的連接（linking）系統是除了連接埠映射外，另一種跟容器中應用互動的方式。該系統會在來源端容器和接收端容器之間創建一個隧道，接收端容器可以看到來源端容器指定的信息。
> 來源

假設：我們flask應用需要一個帶有https連線的url，這時候我們想要使用ngrok來幫我們進行轉址的動作，這時候我們該怎麼做？

- 在`docker run`指令下使用`--link`來達到兩台容器互聯的目的
    先開啟一個命名為flask的container：
    #偷懶 ./flask.sh
    docker run -d --name flask --rm -p 5000:5000 ping331/flask_test:0.1
    開啟一個ngrok的container：
    #偷懶 ./ngrok.sh
    docker run -d --rm --name ngrok -p 4040:4040 --link flask wernight/ngrok ngrok http flask:5000
    抓取ngrok的url：
    #偷懶 ./geturl.sh
    curl -s "localhost:4040/api/tunnels" | awk -F',' '{print $3}' | awk -F'"' '{print $4}' | awk -F'//' '{print $2}'

ngrok抓網址：+在docker宿主機上自動生成secret_key 

![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545560383076_image.png)

![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545560401330_image.png)

docker-compose
docker compose 介紹
> 之前有介紹過使用 `docker run` 指令就可以把 Docker Container 啟動起來，但是如果我們要啟動很多個 Docker Container 時，就需要輸入很多次 `docker run` 指令，另外 container 和 container 之間要做關聯的話也要記得它們之間要如何的連結(link) Container，這樣在要啟動多個 Container 的情況下，就會顯得比較麻煩。
> 因此就出現了 Docker-Compose，只要寫一個 `docker-compose.yml`，把所有要使用 Docker Image 寫上去，另外也可以把 Container 之間的關係連結(link)起來，最後只要下 `docker-compose up` 指令，就可以把所有的 Docker Container 執行起來，這樣就可以很快速和方便的啟動多個 container。
> 來源
- docker-compose是基於YMAL格式撰寫，非常注重階層的概念，而最大的忌諱就是不支持“tab”作為定位字元，這點需特別注意。

Step11：docker compose 安裝
至官網查看LINUX安裝方法

    #安裝
    sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    #權限
    sudo chmod +x /usr/local/bin/docker-compose
    #偷懶
    ./install-compose.sh

安裝完成後使用`docker-compose -v`查看版本及是否安裝成功

![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545575229220_image.png)

Step12：docker-compose.yml常用模板參數介紹

下面我們開始逐步講解docker-compose.yml檔案該怎麼撰寫：

- 首先指定docker-compose的版本：
    version: '3'
- 接下來開始定義服務名稱：
    version: '3'
    services:
      flask:
- 指定IMAGE有兩種方式
  - image：直接指定IMAGE
    version: '3'
    services:
      flask:
        image: python:3.7
  - build：透過dockerfile 建構
    - dockerfile在同一個資料夾且檔名為dockerfile
    version: '3'
    services:
      flask:
        build: .
    - 指定dockerfile路徑(例如:在dockerfile資料夾內的dockerfile-jupyter
    version: '3'
    services:
      flask:
        build:
          context: ./dockerfile
          dockerfile: dockerfile-flask
- container_name：定義容器名稱
    version: '3'
    services:
      flask:
        build:
          context: ./dockerfile
          dockerfile: dockerfile-flask
        container_name: jupyter
- depends_on：解決容器相依問題，在哪些服務開啟之後才啟動
    例如：ngrok服務運行前，要先確定flask服務已經開啟了
    version: '3'
    services:
      flask:
        ...
        ...
      ngrok:
        images: wernight/ngrok
        depends_on:
          - flask
- restart：服務意外停止後，是否重啟
    version: '3'
    services:
      flask:
        build:
          context: ./dockerfile
          dockerfile: dockerfile-flask
        container_name: flask
        restart: always
- environment：指定環境變量
    例如，在MYSQL常用到的指定root_password
          environment: 
            - MYSQL_ROOT_PASSWORD=iii  
- ports：指定映射端口，相當於`docker run`的`-p`
    version: '3'
    services:
      flask:
        build:
          context: ./dockerfile
          dockerfile: dockerfile-flask
        container_name: flask
        restart: always
        ports:
          - "5000:5000"
- volumes：資料夾映射，相當於`docker run`的`-ｖ`
    version: '3'
    services:
      flask:
        build:
          context: ./dockerfile
          dockerfile: dockerfile-flask
        container_name: flask
        restart: always
        ports:
          - "5000:5000"
        volumes:
          - ./code:/tmp/py_code
- working_dir：指定容器中工作資料夾，類似`dockerfile`的`WORKDIR`
- command：容器開啟後默認執行的命令，類似`dockerfile`的`CMD`
    version: '3'
    services:
      flask:
        build:
          context: ./dockerfile
          dockerfile: dockerfile-flask
        container_name: flask
        restardoct: always
        ports:
          - "5000:5000"
        volumes:
          - ./code:/tmp/py_code
        command: python /tmp/py_code/app.py
- dockerfile-flask內容
    #基於IMAGE python:3.7
    FROM python:3.7
    #添加FLASK_VER為環境變數，並設置版本為0.12
    ENV FLASK_VER 0.12
    #更新apt套件庫、安裝Flask，版本由FLASK_VER讀入、安裝VIM
    RUN pip install -q flask==$FLASK_VER
    #切換到預設工作目錄/tmp/py_code
    WORKDIR /tmp/py_code
docker-compose命令介紹

開啟一個docker-compose應用

    docker-compose [-f 位置/檔名] up [-d]
    -f：指定docker-compose的名稱，當docker-compose的名稱不是預設值(docker-compose.yml)時，需使用
    -d：背景執行
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545583296356_image.png)


關閉現行的docker-compose應用

    docker-compose [-f 位置/檔名] down
    注意：docker-compose up與down 建議在docker-compose.yml的同一層進行操作，不同層需使用 -f 參數指定檔名及位置
![](https://d2mxuefqeaa7sj.cloudfront.net/s_809626ACEBC62D3BE58C3F664999719710372FA0C54AD9EAC296695B1A5F94EB_1545583309229_image.png)


連入container：
連入container的方式有兩種

- docker exec
- docker-compose exec
    docker-compose exec範例：
    
    docker-compose exec <service名稱> <命令>

練習：開始撰寫第一個docker-compose
將Step8、Step10的docker應用寫成docker-compose
