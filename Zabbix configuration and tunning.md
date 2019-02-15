
 
Configuration Zabbix (any version)

1. (dependencies and necessary package)

- Update O.S. 
	### yum -v install epel-release 
	### yum -v install wget fping net-tools bash-completion net-snmp-utils
	### systemctl stop firewalld
	### systemctl disable firewalld
	### nano /etc/selinux/config  (disable SELinux)
  
- Postgres (version you want, i use 9.6 for zabbix (3.x)  and 10 for (4.x) )

  # https://www.postgresql.org/download/linux/redhat/

- Launch services 

- Create zabbix user
  useradd zabbix
  passwd zabbix  (please use another passphrase )

- Crear directory for DB
  #cd /var/db
  #mkdir db
  #chmod 775 db/
  #chown zabbix:postgres db/

- Configurar Postgres
  # cd /var/lib/pgsql/9.6/data/
  # nano postgresql.conf

  listen_addresses = 'localhost' (if the database is separate from the zabbix server '*')

  #nano pg_hba.conf			;edit 

    local   all             all						trust
    host    all             all             127.0.0.1/32       trust
    host    all             all             red/mascara        trust

    NOTE: For 'pgAdmin' use md5.

- restart service postgres
# systemctl restart postgresql-x.x.service

- Create rol
# su postgres
  $ psql		;testing Postgres
  $ \q		  ;exit postgres


- Create BD (do it with user postgres)
  $cd /var/db/db/
  $createdb zabbix

- Create DB user
  psql
  CREATE USER zabbix WITH PASSWORD 'zabbix';
  ALTER DATABASE zabbix OWNER TO zabbix;
  GRANT ALL ON DATABASE zabbix TO zabbix;
  GRANT ALL PRIVILEGES ON DATABASE zabbix to postgres;
  GRANT postgres TO zabbix;
  \q
  exit

- Install Zabbix 4.0
# yum install https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm

# yum install zabbix-server-pgsql zabbix-web-pgsql zabbix-agent

# zcat /usr/share/doc/zabbix-server-pgsql*/create.sql.gz | sudo -u zabbix psql zabbix

- Configuration Zabbix
# nano /etc/zabbix/zabbix_server.conf

    DBHost = localhost  (IP - for database server)
    DBName = zabbix	  	(name of database)
    DBUser = zabbix		  (User DB)
    DBPassword= zabbix 	(Pass DB)
    CacheSize=60M

- Restart services
  systemctl enable postgresql-9.6.service
  systemctl restart postgresql-9.6.service
  systemctl restart zabbix-server zabbix-agent httpd
  systemctl enable zabbix-server zabbix-agent httpd


- Parameters Zabbix

  >  Time zone
  #nano /etc/httpd/conf.d/zabbix.conf
    php_value date.timezone xxx/xxx



  > Lenguage (spanish)
  #nano /usr/share/zabbix/include/locales.inc.php
    'es_ES' => array('name' => _('Spanish (es_ES)'),'display' => false),   >> [change to true]

	> Change logos

Modify folders “styles” and “images” with your logos
  /usr/share/zabbix

  > Change root httpd
#nano /etc/httpd/conf/httpd.conf
DocumentRoot "/usr/share/zabbix"

  > Tunning httpd Apache (just an a basic example)

  nano /etc/httpd/conf/httpd.conf

    MaxKeepAliveRequests 500
    KeepAliveTimeout 5
    KeepAlive On
    KeepAlive Off
    <IfModule prefork.c>
        StartServers        5
        MinSpareServers     5
        MaxSpareServers     10
        MaxClients          150
        MaxRequestsPerChild 3000
    </IfModule>
    HostnameLookups Off

   systemctl restart httpd
   
 > Tunning Zabbix (Precaution: this is just a tunning example configuration, for a right tunning is necessary more study about the environment you want to monitor and what exactly u want monitor from the host's. if you dont know what you doing just keep the preveius configuration setting before.)

  Continue with precaution.

  >>  ZABBIX

    StartPollers=400
    StartPollersUnreachable=10
    StartPingers=20
    StartDiscoverers=10
    SNMPTrapperFile=/var/log/snmptrap/snmptrap.log
    HousekeepingFrequency=1
    MaxHousekeeperDelete=1000
    CacheSize=200M
    TrendCacheSize=16M
    Timeout=30

  >>  POSTGRES
              
    max_connections = 512
    shared_buffers = 512MB
    work_mem = 80MB
