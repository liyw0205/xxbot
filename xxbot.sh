ui_print() {
    echo -e " $@"
}



help() {
    clear
    ui_print "1. start             [启动xxbot]"
    ui_print "2. bstart            [后台启动xxbot]"
    ui_print "3. restart           [重启xxbot]"
    ui_print "4. status            [查看xxbot后台状态]"
    ui_print "5. stop              [停止xxbot后台]"
    ui_print "6. cron              [定时重启xxbot]"
    ui_print "6. cron stop         [删除定时任务]"
    ui_print "7. napcat start      [启动napcat]"
    ui_print "7. napcat screen     [后台启动napcat]"
    ui_print "7. napcat status     [查看napcat后台状态]"
    ui_print "7. napcat stop       [停止napcat后台]"
    ui_print "8. update bot        [下载/更新bot]"
    ui_print "8. update bot git    [github镜像]"
    ui_print "8. update config     [重置配置]"
    ui_print "9. install napcat    [安装napcat]"
    ui_print "9. install java      [安装java]"
    ui_print "9. install java git  [github加速]"
    echo
    ui_print "napcat screen 默认会话名napcat"
    ui_print "screen -ls 查看全部会话"
    ui_print "ctrl+a+d不关闭screen后台退出"
    echo
    ui_print "定时任务（xxbot）：23:35重启 开机重启"
    echo
    ui_print "napcat启动或者后台可以接QQ号来快速启动"
    ui_print "napcat screen 123456789"
    echo
    ui_print "有多个QQ号启动可以设置会话"
    ui_print "napcat screen 1112223334 qq2"
    echo
    ui_print "查看/停止napcat后台可以加会话名"
    ui_print "napcat status qq2"
    echo
    ui_print "快捷命令帮助，数字按命令顺序类推"
    ui_print "start可以代表1 bstart可以代表2"
    ui_print "xxbot 1等于xxbot start"
    ui_print "xxbot 2等于xxbot bstart"
    ui_print "xxbot 8 1等于xxbot update bot"
    ui_print "xxbot 8 1 1等于xxbot update bot git"
    ui_print "xxbot 8 2等于xxbot update config"
    echo
    install_status "bot"
    install_status "java"
    [[ -n "$xxbot_pid" ]] && {
    etime=$(ps -p "$xxbot_pid" -o etime= | awk -F: '{
        if (NF == 2) { printf "%d小时%d分钟", $1, $2 }
        else if (NF == 3) { printf "%d小时%d分钟", $1, $2 }
        else if (NF == 4) { split($1, a, "-"); printf "%d天%d小时%d分钟", a[1], a[2], $2 }
    }')
    ui_print "xxbot已启动：${etime}"
    }
    system_info
}

system_info(){
uptime=$(uptime -p | sed 's/up //; s/days/天/g; s/day/天/; s/hours/小时/g; s/hour/小时/; s/minutes/分钟/g; s/minute/分钟/; s/, / /g')
cpu_usage=$(top -bn1 | grep '%Cpu' | awk '{printf "%.0f", $2 + $4}')
mem_info=$(free -m | awk '/Mem:/ {printf "%d/%dMB (%.0f%%)", $3, $2, $3/$2*100}')
storage_info=$(df -h / | awk 'NR==2 {printf "%s/%s (%s)", $3, $2, $5}')
ui_print "系统时长：$uptime"
ui_print "CPU：${cpu_usage}%"
ui_print "RAM：$mem_info"
ui_print "存储：$storage_info"
}

install_status() {
case "$1" in
    bot)
        if [[ -f "$MODDIR/bot.jar" ]]; then
             bot_status="已下载"
        else
            bot_status="未下载"
        fi
        version=$(cat $MODDIR/version 2>/dev/null)
        ui_print "bot$bot_status $version"
        if [[ -z "$version" ]]; then
            version=
        fi
        ;;
    java)
        if [[ -z "$(which java)" ]]; then
            java_status="未安装"
            version=
        else
            java_status="已安装"
            version=$(java -version 2>&1 | head -n1)
        fi
        ui_print "java$java_status $version"
        ;;
esac
}

