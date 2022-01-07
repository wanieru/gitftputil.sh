#!/usr/bin/env bash
script_name=gitftputil

ask_key()
{
    read -s -p "Encryption key: " password
}

if [[ -z "$1" ]];
then
    status
    echo ""
    echo "Usage:"
    echo "⚡ $script_name <deployment>                Run the specified deployment config"
    echo "📋 $script_name ls                          List all deployments and servers"
    echo "🌍 $script_name create server               Create a new server config"
    echo "📁 $script_name create deployment           Create a new deployment config"
    echo "✍️ $script_name edit server <name>          Edit specified server"
    echo "✍️ $script_name edit deployment <name>      Edit specifed deployment"
    echo "🗑️ $script_name rm server <name>            Delete specified server"
    echo "🗑️ $script_name rm deployment <name>        Delete specified deployment"
    echo "Made with ❤️ by Wanieru"
    echo "https://github.com/wanieru/gitftputil.sh/"
    exit 0
fi
if [[ $1 = "ls"]];
then
    #List server zips and deployment zips 
    exit 0
fi
if [[ $1 = "rm"]];
then
    if [[ $2 = "server" ]];
    then   
        #Remove specified server zip
        exit 0 
    fi
    if [[ $2 = "deployment" ]];
    then   
        #Remove specified deployment zip
        exit 0 
    fi
fi
if [[ $1 = "edit"]];
then
    if [[ $2 = "server" ]];
    then   
        #Ask password
        #Unpack the specified server
        #Nano it
        #Repack it
        exit 0 
    fi
    if [[ $2 = "deployment" ]];
    then   
        #Ask password
        #Unpack the specified deployment
        #Nano it
        #Repack it
        exit 0 
    fi
fi

if [[ $1 = "create"]];
then
    if [[ $2 = "server" ]];
    then   
        #Ask password
        #Create a server file template
        #nano it
        #pack it up with the specified password.
        exit 0 
    fi
    if [[ $2 = "deployment" ]];
    then   
        #Ask server
        #Ask password
        #Create a deployment file template
        #nano it
        #pack it up with the specified password.
        exit 0 
    fi
fi

#Unpack server
#Unpack deployment
#Run deployment
#Rm unpacked files