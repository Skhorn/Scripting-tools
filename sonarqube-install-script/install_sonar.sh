#!/bin/bash

/bin/echo
/bin/echo "  -.-----------------------------------------------------.-"
/bin/echo "   |SonarQube Installation & Configuration Automatic Tool|"
/bin/echo "  -.-----------------------------------------------------.-"
/bin/echo
/bin/echo
/bin/echo "----------------------------------------"
/bin/echo "     Checking initial requirements"
/bin/echo "----------------------------------------"
/bin/echo
/bin/echo

# Log variables
INFO_LOG="`date` == INFO:"
ERROR_LOG="`date` == ERROR:"

install_java ()
{
	if [ ! -d "/opt/jdk/ "]; then
		/usr/bin/sudo /bin/mkdir /opt/jdk/
		JDK_DIR=/opt/jdk/
	else
		JDK_DIR=/opt/jdk/
	fi
	/usr/bin/sudo /usr/bin/wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz
	/usr/bin/sudo /bin/tar -zxfv jdk-8u131-linux-x64.tar.gz -C ${JDK_DIR}
	/usr/bin/sudo /bin/rm -rfv jdk-8u131-linux-x64.tar.gz 
	/bin/echo "${INFO_LOG} Setting current java executable as default"
	/usr/bin/sudo /usr/bin/update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_131/bin/java 100
	/bin/echo "${INFO_LOG} Setting current javac executable as default"
	/usr/bin/sudo /usr/bin/update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_131/bin/javac 100
	/bin/echo/ "${INFO_LOG} Java installed, displaying relevant information"
	/usr/bin/update-alternatives --display java
	/usr/bin/update-alternatives --display javac
	/bin/echo "${INFO_LOG} Following the script..."
}

install_mysql()
{
	/usr/bin/wget https://dev.mysql.comget/mysql-apt-config_0.8.6-1_all.deb
	/usr/bin/sudo /usr/bin/dpkg -i mysql-apt-config_0.8.6-1_all.deb
	/bin/echo "${INFO_LOG} MySql installed, displaying relevant information"
	/usr/bin/mysql --version
	/bin/rm -rfv mysql-apt-config_0.8.6-1_all.deb
}
# Check requeriments to install SonarQube properly.
# 1. Java 8 {JRE & JDK}
/bin/echo "${INFO_LOG} Checking Java installation"
if type -p java >/dev/null; then
	/bin/echo "${INFO_LOG} Found Java executable in path: `type -f java`"
	_JAVA=java
elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]]; then
	/bin/echo "${INFO_LOG} Found Java executable in ${JAVA_HOME}"
	_JAVA="$JAVA_HOME/bin/java"
else
	/bin/echo "${ERROR_LOG} Java not found..."
	# We are going to provide a way to install java
	while /bin/true; do
	    read -p "Do you wish this tool to install Java? [y/n]" yn
    		case $yn in
	        [Yy]* ) install_java; break;;
        	[Nn]* ) break;;
	        * ) echo "Please answer yes or no.";;
	    esac
	done
fi

if [[ "$_JAVA" ]]; then
	VERSION=$("$_JAVA" -version 2>&1 | awk -F '"' '/version/ {print $2}')
	/bin/echo "${INFO_LOG} Java version $VERSION"
	if [[ "$VERSION" < "1.8" ]]; then
		/bin/echo "${ERROR_LOG} Java JRE/JDK version should be at least 8, please upgrade it to a proper version to continue with SonarQube installation"
		exit 0
	fi
fi

# Select a database to use within SonarQube, it is advisable no to use H2 the embedded database of SonarQube in production environment, instead we can use MySql, PostgreSQL, Oracle, MSSQL. But for now, we are going to pick MySql.
/bin/echo "Checking MySql installation"
if type -f mysql >/dev/null; then
	/bin/echo "${INFO_LOG} Found executable in path: $(type -f mysql)"
	_MYSQL=mysql
