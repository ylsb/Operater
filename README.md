# Operator

如果现在给你 500 台服务器，你会如何管理？
提示

- 服务器均为Linux，操作系统有Redhat、CentOS、Ubuntu

- 服务器上运行着各类应用，如Nginx、MySQL、Redis、ElasticSearch、Python、Java等

- 简述主要思路，并尝试编写一些脚本，体现出主要内容即可

- 独立完成，提供代码的 GitHub 仓库链接即可



思路：主要从以下几方面入手：

1, 如果服务器分布在不同的公有云或私有云，可以尝试用ipsec vpn打通各网络的网关，这样当有资源内部共享或者内部服务器相互访问时，可以避免暴露在公网

2，统一管理 （ansible，各种云助手统一管理云服务器等）

    挑选一台服务器做ansible管理节点，其他服务器按需分成不同的ansible被管理节点列表，如[Nginx-server],[MySQL-Server]，[ALL-server]等
    
3，监控平台（zabbix，prometheus+grafana） 监控服务器与各种服务的性能

    在ansible-server管理节点上，安装好zabbix-server后，通过ansible执行ansible-playbook_install_zabbix_agent.yaml脚本，给所有服务器安装并配置zabbix-agent
    通过ansible给相应服务器配置相应的zabbix监控key，如配置好客户端的zabbix-monitor-nginx.sh后，在zabbix-server的配置页面加入相应nginx监控key即可
    
4，内部资源仓库，如dockerhub（harbor），github（gogs）和包管理仓库等

    比如自建yum仓库，apt仓库，集群机器统一升级时，可以先更新一部分机器，待系统稳定无异常时，将更新包推到自建仓库，再统一更新

5，日志集中分析工具 （elk+kafka）

    搭建es+logstash+kibana+kafka集群，业务层将日志写入到kafka队列，logstash将读取到的日志进行解析后，写入到elasticsearch中，并且按照索引模板进行解析，最后在kibana界面展现。

6，持续集成和发布工具

    主要使用jenkins来实现，最好搭配k8s+docker，实现docker镜像版本即相应服务的版本，方便后续回滚
    参考jenkins-build.sh与jenkins-k8s-deploy.sh

7，安全漏洞扫描工具

    使用crontab定期扫描系统漏洞（cvechecker，OpenVAS，Nikto）
