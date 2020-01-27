Bla='\e[0;30m';     BBla='\e[1;30m';    UBla='\e[4;30m';    IBla='\e[0;90m';    BIBla='\e[1;90m';   On_Bla='\e[40m';    On_IBla='\e[0;100m';
Red='\e[0;31m';     BRed='\e[1;31m';    URed='\e[4;31m';    IRed='\e[0;91m';    BIRed='\e[1;91m';   On_Red='\e[41m';    On_IRed='\e[0;101m';
Gre='\e[0;32m';     BGre='\e[1;32m';    UGre='\e[4;32m';    IGre='\e[0;92m';    BIGre='\e[1;92m';   On_Gre='\e[42m';    On_IGre='\e[0;102m';
Yel='\e[0;33m';     BYel='\e[1;33m';    UYel='\e[4;33m';    IYel='\e[0;93m';    BIYel='\e[1;93m';   On_Yel='\e[43m';    On_IYel='\e[0;103m';
Blu='\e[0;34m';     BBlu='\e[1;34m';    UBlu='\e[4;34m';    IBlu='\e[0;94m';    BIBlu='\e[1;94m';   On_Blu='\e[44m';    On_IBlu='\e[0;104m';
Pur='\e[0;35m';     BPur='\e[1;35m';    UPur='\e[4;35m';    IPur='\e[0;95m';    BIPur='\e[1;95m';   On_Pur='\e[45m';    On_IPur='\e[0;105m';
Cya='\e[0;36m';     BCya='\e[1;36m';    UCya='\e[4;36m';    ICya='\e[0;96m';    BICya='\e[1;96m';   On_Cya='\e[46m';    On_ICya='\e[0;106m';
Whi='\e[0;37m';     BWhi='\e[1;37m';    UWhi='\e[4;37m';    IWhi='\e[0;97m';    BIWhi='\e[1;97m';   On_Whi='\e[47m';    On_IWhi='\e[0;107m';
NC='\033[0m' # No Color

###### most requested directories
alias ..='cd ..'
alias home='cd ~'

###### open with sublime
alias profile='code /Users/developer/.bash_profile'
alias hosts='code /etc/hosts'
alias vhosts='code /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf'
alias logdb='code /tmp/mysql.log'
alias inis='code /Applications/MAMP/bin/php/php7.2.14/conf/php.ini && code /Applications/MAMP/conf/php7.2.14/php.ini'

###### open with vscode
alias sublprojects='code ~/Library/Application\ Support/Sublime\ Text\ 3/Local/Session.sublime_session'

###### apache
alias a2restart='sudo /Applications/MAMP/Library/bin/apachectl restart'

###### git 
alias undo="git reset HEAD~"
#Nice bonus: the `&&` means it won't try to push if there are merge conflicts during the rebase.
alias repush='git pull --rebase && git push'
#Create a zip of all changed files and their folders 
#alias zipchanges'git archive -o http://updates.zip  HEAD $(git diff --name-only HEAD)'

###### doctrine
alias createdb='vendor/bin/doctrine orm:schema-tool:create'
alias updatedb='vendor/bin/doctrine orm:schema-tool:update --force --dump-sql'
alias deletedb='vendor/bin/doctrine orm:schema-tool:drop --force'
alias createentities='vendor/bin/doctrine orm:generate-entities ./entities/ --generate-methods=true'
alias clearresultcache='vendor/bin/doctrine orm:clear-cache:result --flush'
alias clearmetadatacache='vendor/bin/doctrine orm:clear-cache:metadata --flush'
alias clearquerycache='vendor/bin/doctrine orm:clear-cache:query --flush'

cleardbcache () {
  clearresultcache && clearmetadatacache && clearquerycache
}

###### composer
alias da='composer dump-autoload'
alias dao='composer dump-autoload --optimize --apcu'

###### MYSQL
alias mysql=/Applications/MAMP/Library/bin/mysql

#https://gist.github.com/irazasyed/a7b0a079e7727a4315b9/

# Create Folder
createdir(){
  mkdir -p /Applications/MAMP/htdocs/$1
}

# Restar Apache
restartapache(){
  sudo /Applications/MAMP/Library/bin/apachectl restart
  clear
}

