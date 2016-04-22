#!/bin/bash

# Author: yfwz100
# https://github.com/yfwz100

USERNAME= # YOUR USERNAME HERE
PASSWORD= # YOUR PASSWORD HERE

case $1 in
  "on")
    out=`curl 'http://ipgw.neu.edu.cn:803/srun_portal_pc.php?ac_id=1&' -H 'Origin: http://ipgw.neu.edu.cn:803' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: zh-CN,en;q=0.8' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Referer: http://ipgw.neu.edu.cn:803/srun_portal_pc.php?ac_id=1&' -H 'Connection: keep-alive' -H 'DNT: 1' --data "action=login&ac_id=1&user_ip=&nas_ip=&user_mac=&url=&username=$USERNAME&password=$PASSWORD&save_me=0&ajax=1" --compressed --silent`
    if [[ $out == login_ok* ]]; then
      echo "登录成功"
    else
      echo "登录失败"
    fi
  ;;
  "off")
    out=`curl 'http://ipgw.neu.edu.cn:803/include/auth_action.php' -H 'Accept: */*' -H 'Referer: http://ipgw.neu.edu.cn:803/srun_portal_pc.php?ac_id=1&' -H 'Origin: http://ipgw.neu.edu.cn:803' -H 'X-Requested-With: XMLHttpRequest' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' --data "action=logout&username=$USERNAME&password=$PASSWORD&ajax=1" --compressed --silent`
    echo $out
  ;;
  "status")
    out=`curl 'http://ipgw.neu.edu.cn:803/include/auth_action.php' -H 'Origin: http://ipgw.neu.edu.cn:803' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: zh-CN,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: */*' -H 'Referer: http://ipgw.neu.edu.cn:803/srun_portal_pc.php?ac_id=1&' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'DNT: 1' --data 'action=get_online_info' --compressed --silent`
    if [[ $out == not_online ]]; then
      echo "请先登录"
    else
      echo $out | awk -F, '
        {print "已用流量：" $1/1000000 "M"}
        {printf "已用时长：%02d:%02d:%02d\n", int($2/3600), int($2%3600/60), int($2%60)}
        {print "账号余额：￥" $3 }{print "IP地址：" $6}
      '
    fi
  ;;
  *) echo "Usage: ipgw [on|status|off]"
esac
