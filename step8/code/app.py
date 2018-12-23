#引用套件
from flask import Flask
#新建場地
app = Flask(__name__)
#開啟接口
@app.route("/")
def hellow_world():
        return "Hello World!"
    #啟用Server
if __name__ == "__main__":
    app.run(host='0.0.0.0' ,port=5000)