opensite(){
  open "http://$1.lh"
}

# virtual host
createvh(){

  sudo -- sh -c -e "echo '127.0.0.1\t$1.lh' >> /etc/hosts";
  sh -c -e "echo '
    <VirtualHost *:80>
      DocumentRoot \"/Applications/MAMP/htdocs/$1\" 
      ServerName $1.lh 
    </VirtualHost>' >> /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf"

  read "?Deseja criar uma nova pasta? [y/N]" response
  case $response in
      [Yy]* )
          createdir $1
          ;;
      * )
  esac

  read "?Deseja reniciar o Apache? [y/N]" response
  clear
  case $response in
      [Yy]* )
          restartapache
          ;;
      * )
  esac

  read "?Deseja abrir o navegador? [y/N]" response
  case $response in
      [Yy]* )
          opensite $1
          ;;
      * )
  esac


}

# Htdocs Folder 
htdocs () {
  case $2 in
    "") cd /Applications/MAMP/htdocs/$1;;
    "--code") cd /Applications/MAMP/htdocs/$1 && code .;;
  esac
}

# Create Project
create() {

  # Create Projet App #
  # # # # # # # # # # #

  # Check se required is passed
  local CONTINUE=0

  # Check if yes for all
  local ALL=0

  # Check is help
  local HELP=0

  # Globais function
  local DBHOST="127.0.0.1"
  local DBUSER="root"
  local DBPASS="root"
  local DBPORT="3306"

  # Git clone
  local GITCLONE="git@bitbucket.org:dev-netpixel/default.git"

  # Folder is default mamp mac os
  local MAMPHTDOCS="/Applications/MAMP/htdocs"

  while [[ "$#" -gt 0 ]]
  do
    case $1 in
      -h|--help)
        echo "
${BIGre} * App Create Development *: ${NC} 
${BIPur} * @Author: ${NC} ${Gre}    Wallace Fontes ${NC}
${BIPur} * @Date: ${NC} ${Gre}      20/09/2019 ${NC}
${BIPur} * @Company: ${NC} ${Gre}   NetPixel ${NC}
${BPur} * * * * * * * * * * * * * ${NC}

${IYel} Usage: ${NC} 
        ${Gre} [--][<command_name>] ${NC} 
 
${IYel} Options: ${NC} 
        ${Gre} -n or --name ${NC} ${Whi}        Project name ${NC} ${BIRed}*required*${NC} 
        ${Gre} -dbn or --dbname ${NC} ${Whi}    Database name ${NC} 
        ${Gre} -dbh or --dbhost ${NC} ${Whi}    Database hostname ${NC} 
        ${Gre} -dbu or --dbuser ${NC} ${Whi}    Database username ${NC} 
        ${Gre} -dbp or --dbpass ${NC} ${Whi}    Database password ${NC} 
        ${Gre} -dbport ${NC} ${Whi}             Database port ${NC} 
        ${Gre} -gc or --gitclone ${NC} ${Whi}   Project clone git ${NC} 

${IYel} Optionals: ${NC} 
        ${Gre} -a or --all or --yes ${NC} ${Whi}    Yes to questions ${NC} 
                                  ${BIRed} composer install ${NC}
                                  ${BIRed} npm insall ${NC}
                                  ${BIRed} db install ${NC}
                                  ${BIRed} db insert ${NC}
                                  ${BIRed} git remote origin ${NC}

${IYel} Configure Default: ${NC} 
    ${Gre} DBHOST   : ${NC} ${Whi}    ${DBHOST} ${NC} 
    ${Gre} DBUSER   : ${NC} ${Whi}    ${DBUSER} ${NC} 
    ${Gre} DBPASS   : ${NC} ${Whi}    ${DBPASS} ${NC} 
    ${Gre} DBPORT   : ${NC} ${Whi}    ${DBPORT} ${NC} 
    ${Gre} GITCLONE :${NC} ${Whi}     ${GITCLONE} ${NC} 
    ${Gre} MAMPHTDOCS :${NC} ${Whi}   ${MAMPHTDOCS} ${NC} 
        "
        local HELP=1
        break
        ;;
      -n|--name)
        local NAME="$2" 
        local DBNAME="$2"
        local CONTINUE=1
        ;;
      -dbn|--dbname)
        local DBNAME="$2"
        ;;
      -dbh|--dbhost)
        local DBHOST="$2"
        ;;
      -dbu|--dbuser)
        local DBUSER="$2"
        ;;
      -dbp|--dbpass)
        local DBPASS="$2"
        ;;
      -dbport)
        local DBPORT="$2"
        ;;
      -gc|--gitclone)
        local GITCLONE="$2"
        ;;
      -a|--all|--yes)
        local ALL=1
        ;;
      *)
        local EMPTY=true
        ;;
    esac
    shift
  done