install_module() {
cd ~
case "$1" in
    napcat|1)
        curl -o napcat.sh https://nclatest.znin.net/NapNeko/NapCat-Installer/main/script/install.sh && sudo bash napcat.sh
        ;;
    java|2)
        install_status "$1" 2>&1 >/dev/null
        if [[ -z "$abi" ]]; then
            ui_print "不支持的系统"
            exit 127
        fi
        if [[ "$java_status" == "未安装" ]]; then
            [[ "$2" == "git" || "$2" == "1" ]] && file_link="https://github.akams.cn/" || file_link=""
            curl -L -O ${file_link}https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.8+10/OpenJDK11U-jdk_${abi}_linux_hotspot_11.0.8_10.tar.gz
            if [[ -d $JAVA_HOME ]]; then
            rm -rf $JAVA_HOME
            fi
            mkdir -p $JAVA_HOME
            tar -zxvf OpenJDK11U-jdk_${abi}_linux_hotspot_11.0.8_10.tar.gz -C $JAVA_HOME --strip-components=1
        fi
        install_status "$1"
        ;;
    *)
        ui_print "$1不是可安装选项"
        ;;
esac
}

install_pack() {
[[ -z "$(which yum 2>/dev/null)" ]] || yum install "$1" -y
[[ -z "$(which apt 2>/dev/null)" ]] || apt-get -y install "$1" -y
[[ -z "$(which "$1")" ]] && {
    ui_prin "不支持的系统"
    exit 127
    }
}

read_or() {
 local var_name="$1"
 local required="$2"
 local prompt="$3"
 
 case "$required" in
     1)
         printf "请输入$prompt: "
         read -r input
         if [[ -z "$input" ]]; then
             ui_print "$var_name 不能为空，请重新输入。"
             return 1
         fi
         eval "$var_name=\"$input\""
         ;;
     2)
         printf "请输入$prompt: "
         read -r input
         if [[ -n "$input" ]]; then
             eval "$var_name=\"$input\""
         else
             ui_print "已设为默认值"
             return 1
         fi
         ;;
 esac
}

update_bot() {
cd ~
case "$1" in
    bot|1)
        [[ "$2" == "git" || "$2" == "1" ]] && file_link="https://github.com/liyw0205/xxbot/releases/download/xxbot" || file_link="https://gitee.com/keep-an-appointment/xxbot/releases/download/bot"
        bot_md5=$(curl -L https://gitee.com/keep-an-appointment/xxbot/releases/download/bot/md5 2>/dev/null)
        curl -L -O $file_link/bot.jar
        jar_md5=$(md5sum ~/bot.jar | awk '{print $1}')
        if [[ "$jar_md5" != "$bot_md5" ]]; then
            ui_print "md5校验失败！请重试！"
            exit 1
        fi
        [[ ! -z "$xxbot_pid" ]] && kill -9 $xxbot_pid
        curl -L -O $file_link/version
        curl -L -O $file_link/pf.txt
        curl -L -O $file_link/xp.txt
        mv bot.jar $MODDIR/bot.jar
        mv version $MODDIR/version
        mv xp.txt $MODDIR/xp.txt
        mv pf.txt $MODDIR/pf.txt
        install_status "bot"
        ;;
    config|2)
        generate_config
        ;;
esac
}

generate_config() {
    while true; do
        read_or qq 1 "控制小号的QQ" || continue
        read_or groupId 1 "修炼群号（多账号不可重复）" || continue
        read_or taskId 2 "任务群号默认修炼群号（消息转发群，可重复）" || taskId=$groupId
        read_or cultivationMode 2 "修炼模式：0什么都不干，1修炼，2普通闭关（默认），3宗门闭关" || cultivationMode=2
        read_or rewardMode 2 "悬赏令模式：
1：手动 2：手动接取自动结算 3：全自动价值优先 4：全自动优先时间最短的
5：物品价格800w以下优先修为最高 6：优先修为最高
7：优先选100概率修为最高，没有就选修为最高（默认）" || rewardMode=7
        read_or sectMode 2 "宗门任务1：邪修和查抄 2：所有任务（默认）" || sectMode=2
        ui_print "以下配置 是为：true 否为：false 回车默认：false"
        read_or enableCheckPrice 2 "是否开启查价格" || enableCheckPrice=false
        read_or enableGuessTheIdiom 2 "是否开启猜成语" || enableGuessTheIdiom=false
        read_or enableCheckMarket 2 "是否开启查行情" || enableCheckMarket=false
        read_or enableXslPriceQuery 2 "悬赏令价格查询 注意：这个为true会自动查询悬赏令价格" || enableXslPriceQuery=false
        read_or enableAutomaticReply 2 "是否提醒 秘境 灵田" || enableAutomaticReply=false
        read_or Enabledanfancx 2 "是否开始查丹方" || Enabledanfancx=false
        read_or enableAutoField 2 "自动灵田结算（默认 true）" || enableAutoField=true
        read_or enableAutoSecret 2 "自动秘境结算 （默认 true）" || enableAutoSecret=true
        read_or enableAutoRepair 2 "无偿双修" || enableAutoRepair=false
        read_or shuangXuNumber 2 "设置无偿双修次数" || shuangXuNumber=6
        read_or challengeMode 2 "自动挑战九层妖塔（默认不执行）
0：不执行
1：一口气1-9
2：打完3层 7层 8层会自动回血" || challengeMode=0
        read_or botNumber 2 "设置编号" || botNumber=1
        read_or aiCheng 2 "设置爱称 可设置多个 名称&名称" || aiCheng="部将&傀儡&化身&星怒"
        read_or IntercalTime 2 "设置一键上架/炼金延迟时间 秒" || IntercalTime=3
        read_or copy_config 2 "镜像配置，多账号配置（默认只生成单账号配置）" || copy_config=1
        read_config=
        ui_print "确认重置配置(默认 true/y): "
        read -r read_config
        if [[ -z "$read_config" ]]; then
            read_config=true
        fi
        case "$read_config" in
            true|y)
            output_config
            break
            ;;
            *)
            exit
            ;;
        esac
    done
    clear
    cat "$MODDIR/config/application-local.yml"
    ui_print "重置配置完成"
}

