#!/bin/bash
# +=============== Bank of China FPMS project ========================
# | Name:
# |      fpmsstartstop.sh
# | Description:
# |      IBM WEBSPHERE SERVER start or stop.
# | Notes:
# |      ��Ҫ��root�û����д˽ű�.
# +===================================================================
exp_log=/home/fpms/export/fpmsbakfile.log
#exp_log=/fpms/BACKUP/fpmsbakfile.log
export NLS_LANG="SIMPLIFIED CHINESE_CHINA".ZHS16GBK
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/client_1
export PATH=$ORACLE_HOME/bin:$PATH
export ORACLE_SID=FPMS
dbconstr=FPMS/Passabcd1234@22.188.46.239:1521/FPMSDB
sys_day=`date +%Y%m%d`

while true
do
    clear
    echo "\n"
    echo "    +-----------------------------------------------------+"
    echo "    |                 FPMSϵͳִ�в˵�                                                                                  |"
    echo "    +-----------------------------------------------------+"
    echo "    |                                                     |"     
    echo "    |              A. ���DMP�������                                                                                      |"    
    echo "    |                                                     |"
    echo "    |              B. �ر�Ӧ��ϵͳ                                                                                                |"
    echo "    |                                                     |"
    echo "    |              C. ����Ӧ��ϵͳ                                                                                               |"
    echo "    |                                                     |"
    echo "    |              Q. �˳�                                                                                                                |"
    echo "    |                                                     |"     
    echo "    +-----------------------------------------------------+"
    echo "    |                  ��ӭʹ��FPMSϵͳ                                                                               |"
    echo "    +-----------------------------------------------------+"
    echo "                \033[1m����ϸȷ������ѡ��!\033[0m    ѡ����: \c"
    read operate
    case $operate in
    
        [Aa]  ) 
        
        	 echo "ȷ�����С����RMAN����״̬��? (ȷ��������Y )\c"
             read answer
             if [ $answer = "Y" -o $answer = "y" ]
             then
               echo "+----------------------------------------------------------------------+"
               tail -n 1 $exp_log
               echo "+----------------------------------------------------------------------+"
               echo "���س������� \c"
               read tmp               
             fi
             ;;
             
        [Bb]  ) 
        
        	 echo "ȷ�����С��ر�Ӧ��ϵͳ���̡�? (ȷ��������Y )\c"
             read answer
             if [ $answer = "Y" -o $answer = "y" ]
             then
               echo "+----------------------------------------------------------------------+"
               sh /was/IBM/WebSphere/AppServer/profiles/AppSrv01/bin/stopServer.sh server1
               echo "+----------------------------------------------------------------------+"
               echo "���س������� \c"
               read tmp               
             fi
             ;;

        [Cc]  ) 
        
        	 echo "ȷ�����С�����Ӧ��ϵͳ���̡�? (ȷ��������Y )\c"
             read answer
             if [ $answer = "Y" -o $answer = "y" ]
             then
               echo "+----------------------------------------------------------------------+"
               sh /was/IBM/WebSphere/AppServer/profiles/AppSrv01/bin/startServer.sh server1
               echo "+----------------------------------------------------------------------+"
               echo "���س������� \c"
               read tmp               
             fi
             ;;

        [Qq] )  reset
             exit ;;
        * )  echo  "��������ȷѡ��!!!"
             ;;
    esac
done
exit
