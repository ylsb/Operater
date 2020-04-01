#确保有–with-http_stub_status_module 模块 并配置好 location /stub_status


#新增zabbix-nginx监控脚本

echo >> /usr/local/zabbix/bin/monitor-nginx.sh << EOF
#!/bin/bash

HOST="127.0.0.1"
PORT="80"
stub_status=stub_status
function check() {
/sbin/pidof nginx | wc -l
}
function active() {
/usr/bin/curl -s "http://$HOST:$PORT/${stub_status}/" 2>/dev/null| grep 'Active' | awk '{print $NF}'
}
function accepts() {
/usr/bin/curl -s "http://$HOST:$PORT/${stub_status}/" 2>/dev/null| awk NR==3 | awk '{print $1}'
}
function handled() {
/usr/bin/curl -s "http://$HOST:$PORT/${stub_status}/" 2>/dev/null| awk NR==3 | awk '{print $2}'
}
function requests() {
/usr/bin/curl -s "http://$HOST:$PORT/${stub_status}/" 2>/dev/null| awk NR==3 | awk '{print $3}'
}
function reading() {
/usr/bin/curl -s "http://$HOST:$PORT/${stub_status}/" 2>/dev/null| grep 'Reading' | awk '{print $2}'
}
function writing() {
/usr/bin/curl -s "http://$HOST:$PORT/${stub_status}/" 2>/dev/null| grep 'Writing' | awk '{print $4}'
}
function waiting() {
/usr/bin/curl -s "http://$HOST:$PORT/${stub_status}/" 2>/dev/null| grep 'Waiting' | awk '{print $6}'
}

case "$1" in
check)
check
;;
active)
active
;;
accepts)
accepts
;;
handled)
handled
;;
requests)
requests
;;
reading)
reading
;;
writing)
writing
;;
waiting)
waiting
;;

*)
echo $"Usage $0 {check|active|accepts|handled|requests|reading|writing|waiting}"
exit
esac
EOF

chmod 755 /usr/local/zabbix/bin/monitor-nginx.sh

#指定zabbix-agent读取nginx监控脚本
echo "UserParameter=nginx.status[*],/usr/local/zabbix/bin/monitor-nginx.sh $1" >> /usr/local/zabbix/etc/zabbix_agentd.conf.d/userparameter_nginx.conf

systemctl restart zabbix-agent.service