output_config() {
    if [[ -d "$MODDIR/config" ]]; then
    rm -rf "$MODDIR/config"
    fi
    mkdir -p "$MODDIR/config"
    
    case "$copy_config" in
        [1-9])
        output2_config
        ;;
        *)
        copy_config=1
        output2_config
        ;;
    esac
}

output2_config() {
cat <<EOF> "$MODDIR/config/application-local.yml"
#外部导入丹方表
danfang:
  local-path: "/root/xxbot/pf.txt" 

#外部导入性平表
xingping:
  local-path: "/root/xxbot/xp.txt"

bot:

EOF

    i=1
    while [ $i -le $copy_config ]; do
        port=$((8081 + i))
        
cat <<EOF>> "$MODDIR/config/application-local.yml"
  - type: ws-reverse
    url: ws://0.0.0.0:$port
    accessToken: 1024*1024*1024
    #    修炼群号
    groupId: $groupId
    #    控制小号的QQ（可设置多个）
    controlQQ: $qq
    # 主要用于设置小号出验证码艾特提醒的QQ 可不设置
    masterQQ: $qq
    # 是否开启查价格
    enableCheckPrice: $enableCheckPrice
    # 是否开启猜成语
    enableGuessTheIdiom: $enableGuessTheIdiom
    # 是否开启查行情
    enableCheckMarket: $enableCheckMarket
    # 悬赏令价格查询 注意：这个为true会自动查询悬赏令价格
    enableXslPriceQuery: $enableXslPriceQuery
    #是否提醒 秘境 灵田
    enableAutomaticReply: $enableAutomaticReply
    #是否开始查丹方
    Enabledanfancx: $Enabledanfancx
    # 修炼模式：0什么都不干，1修炼，2普通闭关，3宗门闭关
    cultivationMode: $cultivationMode
    # 任务群号    
    taskId: $taskId
    #悬赏令模式 1:手动 2:手动接取自动结算 3:全自动价值优先 4:全自动优先时间最短的 
    # 5:物品价格800w以下优先修为最高 6:优先修为最高 
    # 7:优先选100%概率修为最高，没有就选修为最高（默认）
    rewardMode: $rewardMode
    #宗门任务1：邪修和查抄（默认） 2：所有任务
    sectMode: $sectMode
    #自动灵田结算（默认 true）
    enableAutoField: $enableAutoField
    #自动秘境结算 （默认 true）
    enableAutoSecret: $enableAutoSecret
    #无偿双修
    enableAutoRepair: $enableAutoRepair
    #设置无偿双修次数
    shuangXuNumber: $shuangXuNumber
    #自动挑战九层妖塔（默认不执行）0：不执行 1：一口气1-9 2：打完3层 7层 8层会自动回血
    challengeMode: $challengeMode
    #设置编号
    botNumber: $botNumber
    #设置爱称 可设置多个 名称&名称
    aiCheng: $aiCheng
    #设置一键上架/炼金延迟时间 秒
    IntercalTime: $IntercalTime

EOF

        i=$((i + 1))
    done

cat <<EOF> "$MODDIR/config/application.yml"
spring:
  profiles:
    active: local

EOF

}

