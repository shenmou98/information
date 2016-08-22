#!/bin/bash

##########################################################
# File:			qianzhiji_auto_deploy.sh
# Description:	For QianZhiJi auto deploy.
# Requirement:	Before run this script, please upload related files as mentioned to related dir.
# Usage: 		./qianzhiji_auto_deploy.sh
# Author:		ShenYaJun, hiyajun@126.com
# Organization:	
# Created:		2016.8.21 21:28
# Revision:		0.1
###########################################################

# 目前这个脚本， 该往真正的 deploy 脚本里边添加东西了，  deploy_8080开始


stg_Dir=/home/siappstg
prd_Dir=/home/siappprd

TomcatDir_8080=$stg_Dir/apache-tomcat-7.0.70-8080    # STG 1
TomcatDir_8081=$stg_Dir/apache-tomcat-7.0.70-8081    # STG 2

TomcatDir_8082=$prd_Dir/apache-tomcat-7.0.70-8082    # PRD 3
TomcatDir_8083=$prd_Dir/apache-tomcat-7.0.70-8083    # PRD 4

partner_war=mhis-siapp-partner.war
file1=context-siapp-partner.properties
file2=log4j.properties
file3=siapp-partner-context.xml

backup_dir=/tmp/tomcat_backup
backup_8080=$backup_dir/8080
backup_8081=$backup_dir/8081
backup_8082=$backup_dir/8082
backup_8083=$backup_dir/8083



# 打印红色信息
function print_Red {
	local msg=$1
	echo -en "\033[1;31m $msg \033[0;39m"
}

# 打印绿色信息
function print_Green {
	local msg=$1
	echo -en "\033[1;32m $msg \033[0;39m"
}

# 打印蓝色信息
function print_Blue {
	local msg=$1
	echo -en "\033[1;34m $msg \033[0;39m"
}


# 提示用户把文件拷贝到  8080 webapps下边
function reminder_upload_files {
        print_Green "Please upload files to $TomcatDir_8080/webapps, the files are: "        
		print_Blue "
  a. mhis-siapp-partner 
  b. context-siapp-partner.properties 
  c. log4j.properties
  d. siapp-partner-context.xml "
        
        echo 
        echo 
        print_Red "If you have upload all the mentioned files, please select 1 to continuea;  If not, please select 0 to exit and then upload the mentioned files"
}




# This function will backup all mhis-siapp-partner Dir and all logs.
function backup_8080 {
  current_time="date +%F-%T"
  # backup .war and logs
	print_Blue "Start backup 8080"
	print_Green "Shutdowning 8080"
	$8080_TomcatDir/bin/shutdown.sh ; sleep 10 ;  
	
	[ -d "$backup_8080" ] && echo " 8080 backup dir already exist" || (mkdir -p $backup_8080; echo "mkdir new backup dir 8080" )
		
	mkdir $backup_8080/$current_time/logs
		
	# mv ${TomcatDir_8080}/webapps/mhis-siapp-partner $backup_8080/$current_time || (echo "backup 8080 mhis-siapp-partner failed, please manual check" ; exit 4 )
	 mv ${TomcatDir_8080}/webapps/mhis-siapp-partner $backup_8080/$current_time 

	mv ${TomcatDir_8080}/logs/* $backup_8080/$current_time/logs 
}

function backup_8081 {
  current_time="date +%F-%T"
  # backup .war and logs
	print_Blue "Start backup 8081"
	print_Green "Shutdowning 8081"
	$8081_TomcatDir/bin/shutdown.sh ; sleep 10 ;  
	
	[ -d "$backup_8081" ] && echo " 8081 backup dir already exist" || (mkdir -p $backup_8081; echo "mkdir new backup dir 8081" )
		
	mkdir $backup_8081/$current_time/logs
		
	mv ${TomcatDir_8081}/webapps/mhis-siapp-partner* $backup_8081/$current_time 
	
	mv ${TomcatDir_8081}/logs/* $backup_8081/$current_time/logs 
}

function backup_8082 {
  current_time="date +%F-%T"
  # backup .war and logs
	print_Blue "Start backup 8082"
	print_Green "Shutdowning 8082"
	$8082_TomcatDir/bin/shutdown.sh ; sleep 10 ;  
	
	[ -d "$backup_8082" ] && echo " 8082 backup dir already exist" || (mkdir -p $backup_8082; echo "mkdir new backup dir 8082" )
		
	mkdir $backup_8082/$current_time/logs
		
	mv ${TomcatDir_8082}/webapps/mhis-siapp-partner* $backup_8082/$current_time 
	
	mv ${TomcatDir_8082}/logs/* $backup_8082/$current_time/logs 
}

function backup_8083 {
  current_time="date +%F-%T"
  # backup .war and logs
	print_Blue "Start backup 8083"
	print_Green "Shutdowning 8083"
	$8083_TomcatDir/bin/shutdown.sh ; sleep 10 ;  
	
	[ -d "$backup_8083" ] && echo " 8083 backup dir already exist" || (mkdir -p $backup_8083; echo "mkdir new backup dir 8083" )
		
	mkdir $backup_8083/$current_time/logs
		
	mv ${TomcatDir_8083}/webapps/mhis-siapp-partner* $backup_8083/$current_time 
	
	mv ${TomcatDir_8083}/logs/* $backup_8083/$current_time/logs 
}

function unzip_partner_war {

# Decompress the .war file.
	cd ${TomcatDir_8080}/webapps
	jar -xf $partner_war #&& echo "Decompress successful" || ecgi "Decompress failed"
	if [[ $? -eq 0  ]]; 
	then 
		print_Green "Decompress .war successful" 
	else 
		print_Red "Decompress .war failed"
		exit 1
	fi
	
# update 3 configuration files.
	mv -f ./$file1 ./$file2 ./mhis-siapp-partner/WEB-INF/classes && print_Green "move $file1 and $file2 successful" || (print_Red "move $file1 and $file2 failed, Please manual check the reason"; exit 2 )
	mv -f ./$file3 ./mhis-siapp-partner/WEB-INF/classes/biz && print_Green "move $file3  successful" || ( print_Red "move $file3 failed, Please manual check the reason"; exit 3 )
}

function check_tomcat_status {
	#tomcat_port=808x
	#tomcat_dir=
	
	# Check if the port is up
	port_status=`netstat -lntup | grep "$tomcat_port" | wc -l`
	echo $port_status
	[ $port_status -eq 1 ] && print_Green "port $tomcat_port is up" || (print_Red "Port $tomcat_port start FAILED, please manual check " ; exit 7)
	echo
	
	# Check if the log output is normal
	log_file=$tomcat_dir/logs/fwa/pafa.log
	rps_lines=`grep "Rps Service Register"  $log_file | wc -l `
	[ $rps_lines -ge 5 ] && print_Green "$tomcat_port log file seems fine, the $tomcat_port should be ok " || (print_Red "$tomcat_port log file seems not ok, please manual check" ; exit 8)
	echo
} 

function deploy_8080 {



}

function deploy_8081 {



}

function deploy_8082 {



}

function deploy_8083 {



}

function case_select {

reminder_upload_files

echo -e "Welcome to the auto deploy script!
1. Deploy 8080
2. Deploy 8081
3. Deploy 8082
4. Deploy 8083
0. exit the script
"

read -p "Please select the number: " num
case $num in 

1)
	echo "you select $num 111"
	;;
2)
	echo "you select $num 222"
	;;
0)
	echo "you select $num 000"
	exit 10
	;;
*) 
	echo "You input 0 or 1 or 2"
esac

}












