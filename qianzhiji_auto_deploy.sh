#!/bin/bash

##########################################################
# File:			qianzhiji_auto_deploy.sh
# Description:	For QianZhiJi auto deploy.
# Requirement:	Before run this script, please upload related files as mentioned to related dir.
# Usage: 		bash ./qianzhiji_auto_deploy.sh
# Author:		hiyajun@126.com
# Organization:	
# Created:		2016.8.21 21:28
# Revision:		0.1
###########################################################

# 目前这个脚本， 整体差不多都写完了， 剩下的主要就是修补了。 

# 数据库相关的配置文件更改的函数，还没有完成！！！！

# 每次重新测试前需要做的事情
#	a. 把三个配置文件拷贝到  webapps 目录下边


stg_Dir=/home/siappstg
prd_Dir=/home/siappprd

TomcatDir_8080=$stg_Dir/apache-tomcat-7.0.70-8080    # STG 1
TomcatDir_8081=$stg_Dir/apache-tomcat-7.0.70-8081    # STG 2

TomcatDir_8082=$prd_Dir/apache-tomcat-7.0.70-8082    # PRD 1
TomcatDir_8083=$prd_Dir/apache-tomcat-7.0.70-8083    # PRD 2

partner_war=mhis-siapp-partner
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
	echo -en "\033[1;31m \n $msg \n \033[0;39m"
}

# 打印绿色信息
function print_Green {
	local msg=$1
	echo -en "\033[1;32m \n $msg \n \033[0;39m"
}

# 打印蓝色信息
function print_Blue {
	local msg=$1
	echo -en "\033[1;34m \n $msg \n \033[0;39m"
}


# 提示用户把文件拷贝到  8080 webapps下边
function reminder_upload_files {
        print_Green "Please upload files to $TomcatDir_8080/webapps, the files are: "        
		print_Blue "
  a. mhis-siapp-partner.war 
  b. context-siapp-partner.properties 
  c. log4j.properties
  d. siapp-partner-context.xml "
  
		print_Red "Please also make sure the DB CONNECTION information in conf/server.xml is correct."
  
        echo 
        print_Red "If you have UPLOAD all the mentioned files, please select 1 to continuea;  If not, please select 0 to exit and then upload the mentioned files"
}