else
	/bin/echo "${ERROR_LOG} MySql not found"
	# We are going to provide a way to install MySql
	while /bin/true; do
	read -p "Do you wish this tool to install MySql, (but you still gotta input some information)? [y/n]" yn
	    case $yn in
        	[Yy]* ) install_mysql; break;;
	        [Nn]* ) break;;
        	* ) echo "Please answer yes or no.";;
	    esac
	done
fi

if [[ "$_MYSQL" ]]; then
	VERSION=$("$_MYSQL" --version 2>&1)
	/bin/echo "${INFO_LOG} MySql version $VERSION"
	if [[ "$VERSION" < "5.6" ]]; then
		/bin/echo "${ERROR_LOG} MySql version should be at least 5.6, please install a proper version to continue with SonarQube installation"
		exit 0
	fi
fi

/bin/echo "-----------------------------------------------------------------"
/bin/echo "     Creating an empty schema and a SonarQube user in Mysql"
/bin/echo "-----------------------------------------------------------------"

while /bin/true; do
read -p "Do you wish this tool to prepare the schema, user and privileges? [y/n]" yn
    case $yn in
       	[Yy]* ) configure_mysql; break;;
        [Nn]* ) break;;
       	* ) echo "Please answer yes or no.";;
    esac
done
configure_mysql ()
{
	/bin/echo -n "Enter the name of the database for SonarQube, followed by [ENTER]:"
	read MYSQL_SQ_DB
	/bin/echo -n "Enter the username used for SonarQube, followed by [ENTER]:"
	read MYSQL_SQ_USER
	/bin/echo -n "Enter the password of the user, followed by [ENTER]:"
	read -s MYSQL_SQ_PW
	/bin/echo
	/bin/echo -n "Please enter the MySql password of the root user, this password won't be stored:"
	read -s MYSQL_PASS

	/usr/bin/mysql -u root -p${MYSQL_PASS} -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_SQ_DB};"
	/usr/bin/mysql -u root -p${MYSQL_PASS} -e "CREATE USER '${MYSQL_SQ_USER}'@'localhost' IDENTIFIED BY '${MYSQL_SQ_PW}';"
	/usr/bin/mysql -u root -p${MYSQL_PASS} -e "GRANT ALL PRIVILEGES ON ${MYSQL_SQ_DB}.* TO '${MYSQL_SQ_USER}'@'localhost';"
	/usr/bin/mysql -u root -p${MYSQL_PASS} -e "FLUSH PRIVILEGES;"
}

# If we made it through here, it means we can proceed with SonarQube binaries download, installation and configuration
/bin/echo "---------------------------------------------"
/bin/echo "     Downloading & Configuring SonarQube"
/bin/echo "---------------------------------------------"

# Check if directory exists
/bin/echo "${INFO_LOG} Creating main stuctrure tree directory of SonarQube"
if [ ! -d "/opt/sonarqube" ]; then
 	/usr/bin/sudo /bin/mkdir /opt/sonarqube
	/SONARQUBE_HOME=/opt/sonarqube
	bin/echo "${INFO_LOG} folder created at ${SONARQUBE_HOME}"
else
	SONARQUBE_HOME=/opt/sonarqube
	/bin/echo "${INFO_LOG} folder at ${SONARQUBE_HOME}"
fi
/bin/echo "${INFO_LOG} Downloading binaries at ${SONARQUBE_HOME}"
/usr/bin/sudo /usr/bin/wget -P ${SONARQUBE_HOME} https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-6.4.zip 
/bin/echo "${INFO_LOG} Decompressing folder"
/usr/bin/sudo /usr/bin/unzip ${SONARQUBE_HOME}/sonarqube-6.4.zip -d ${SONARQUBE_HOME} >/dev/null
/usr/bin/sudo /bin/mv ${SONARQUBE_HOME}/sonarqube-6.4 ${SONARQUBE_HOME}/sonar
/usr/bin/sudo /bin/rm -rfv ${SONARQUBE_HOME}/sonarqube-6.4.zip
#/usr/bin/sudo /bin/rm -rfv sonarqube-6.4
/bin/echo "${INFO_LOG} Creating backup of sonar.properties"
/usr/bin/sudo /bin/cp ${SONARQUBE_HOME}/sonar/conf/sonar.properties ${SONARQUBE_HOME}/sonar/conf/sonar.properties.bk 
SONAR_PROP=${SONARQUBE_HOME}/sonar/conf/sonar.properties 

