# xxbot

# 💿 安装

<details>
<summary>(Linux安装：Debian)</summary>

安装curl
```
apt update && apt upgrade -y && \
apt install screen curl -y
```
下载脚本 国内
```
curl -L -o xxbot.sh https://gitee.com/keep-an-appointment/xxbot/raw/master/xxbot.sh && chmod +x xxbot.sh && bash xxbot.sh
```
下载脚本 git
```
curl -L -o xxbot.sh https://raw.githubusercontent.com/liyw0205/xxbot/refs/heads/main/xxbot.sh && chmod +x xxbot.sh && bash xxbot.sh
```
 </details>
 
# 💡 使用
```
xxbot options

    start             [启动xxbot]
    bstart            [后台启动xxbot]
    restart           [重启xxbot]
    status            [查看xxbot后台状态]
    stop              [停止xxbot后台]
    cron              [定时重启xxbot]
    cron stop         [删除定时任务]
    napcat start      [启动napcat]
    napcat screen     [后台启动napcat]
    napcat status     [查看napcat后台状态]
    napcat stop       [停止napcat后台]
    update bot        [下载/更新bot]
    update bot git    [github镜像]
    update config     [重置配置]
    install napcat    [安装napcat]
    install java      [安装java]
    install java git  [github加速]
```
> 全部功能

```
xxbot start

xxbot napcat start
```
> 使用例子

- napcat screen 默认会话名napcat
- screen -ls 查看全部会话
- ctrl+a+d不关闭screen后台退出
- 定时任务（xxbot）：23:35重启 开机重启
- napcat启动或者后台可以接QQ号来快速启动
- napcat screen 123456789
- 有多个QQ号启动可以设置会话
- napcat screen 1112223334 qq2
- 查看/停止napcat后台可以加会话名
- napcat status qq2