napcat_or() { 
[[ ! -z "$2" ]] && screen_qq="$2" || screen_qq="napcat"
[[ ! -z "$2" ]] && napcat_qq="-q $2" || napcat_qq=
 case "$1" in
    start|1)
        xvfb-run -a qq --no-sandbox $napcat_qq
        ;;
    screen|2)
        [[ ! -z "$3" ]] && screen_qq="$3" || screen_qq="napcat"
        screen -dmS $screen_qq bash -c "xvfb-run -a qq --no-sandbox $napcat_qq"
        screen -r $screen_qq
        ;;
    status|3)
        screen -r $screen_qq
        ;;
    stop|4)
        screen -S $screen_qq -X quit
        ;;
 esac
}

cron_or() { 
if [[ -z "$(which cron)" ]]; then
    install_pack cron || {
    ui_print "cron 安装失败，请自行安装"
    exit 127
    }
fi
temp_cron=$MODDIR/temp_cron
crontab -l > $temp_cron || touch $temp_cron
[[ "$1" = "stop" || "$1" == "1" ]] && {
    cron_status="取消"
    [[ ! -z "$(cat $temp_cron | grep '#xxbot cron')" ]] && {
        sed -e '/^#xxbot cron/d' -e '/@reboot xxbot restart/d' -e '/35 23 \* \* \* xxbot restart/d' $temp_cron > $temp_cron.tmp
        mv $temp_cron.tmp $temp_cron
        }
    } || {
    cron_status="设置"
    [[ -z "$(cat $temp_cron | grep '#xxbot cron')" ]] && {
        echo "#xxbot cron" >> $temp_cron
        echo "@reboot xxbot restart" >> $temp_cron
        echo "35 23 * * * xxbot restart" >> $temp_cron
        }
    }
crontab $temp_cron && ui_print "$cron_status定时任务成功" || ui_print "$cron_status定时任务失败"
rm $temp_cron
}

export MODDIR="/root/xxbot"
export JAVA_HOME="$MODDIR/java"
abi=$(uname -m)
case "$abi" in
    x86_64) abi="x64" ;;
    aarch64) abi="arm64" ;;
    *) abi= ;;
esac
if [[ ! -d $MODDIR ]]; then
    mkdir -p $MODDIR
fi
if [[ ! -d "$JAVA_HOME/bin" ]]; then
    mkdir -p $JAVA_HOME/bin
fi
export PATH=$PATH:$JAVA_HOME/bin
if [[ -z "$(which xxbot)" ]]; then
    echo "bash $MODDIR/xxbot.sh \"\$@\"" > /bin/xxbot
    chmod +x /bin/xxbot
fi
if [[ "$0" != "$MODDIR/xxbot.sh" ]]; then
    cp -af "$0" $MODDIR/xxbot.sh
fi
chmod -R 755 $MODDIR
clear

xxbot_pid=
if ps -ef | grep "$MODDIR/bot.jar" | grep -v grep >/dev/null; then
xxbot_pid=$(ps -ef | grep "$MODDIR/bot.jar" | grep -v grep | awk '{print $2}')
fi
case "$1" in
    start|1)
        install_status "java" 2>&1 >/dev/null
        if [[ "$java_status" == "未安装" ]]; then
            ui_print "请先安装java"
            exit 127
        else
            cd $MODDIR
            java -Dfile.encoding=UTF-8 -jar $MODDIR/bot.jar --spring.config.location=file:$MODDIR/config/
        fi
        ;;
    bstart|2)
        [[ ! -z "$xxbot_pid" ]] || nohup xxbot start > $MODDIR/xxbot.log 2>&1 &
        tail -f $MODDIR/xxbot.log
        ;;
    restart|3)
        [[ ! -z "$xxbot_pid" ]] && kill -9 $xxbot_pid
        xxbot bstart
        ;;
    status|4)
        [[ ! -z "$xxbot_pid" ]] && tail -f $MODDIR/xxbot.log || ui_print "xxbot未启动"
        ;;
    stop|5)
        [[ ! -z "$xxbot_pid" ]] && kill -9 $xxbot_pid
        ui_print "已停止xxbot"
        ;;
    cron|6)
        cron_or "$2"
        ;;
    napcat|7)
        napcat_or "$2" "$3" "$4"
        ;;
    update|8)
        update_bot "$2"
        ;;
    install|9)
        install_module "$2"
        ;;
    *)
        help
        ;;
esac