# sonar.properties configuration of Database user and password
/bin/echo "${INFO_LOG} Adding database username and password to sonarqube.properties"
/bin/echo "sonarqube.jdbc.username=${MYSQL_SQ_USER}" | /usr/bin/sudo /usr/bin/tee --append ${SONAR_PROP} 
/bin/echo "sonarqube.jdbc.password=${MYSQL_SQ_PW}" | /usr/bin/sudo /usr/bin/tee --append ${SONAR_PROP}

# sonar.properties configuration of web server information"
/bin/echo "${INFO_LOG} Adding web server information"
/bin/echo "sonarqube.web.host=127.0.0.1" | /usr/bin/sudo /usr/bin/tee --append ${SONAR_PROP}
/bin/echo "sonarqube.web.context=/sonarqube" | /usr/bin/sudo /usr/bin/tee --append ${SONAR_PROP}
/bin/echo "sonarqube.web.port=9000" | /usr/bin/sudo /usr/bin/tee --append ${SONAR_PROP}

# Sonar Scanner binaries download, installation and configuration
/bin/echo "-----------------------------------------------------"
/bin/echo "     Downloading & Configuring Sonar Scanner"
/bin/echo "-----------------------------------------------------"

/bin/echo "${INFO_LOG} Downloading binaries at ${SONARQUBE_HOME}"
/usr/bin/sudo /usr/bin/wget -P ${SONARQUBE_HOME} https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.0.3.778-linux.zip 
/bin/echo "${INFO_LOG} Decompressing folder"
/usr/bin/sudo /usr/bin/unzip ${SONARQUBE_HOME}/sonar-scanner-cli-3.0.3.778-linux.zip -d ${SONARQUBE_HOME} >/dev/null
/usr/bin/sudo /bin/mv ${SONARQUBE_HOME}/sonar-scanner-cli-3.0.3.778-linux ${SONARQUBE_HOME}/sonar-scanner
/usr/bin/sudo /bin/rm -rfv ${SONARQUBE_HOME}/sonar-scanner-cli-3.0.3.778-linux.zip
/usr/bin/sudo /bin/rm -rfv sonar-scanner-cli-3.0.3.778-linux

/bin/echo "${INFO_LOG} Creating backup of sonar-scanner.properties"
/usr/bin/sudo /bin/cp ${SONARQUBE_HOME}/sonar-scanner/conf/sonar-scanner.properties ${SONARQUBE_HOME}/sonar-scanner/conf/sonar-scanner.properties.bk
SONAR_SCANNER_PROP=${SONARQUBE_HOME}/sonar/conf/sonar-scanner.properties

# sonar.properties configuration of Database user and password
/bin/echo "${INFO_LOG} Adding database username and password to sonar.properties"
/bin/echo "sonar.jdbc.username=${MYSQL_SQ_USER}" | /usr/bin/sudo /usr/bin/tee --append ${SONAR_PROP} 
/bin/echo "sonar.jdbc.password=${MYSQL_SQ_PW}" | /usr/bin/sudo /usr/bin/tee --append ${SONAR_PROP}

# sonar.properties configuration of web server information"
/bin/echo "${INFO_LOG} Adding web server information"
/bin/echo "sonar.web.host=127.0.0.1" | /usr/bin/sudo /usr/bin/tee --append ${SONAR_PROP}
/bin/echo "sonar.web.context=/sonar" | /usr/bin/sudo /usr/bin/tee --append ${SONAR_PROP}
/bin/echo "sonar.web.port=9000" | /usr/bin/sudo /usr/bin/tee --append ${SONAR_PROP}

# sonar-scanner.properties configuration
/bin/echo "${INFO_LOG} Adding general information about the environment"
/bin/echo "sonar.host.url=http://localhost:9000/sonar" | /usr/bin/sudo /usr/bin/tee --append ${SONAR_SCANNER_PROP}
/bin/echo "sonar.sourceEncoding=UTF-8" | /usr/bin/sudo /usr/bin/tee --append ${SONAR_SCANNER_PROP}