# The backup functions will backup  mhis-siapp-partner Dir and all logs to /tmp/tomcat_backup .
function backup_8080 {
  current_time=`date +%F-%T`
  # backup .war and logs
	print_Blue "Start backup 8080"
	print_Green "Shutdowning 8080"
	$TomcatDir_8080/bin/shutdown.sh ; sleep 5 ;
	
	[ -d "$backup_8080" ] && echo " 8080 backup dir already exist" || (mkdir -p $backup_8080; echo "mkdir new backup dir 8080" )
		
	mkdir -p $backup_8080/$current_time/logs
		
	# mv ${TomcatDir_8080}/webapps/mhis-siapp-partner $backup_8080/$current_time || (echo "backup 8080 mhis-siapp-partner failed, please manual check" ; exit 4 )
    mv ${TomcatDir_8080}/webapps/mhis-siapp-partner $backup_8080/$current_time 

	mv ${TomcatDir_8080}/logs/* $backup_8080/$current_time/logs 
}

function backup_8081 {
  current_time=`date +%F-%T`
  # backup .war and logs
	print_Blue "Start backup 8081"
	print_Green "Shutdowning 8081"
	$TomcatDir_8081/bin/shutdown.sh ; sleep 5 ;
	
	[ -d "$backup_8081" ] && echo " 8081 backup dir already exist" || (mkdir -p $backup_8081; echo "mkdir new backup dir 8081" )
		
	mkdir -p $backup_8081/$current_time/logs
		
	mv ${TomcatDir_8081}/webapps/mhis-siapp-partner* $backup_8081/$current_time 
	
	mv ${TomcatDir_8081}/logs/* $backup_8081/$current_time/logs 
}

function backup_8082 {
  current_time=`date +%F-%T`
  # backup .war and logs
	print_Blue "Start backup 8082"
	print_Green "Shutdowning 8082"
	$TomcatDir/bin/shutdown.sh ; sleep 5 ;
	
	[ -d "$backup_8082" ] && echo " 8082 backup dir already exist" || (mkdir -p $backup_8082; echo "mkdir new backup dir 8082" )
		
	mkdir -p $backup_8082/$current_time/logs
		
	mv ${TomcatDir_8082}/webapps/mhis-siapp-partner* $backup_8082/$current_time  # && ( print_Red "Backup " ; exit 8 )
	
	mv ${TomcatDir_8082}/logs/* $backup_8082/$current_time/logs 
}

function backup_8083 {
  current_time=`date +%F-%T`
  # backup .war and logs
	print_Blue "Start backup 8083"
	print_Green "Shutdowning 8083"
	$TomcatDir_8083/bin/shutdown.sh ; sleep 5 ;
	
	[ -d "$backup_8083" ] && echo " 8083 backup dir already exist" || (mkdir -p $backup_8083; echo "mkdir new backup dir 8083" )
		
	mkdir -p $backup_8083/$current_time/logs
		
	mv ${TomcatDir_8083}/webapps/mhis-siapp-partner* $backup_8083/$current_time 
	
	mv ${TomcatDir_8083}/logs/* $backup_8083/$current_time/logs 
}


function unzip_partner_war {
# Decompress the .war file with unzip command.
	cd ${TomcatDir_8080}/webapps
	#jar -xf $partner_war
	unzip -q  $partner_war.war -d ./$partner_war
	if [[ $? -eq 0  ]]; 
	then 
		print_Green "Decompress .war successful" 
	else 
		print_Red "Decompress .war failed, Please manual check the reason"
		exit 1
	fi
	
# update 3 configuration files.
	mv -f ./$file1 ./$file2 ./mhis-siapp-partner/WEB-INF/classes && print_Green "move $file1 and $file2 successful" || (print_Red "move $file1 and $file2 failed, Please manual check the reason"; exit 2 )
	mv -f ./$file3 ./mhis-siapp-partner/WEB-INF/classes/biz && print_Green "move $file3  successful" || ( print_Red "move $file3 failed, Please manual check the reason"; exit 3 )
}


tomcat_dir_source=
tomcat_dir=
function move_ms_partner_dir {
    # tomcat_dir_last=$TomcatDir_8080
    cd $tomcat_dir/webapps && (cp -rf $tomcat_dir_source/webapps/mhis-siapp-partner . ; print_Green "move mhis-siapp-partner to $tomcat_dir/webapps successful" ) || ( move mhis-siapp-partner to $tomcat_dir/webapps Failed, Please manual check; exit 8 )

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
	[ $rps_lines -ge 5 ] && print_Green "$tomcat_port log file seems fine, the tomcat $tomcat_port should be ok " || (print_Red "$tomcat_port log file seems not ok, please manual check" ; exit 8)
	echo
} 

function deploy_8080 {
# Define variable
    tomcat_port=8080
    tomcat_dir=$TomcatDir_8080

# Stop tomcat
	print_Blue "shutdowning 8080 tomcat"
    $tomcat_dir/bin/shutdown.sh > /dev/null ; sleep 4


# Backup files and logs.
    backup_8080
    unzip_partner_war

# Start Tomcat
	print_Blue "Starting $tomcat_port Tomcat"
	$tomcat_dir/bin/startup.sh > /dev/null ; sleep 4
	
# Check port status and log information, if Successful
    check_tomcat_status
}


function deploy_8081 {
# Define variable
    tomcat_port=8081
    tomcat_dir_source=$TomcatDir_8080
    tomcat_dir=$TomcatDir_8081

# Stop Tomcat
	print_Blue "Stopping tomcat $tomcat_port "
    $tomcat_dir/bin/shutdown.sh > /dev/null ; sleep 4

#  Backup files and logs.
	backup_8081
	
# Move ms_partner_dir from 8080
    move_ms_partner_dir

# replace the log position
	sed  -i s/8080/8081/g  $tomcat_dir/webapps/mhis-siapp-partner/WEB-INF/classes/log4j.properties

	
# Start Tomcat
	print_Blue "Starting $tomcat_port Tomcat"
	$tomcat_dir/bin/startup.sh > /dev/null ; sleep 4
	
# Check port status and log information, if Successful
	check_tomcat_status
	
}

function deploy_8082 {
# Define variable
    tomcat_port=8082
    tomcat_dir_source=$TomcatDir_8080
    tomcat_dir=$TomcatDir_8082

# Stop Tomcat
	print_Blue "Stopping tomcat $tomcat_port "
    $tomcat_dir/bin/shutdown.sh > /dev/null ; sleep 4

#  Backup files and logs.
	backup_8082
	
# Move ms_partner_dir from 8080
    move_ms_partner_dir

# replace the log position
	sed  -i s/8080/8082/g  $tomcat_dir/webapps/mhis-siapp-partner/WEB-INF/classes/log4j.properties
	sed  -i s/siappstg/siappprd/g  $tomcat_dir/webapps/mhis-siapp-partner/WEB-INF/classes/log4j.properties

# Start Tomcat
	print_Blue "Starting $tomcat_port Tomcat"
	$tomcat_dir/bin/startup.sh > /dev/null ; sleep 4

# Check port status and log information, if Successful
	check_tomcat_status
}


function deploy_8083 {
# Define variable
    tomcat_port=8083
    tomcat_dir_source=$TomcatDir_8082
    tomcat_dir=$TomcatDir_8083

# Stop Tomcat
	print_Blue "Stopping tomcat $tomcat_port "
    $tomcat_dir/bin/shutdown.sh > /dev/null ; sleep 5

#  Backup files and logs.
	backup_8083
	
# Move ms_partner_dir from 8080
    move_ms_partner_dir

# replace the log position
	sed  -i s/8082/8083/g  $tomcat_dir/webapps/mhis-siapp-partner/WEB-INF/classes/log4j.properties

# Start Tomcat
	print_Blue "Starting $tomcat_port Tomcat"
	$tomcat_dir/bin/startup.sh > /dev/null ; sleep 5

# Check port status and log information, if Successful
	check_tomcat_status

}

function case_select {

reminder_upload_files


echo -e "\nWelcome to the auto deploy script!
1. Deploy 8080
2. Deploy 8081
3. Deploy 8082
4. Deploy 8083
0. exit the script
"

read -p "Please select the number: " num
case $num in 

1)
	echo "you select $num"
	echo
	print_Blue "---- Start deploy stg 8080 Tomcat  ----\n"
	
	deploy_8080
	
	print_Blue "---- End deploy stg 8080 Tomcat  ----"
	;;
2)
	echo "you select $num"
	print_Blue "---- Start deploy stg 8081 Tomcat  ----"
	
	deploy_8081
	
	print_Blue "---- End deploy stg 8081 Tomcat  ----"
	;;

3)
	echo "you select $num"
	print_Blue "---- Start deploy stg 8082 Tomcat  ----"
	
	deploy_8082
	
	print_Blue "---- End deploy stg 8082 Tomcat  ----"
	;;

4)
	echo "you select $num"
	print_Blue "---- Start deploy stg 8083 Tomcat  ----"
	
	deploy_8083
	
	print_Blue "---- End deploy stg 8083 Tomcat  ----"
	;;
	
0)
	echo "you select $num , exiting... "
	exit 10
	;;
*) 
	echo "Please input 0 or 1 or 2 or 3 or 4"
esac

}


case_select
