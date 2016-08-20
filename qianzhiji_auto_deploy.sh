#!/bin/bash
## For s


#定义变量  /homt/siappstg  /home/siappprd

stg_Dir=/homt/siappstg
prd_Dir=/home/siappprd

8080_TomcatDir=$stg_Dir/apache-tomcat-7.0.70-8080    # STG 1
8081_TomcatDir=$stg_Dir/apache-tomcat-7.0.70-8081    # STG 2

8082_TomcatDir=$prd_Dir/apache-tomcat-7.0.70-8082    # PRD 3
8083_TomcatDir=$prd_Dir/apache-tomcat-7.0.70-8083    # PRD 4




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

# 提示用户把文件拷贝到  8080 webapps下边

function reminder_upload_files {
	print_Green "Please upload files to $8080_TomcatDir/webapps, the files are 'mhis-siapp-partner, context-siapp-partner.properties, log4j.properties, siapp-partner-context.xml' "
	
	print_Red "If you have upload all the mentioned files, please select 1 to continue; \n
	If not, please select 0 to exit and then upload the mentioned files"
}