# sonar-project.properties example
/usr/bin/sudo /usr/bin/touch ${SONARQUBE_HOME}/sonar-project.properties.example
SONAR_SCANNER_PROY_EXAMPLE=${SONARQUBE_HOME}/sonar-project.properties.example
/bin/echo "${INFO_LOG} Creating sample configuration, located at ${SONARQUBE_HOME} named sonar-project.properties.example"
/sur/bin/printf "# must be unique in a given SonarQube instance\n"\
"sonar.projectKey=sample_project\n"\
"# this is the name and version displayed in the SonarQube UI. Was mandatory prior to SonarQube 6.1.\n"\
"sonar.projectName=sample\n"\
"sonar.projectVersion=1.0\n"\
"\n"\
"# Path is relative to the sonar-project.properties file. Replace '\\' by '/' on Windows.\n"\
"# Since SonarQube 4.2, this property is optional if sonar.modules is set.\n"\
"# If not set, SonarQube starts looking for source code from the directory containing\n"\
"# the sonar-project.properties file.\n"\
"sonar.sources=/\n"\
"\n"\
"# Encoding of the source code. Default is default system encoding\n"\
"sonar.sourceEncoding=UTF-8" | /usr/bin/sudo /usr/bin/tee --append ${SONAR_SCANNER_PROY_EXAMPLE}

# Sonarqube & SonarScanner as a service 
/bin/echo "----------------------------------------------------"
/bin/echo "     SonarQube and Sonar Scanner as a service"
/bin/echo "----------------------------------------------------"


# We need to ask if the user wants to install it as a service using the tool
while /bin/true; do
    read -p "Do you wish this tool to put sonar as a service?" yn
    case $yn in
        [Yy]* ) sonar_service; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

sonar_service()
{
	/bin/echo "${INFO_LOG} Do you want it as a service or only as an executable command line?"
	/bin/echo "[1] for bashrc executable command line."
	/bin/echo "[2] as a service, e.g /etc/init.d/ and systemctl."
	read opt
	case $opt in
		1) sonar_bashrc; break;;
		2) sonar_service; break;;
		*) echo "Please answer 1 or 2."
}

sonar_service()
{
	/bin/echo "${INFO_LOG} Creating rc file for SonarQube at /etc/init.d/"
	/usr/bin/sudo /usr/bin/touch /etc/init.d/sonar
	printf "#!/bin/sh\n"\
		"#\n"\
		"# rc file for SonarQube\n"\
		"#\n"\
		"# chkconfig: 345 96 10\n"\
		"# description: SonarQube system (www.sonarsource.org)\n"\
		"#\n"\
		"### BEGIN INIT INFO\n"\
		"# Provides: sonar\n"\
		"# Required-Start: $network\n"\
		"# Required-Stop: $network\n"\
		"# Default-Start: 3 4 5\n"\
		"# Default-Stop: 0 1 2 6\n"\
		"# Short-Description: SonarQube system (www.sonarsource.org)\n"\
		"# Description: SonarQube system (www.sonarsource.org)\n"\
		"### END INIT INFO\n"\
		"\n"\
		"/usr/bin/sonar $*" | /usr/bin/sudo /usr/bin/tee --append /etc/init.d/sonar
		
	/bin/echo "${INFO_LOG} Creating symlink found at ${SONARQUBE_HOME}/sonar/bin/linux-x86-64/sonar.sh"
	/usr/bin/sudo /bin/ln -s ${SONARQUBE_HOME}/sonar/bin/linux-x86-64/sonar.sh /usr/bin/sonar
	/usr/bin/sudo /bin/chmod 755 /etc/init.d/sonar
	/usr/bin/sudo update-rc.d sonar defaults
	/bin/echo "${INFO_LOG} SonarQube as a service done..."
	/bin/echo "${INFO_LOG} You can now use it as follows: /etc/init.d/sonar { console | start | stop | restart | status | dump }"
}

sonar_bashrc()
{
	
}
