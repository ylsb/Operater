#!/usr/bin/python
#coding=utf8
import os
import sys

job_name=os.environ["JOB_NAME"]
Version="v"+os.environ["Tag"]
deployment_yaml="/root/xxx-service/"+job_name+"/deployment*"
exist_cmd="sudo kubectl get deployment|grep "+job_name+"|wc -l"
create_cmd="sudo kubectl create -f "+deployment_yaml
update_cmd="sudo kubectl set image deployment/"+job_name+" "+job_name+"={your_harbor_ip}/xxx/"+job_name+":"+Version
Judge_cmd="kubectl get pod |grep "+job_name+"|grep Running |wc -l" #判断该deployment有无pod在运行

def deployment_exist_status(connect, exist_cmd):
  return int(str(connect.run(exist_cmd, hide='both').stdout))
    
with open('./images_status', 'r') as f:
  flag=f.read()
  if int(flag)==0:    #根据上一步构建docker的images_status来判断是否构建成功
    with Connection('{your_k8s_master_ip}}','root','22',connect_kwargs={'password':'{your_k8s_master_passed}'}) as c:
      if deployment_exist_status(c, exist_cmd)==0: #判断该deployment有无pod在运行，若无就执行create创建，若有则执行update更新
        deployment_first_deploy(c, create_cmd)
        print "项目首次部署成功,当前版本为:%s" % Version
      else:
        c.run(update_cmd)
        print "更新项目成功,当前版本为:%s" % Version
  else:
    print "镜像版本没有更新，不能进行部署操作......"
    sys.exit()