if [ $CONTINUE -eq 1 ]
then

  echo "${BIGre} * Initializing Application * ${NC}"
  sleep 5

  if [ -d "$MAMPHTDOCS/$NAME" ]
  then
     echo "Directory or project already exists."
     read "?Please enter a new project name " response
    local NAME="$response" 
    # local DBNAME="$response"
  fi

  echo "${Gre} * Start * ${NC}"


  sudo -- sh -c -e "echo '127.0.0.1\t$NAME.lh' >> /etc/hosts";
  
  sh -c -e "echo '
    <VirtualHost *:80>
      DocumentRoot \"/$MAMPHTDOCS/$NAME\" 
      ServerName $NAME.lh 
    </VirtualHost>' >> /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf"


  cd /Applications/MAMP/htdocs

  clear

  echo "Clonando Projeto ........."
  
  sleep 0.05

  git clone $GITCLONE $NAME
  
  clear
    
  sleep 0.05

  if [ $ALL -eq 0 ]
  then
    read "?Do you want to install composer (*important for doctrine*)? [y/N]" response
    case $response in
        [Yy]* )
            htdocs $NAME &&  composer install
            ;;
        * )
    esac
  sleep 0.05
  else
  htdocs $NAME &&  composer install
  fi

  clear

  if [ $ALL -eq 0 ]
  then
    read "?Do you want to install NPM? [y/N]" response
    case $response in
        [Yy]* )
            htdocs $NAME && npm install
            ;;
        * )
    esac
    sleep 0.05
  else
    htdocs $NAME && npm install
  fi

  clear

  if [ $ALL -eq 0 ]
  then
    read "?Do you want to restart the Apache? [y/N]" response
    case $response in
        [Yy]* )
            restartapache && echo "Apache Restartado" && sleep 1
            ;;
        * )
    esac
    clear
  else
    restartapache && echo "Apache Restartado" && sleep 1
  fi

  sleep 0.05

  if [ $ALL -eq 0 ]
  then
    read "?Do you want to create new database? [y/N]" response
    case $response in
        [Yy]* )

            DBEXISTS=$(mysql --host=127.0.0.1 -uroot -proot --batch --skip-column-names -e "SHOW DATABASES LIKE '"$DBNAME"';" | grep "$DBNAME" > /dev/null; echo "$?")
            clear
            if [ $DBEXISTS -eq 0 ];then
                echo "A database with the name $DBNAME already exists."
                read "?Please choose another name for the database " response
                local DBNAME="$response"
            fi
            clear && mysql --host=$DBHOST -uroot -proot -e "CREATE DATABASE $DBNAME;"
            ;;
        * )
    esac
    clear
  else
  
    DBEXISTS=$(mysql --host=127.0.0.1 -uroot -proot --batch --skip-column-names -e "SHOW DATABASES LIKE '"$DBNAME"';" | grep "$DBNAME" > /dev/null; echo "$?")
    clear
    if [ $DBEXISTS -eq 0 ];then
        echo "A database with the name $DBNAME already exists. exiting"
        read "?Please choose another name for the database " response
        local DBNAME="$response"
    fi
    clear && mysql --host=$DBHOST -uroot -proot -e "CREATE DATABASE $NAME;"
  fi


  if [ $ALL -eq 0 ]
    then
    read "?Import default database? [y/N]" response
    case $response in
        [Yy]* )
            sudo -- sh -c -e "echo ' 
  URL=http://$NAME.lh/
  DISPLAY_ERRORS=1
  DB_DEVMODE=true
  DB_DRIVE=pdo_mysql
  DB_CHARSET=utf8mb4
  DB_HOST=$DBHOST
  DB_PORT=$DBPORT
  DB_DATABASE=$DBNAME
  DB_USERNAME=$DBUSER
  DB_PASSWORD=$DBPASS' >> /$MAMPHTDOCS/$NAME/configs/dev.env" && updatedb 
            ;;
        * )
    esac
  clear
  else
  sudo -- sh -c -e "echo ' 
  URL=http://$NAME.lh/
  DISPLAY_ERRORS=1
  DB_DEVMODE=true
  DB_DRIVE=pdo_mysql
  DB_CHARSET=utf8mb4
  DB_HOST=$DBHOST
  DB_PORT=$DBPORT
  DB_DATABASE=$DBNAME
  DB_USERNAME=$DBUSER
  DB_PASSWORD=$DBPASS' >> /$MAMPHTDOCS/$NAME/configs/dev.env" && updatedb 
  fi
  sleep 0.05


  if [ $ALL -eq 0 ]
  then
    read "?Insert default data into database? [y/N]" response
    case $response in
        [Yy]* )
            htdocs $NAME && mysql --host=$DBHOST --user=$DBUSER --password=$DBPASS $DBNAME < database_insert.sql
            ;;
        * )
    esac
    clear
  else
  htdocs $NAME && mysql --host=$DBHOST --user=$DBUSER --password=$DBPASS $DBNAME < database_insert.sql
  fi

  
  if [ $ALL -eq 0 ]
  then
    read "?Do you want to open project in Visual Code? [y/N]" response
    case $response in
        [Yy]* )
            code $MAMPHTDOCS/$NAME
            ;;
        * )
    esac
    sleep 0.05
    clear
    else
    code $MAMPHTDOCS/$NAME
  fi

  if [ $ALL -eq 0 ]
  then
    read "?Do you want to remove Origin the project to Bitbucket? [y/N]" response
    case $response in
        [Yy]* )
            git remote rm origin
            ;;
        * )
    esac
    sleep 0.05  
    clear
  else
    git remote rm origin
  fi
  
  clear

  echo "Remember to Link to a new project in Bitbucket, here is already unlinked from $GITCLONE"

  if [ $ALL -eq 0 ]
  then
    read '?Do you want to open browser? [y/N] ' nav
    case $nav in
        [Yy]* )
            opensite $NAME
            break;;
        * )
    esac
  else
  opensite $NAME
  fi
  echo "Completed"
