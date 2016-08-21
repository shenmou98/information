#!/bin/bash
## For s


#定义变量  /homt/siappstg  /home/siappprd

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



# 打算是以选项的形式，需要手动一步一步来操作。 比如
#	先提示用户上传文件，包括war包、三个配置文件。  解压文件， 配置文件替换， 



# 先把颜色函数写出来，
#	红色
#	绿色

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
	print_Green "\nPlease upload files to $TomcatDir_8080/webapps, the files are 'mhis-siapp-partner, context-siapp-partner.properties, log4j.properties, siapp-partner-context.xml' "
	
	print_Red "\nIf you have upload all the mentioned files, please select 1 to continue; \nIf not, please select 0 to exit and then upload the mentioned files"
}

#print_Red "红色"
#print_Green "绿色"
#print_Blue "蓝色"
reminder_upload_files

#echo -r
#echo  "结束" && exit 1

# 提示用户把文件拷贝到  8080 webapps下边

function reminder_upload_files {
	print_Green "Please upload files to $TomcatDir_8080/webapps, the files are 'mhis-siapp-partner, context-siapp-partner.properties, log4j.properties, siapp-partner-context.xml' "
	
	print_Red "If you have upload all the mentioned files, please select 1 to continue; \n
	If not, please select 0 to exit and then upload the mentioned files"
}

# This function will backup all mhis-siapp-partner Dir and all logs.
function backup_8080 {
  current_time="date +%F-%T"
  # backup .war and logs
	print_Blue "Start backup 8080"
	print_Green "Shutdowning 8080"
	$8080_TomcatDir/bin/shutdown.sh ; sleep 10 ;  
	
	[ -d "$backup_8080" ] && echo " 8080 backup dir already exist" || (mkdir -p $backup_8080; echo "mkdir new dir" )
		
	mkdir $backup_8080/$current_time/logs
		
	mv ${TomcatDir_8080}/webapps/mhis-siapp-partner $backup_8080/$current_time || (echo "backup 8080 mhis-siapp-partner failed, please manual check" ; exit 4 )
	mv ${TomcatDir_8080}/logs/* $backup_8080/$current_time/logs || (echo "backup 8080 mhis-siapp-partner failed, please manual check" ; exit 5 )

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


