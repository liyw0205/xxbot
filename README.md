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
> 全部功能

```
xxbot options

1. start             [启动xxbot]
2. bstart            [后台启动xxbot]
3. restart           [重启xxbot]
4. status            [查看xxbot后台状态]
5. stop              [停止xxbot后台]
6. cron              [定时重启xxbot]
6. cron stop         [删除定时任务]
7. napcat start      [启动napcat]
7. napcat screen     [后台启动napcat]
7. napcat status     [查看napcat后台状态]
7. napcat stop       [停止napcat后台]
8. update bot        [下载/更新bot]
8. update bot git    [github镜像]
8. update config     [重置配置]
9. install napcat    [安装napcat]
9. install java      [安装java]
9. install java git  [github加速]
```

> 启动例子

```
xxbot start

xxbot napcat start
```

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

> 快捷命令帮助，数字按命令顺序类推

- start可以代表1 bstart可以代表2
- xxbot 1等于xxbot start
- xxbot 2等于xxbot bstart
- xxbot 8 1等于xxbot update bot
- xxbot 8 1 1等于xxbot update bot git
- xxbot 8 2等于xxbot update config