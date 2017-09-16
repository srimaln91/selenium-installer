#!/bin/bash
SERVICE_NAME=selenium
PATH_TO_JAR=/usr/local/bin/selenium-server-standalone-3.5.3.jar
CHROME_DRIVER=/usr/local/bin/chromedriver
PID_PATH_NAME=/tmp/selenium-pid
START_COMMAND="java -Dwebdriver.chrome.driver=$CHROME_DRIVER -jar $PATH_TO_JAR"

case $1 in
    start)
        echo "Starting $SERVICE_NAME ..."
        if [ ! -f $PID_PATH_NAME ]; then
            nohup $START_COMMAND &
                        echo $! > $PID_PATH_NAME
            echo "$SERVICE_NAME started ..."
        else
            echo "$SERVICE_NAME is already running ..."
        fi
    ;;
    stop)
        if [ -f $PID_PATH_NAME ]; then
            PID=$(cat $PID_PATH_NAME);
            #echo $PID
            echo "$SERVICE_NAME stoping ..."
            pkill $PID;
            echo "$SERVICE_NAME stopped ..."
            rm $PID_PATH_NAME
        else
            echo "$SERVICE_NAME is not running ..."
        fi
    ;;
    restart)
        if [ -f $PID_PATH_NAME ]; then
            PID=$(cat $PID_PATH_NAME);
            echo "$SERVICE_NAME stopping ...";
            pkill $PID;
            echo "$SERVICE_NAME stopped ...";
            rm $PID_PATH_NAME
            echo "$SERVICE_NAME starting ..."
            nohup $START_COMMAND /tmp 2>> /dev/null >> /dev/null &
                        echo $! > $PID_PATH_NAME
            echo "$SERVICE_NAME started ..."
        else
            echo "$SERVICE_NAME is not running ..."
        fi
    ;;
    status)
        if [ -f $PID_PATH_NAME ]; then
            echo "Service is running."
        else
            echo "Service is not running."
        fi
    ;;
esac