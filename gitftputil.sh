#!/usr/bin/env bash
script_name=gitftputil

mkdir -p "$HOME/.config/gitftputil/servers"
mkdir -p "$HOME/.config/gitftputil/deployments"

if [[ -z "$1" ]];
then
    echo ""
    echo "Usage:"
    echo "⚡ $script_name <deployment>                Run the specified deployment config"
    echo "📋 $script_name ls                          List all deployments and servers"
    echo "🌍 $script_name mk s <name>                 Create a new server config"
    echo "📁 $script_name mk d <name>                 Create a new deployment config"
    echo "✍️ $script_name edit s <name>               Edit specified server"
    echo "✍️ $script_name edit d <name>               Edit specifed deployment"
    echo "🗑️ $script_name rm s <name>                 Delete specified server"
    echo "🗑️ $script_name rm d <name>                 Delete specified deplyment"
    echo "🏷️ $script_name mv <old_deployment> <new>   Rename a deployment"
    echo "Made with ❤️ by Wanieru"
    echo "https://github.com/wanieru/gitftputil.sh/"
    exit 0
fi
if [[ $1 = "ls" ]];
then
    echo -n "🌍 Servers: "
    ls "$HOME/.config/gitftputil/servers"
    echo "";
    echo -n "📁 Deployments: "
    ls "$HOME/.config/gitftputil/deployments"
    echo ""
    exit 0
fi
if [[ $1 = "rm" ]];
then
    if [[ $2 = "s" ]];
    then   
        if [[ -z "$3" ]]; then echo "❌ Wrong usage."; exit 1; fi
        rm "$HOME/.config/gitftputil/servers/$3"
        exit 0 
    fi
    if [[ $2 = "d" ]];
    then   
        if [[ -z "$3" ]]; then echo "❌ Wrong usage."; exit 1; fi
        rm "$HOME/.config/gitftputil/deployments/$3"
        exit 0 
    fi
    echo "❌ Wrong usage."
    exit 1
fi
if [[ $1 = "edit" ]];
then
    if [[ $2 = "s" ]];
    then   
        if [[ -z "$3" ]]; then echo "❌ Wrong usage."; exit 1; fi
        if [ ! -f "./gitftp_server" ]; 
        then 
            if [ ! -f "$HOME/.config/gitftputil/servers/$3" ]; then echo "❌ $3 doesn't exists."; exit 1; fi
            while true
            do
                7za -y e "$HOME/.config/gitftputil/servers/$3"
                if [ "$?" -eq "0" ]; then 
                    break
                fi
            done
        fi
        nano ./gitftp_server
        chmod +x ./gitftp_server
        while true
        do
            7za a -tzip -p -mem=AES256 "$HOME/.config/gitftputil/servers/$3.zip" "gitftp_server"
            if [ -f "$HOME/.config/gitftputil/servers/$3.zip" ]; then 
                break 
            fi
        done
        rm "$HOME/.config/gitftputil/servers/$3"
        mv "$HOME/.config/gitftputil/servers/$3.zip" "$HOME/.config/gitftputil/servers/$3"
        rm ./gitftp_server
        exit 0 
    fi
    if [[ $2 = "d" ]];
    then   
        if [[ -z "$3" ]]; then echo "❌ Wrong usage."; exit 1; fi
        if [ ! -f "$HOME/.config/gitftputil/deployments/$3" ]; then echo "❌ $3 doesn't exists."; exit 1; fi
        nano "$HOME/.config/gitftputil/deployments/$3"
        exit 0 
    fi
    echo "❌ Wrong usage."
    exit 1
fi
if [[ $1 = "mv" ]];
then
    if [[ -z "$2" ]]; then echo "❌ Wrong usage."; exit 1; fi
    if [[ -z "$3" ]]; then echo "❌ Wrong usage."; exit 1; fi

    if [ ! -f "$HOME/.config/gitftputil/deployments/$2" ]; then echo "❌ $2 doesn't exists."; exit 1; fi
    if [ -f "$HOME/.config/gitftputil/deployments/$3" ]; then echo "❌ $3 already exists."; exit 1; fi
    mv "$HOME/.config/gitftputil/deployments/$2" "$HOME/.config/gitftputil/deployments/$3"
    echo "🏷️ Renamed $2 to $3"
    exit 0