else
  if [ $HELP -eq 0 ]
  then
    # echo "${BIGre} * App Create Development *: ${NC}" 
echo "${BIRed}    Please, required --name or -n Project Name ${NC}"
echo "${IYel}     quick help on --help or -h ${NC}"
  fi

fi


}

autoload bashcompinit
bashcompinit

app (){
  case $2 in
    "") cd ~/Developer/ReactNative/$1;;
    "--code") cd ~/Developer/ReactNative/$1 && code .;;
    "--start-android") cd ~/Developer/ReactNative/$1 && code . && react-native run-android;;
    "--start-ios") cd ~/Developer/ReactNative/$1 && code . && react-native run-ios;;
  esac
}

_appComplete()
{
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "$(ls ~/Developer/ReactNative/)" -- $cur) )
}


_codeComplete()
{
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "$(ls /Applications/MAMP/htdocs/)" -- $cur) )
}

complete -F _codeComplete htdocs

complete -F _appComplete app

# Editing common files
alias editbash="code ~/.bash_profile"
alias edithosts='code ~/Applications/MAMP/conf/apache/extra/httpd-vhosts.conf' 


# npm
alias nrs='npm run start'
alias nrd='npm run dev'
alias nrb='npm run build'


check_exist_db(){
DBNAME="$3"
DBEXISTS=$(mysql --host=127.0.0.1 -uroot -proot --batch --skip-column-names -e "SHOW DATABASES LIKE '"$DBNAME"';" | grep "$DBNAME" > /dev/null; echo "$?")
if [ $DBEXISTS -eq 0 ];then
    echo "A database with the name $DBNAME already exists. exiting"
    return false;
fi
}

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)