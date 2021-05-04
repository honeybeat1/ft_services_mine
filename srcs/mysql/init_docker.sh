# 병렬 처리
# 
nohup sh /tmp/init_mysql.sh &
# mysql 데이터 디렉토리 초기화, 시스템 테이블 생성
/usr/bin/mysql_install_db --user=mysql --datadir="/var/lib/mysql"
/usr/bin/mysqld_safe --datadir="/var/lib/mysql"