fi

if [[ $1 = "mk" ]];
then
    if [[ $2 = "s" ]];
    then   
        if [[ -z "$3" ]]; then echo "❌ Wrong usage."; exit 1; fi
        if [ -f "$HOME/.config/gitftputil/servers/$3" ]; then echo "❌ Server already exists."; exit 1; fi
        if [ ! -f "./gitftp_server" ]; then echo "❌ Temp file 'gitftp_server' already exists."; 
        read -p "🌍 Ftp host: " ftp_host    
        read -p "🔑 Ftp username: " ftp_username    
        read -sp "🔑 Ftp password: " ftp_password    
        echo "#Fill in this template.
export GIT_URL=$ftp_host
export GIT_USER=$ftp_username
export GIT_PASSWORD=$ftp_password" > "./gitftp_server"

        fi
        nano ./gitftp_server
        chmod +x ./gitftp_server
        while true
        do
            7za a -tzip -p -mem=AES256 "$HOME/.config/gitftputil/servers/$3.zip" "gitftp_server"
            if [ -f "$HOME/.config/gitftputil/servers/$3.zip" ]; then 
                break 
            fi
        done
        mv "$HOME/.config/gitftputil/servers/$3.zip" "$HOME/.config/gitftputil/servers/$3"
        rm ./gitftp_server
        exit 0 
    fi
    if [[ $2 = "d" ]];
    then   
        if [[ -z "$3" ]]; then echo "❌ Wrong usage."; exit 1; fi
        if [ -f "$HOME/.config/gitftputil/deployments/$3" ]; then echo "❌ Deployment already exists."; exit 1; fi
        echo -n "🌍 Available servers: "
        ls "$HOME/.config/gitftputil/servers"
        echo ""
        read -p "🌍 Choose server: " selected_server
        echo "🔀 Available branches: "
        git branch -a
        read -p "🔀 Choose branch: " selected_branch
        read -p "📂 Choose location on server: " location_on_server
        if [ ! -f "$HOME/.config/gitftputil/servers/$selected_server" ]; then echo "❌ $selected_server doesn't exist."; exit 1; fi

        echo "#!/bin/bash
export GIT_PATH=$PWD
export GIT_BRANCH=$selected_branch
export GIT_SERVER=$selected_server
export GIT_LOCATION=$location_on_server" > "$HOME/.config/gitftputil/deployments/$3"

        nano "$HOME/.config/gitftputil/deployments/$3"
        chmod +x "$HOME/.config/gitftputil/deployments/$3"
        exit 0 
    fi
    echo "❌ Wrong usage."
    exit 1
fi

#Try starting $1 as a deployment!

#Check and source deployment
if [ ! -f "$HOME/.config/gitftputil/deployments/$1" ]; then echo "❌ Deployment $1 doesn't exists."; exit 1; fi
source "$HOME/.config/gitftputil/deployments/$1"

#Check, unpack server config
if [ ! -f "$HOME/.config/gitftputil/servers/$GIT_SERVER" ]; then echo "❌ Server $GIT_SERVER doesn't exists."; exit 1; fi
7za e "$HOME/.config/gitftputil/servers/$GIT_SERVER"
if [ "$?" -ne "0" ]; then
    exit 0
fi

#Source and remove server config
source ./gitftp_server
rm ./gitftp_server

#Go to git repo
cd $GIT_PATH
git checkout $GIT_BRANCH

#Set up git-ftp
git config git-ftp.url "$GIT_URL/$GIT_LOCATION"
git config git-ftp.user "$GIT_USER"
git config git-ftp.password "$GIT_PASSWORD"

echo "🔑 $(git config git-ftp.user)@$(git config git-ftp.url):******"

#Do git-ftp payloads
while true
do
    read -p "🚀 Enter git ftp command (init/push/catchup/exit): " command
    if [ "$command" = "exit" ]; then
        break
    fi
    git ftp $command
done

#Clear git-ftp config
git config git-ftp.url dummy
git config git-ftp.user dummy
git config git-ftp.password dummy
