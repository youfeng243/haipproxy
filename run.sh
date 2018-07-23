#!/bin/bash



start() {
	status
	if [ ! $? -eq 0 ]; then
		echo "process is already running.."
		return 1
	fi

    stop

    mkdir -p logs
    nohup python crawler_booter.py --usage crawler common > logs/crawler.log 2>&1 &
    nohup python scheduler_booter.py --usage crawler common > logs/crawler_scheduler.log 2>&1 &
    nohup python crawler_booter.py --usage validator init > logs/init_validator.log 2>&1 &
    nohup python crawler_booter.py --usage validator https > logs/https_validator.log 2>&1&
    nohup python scheduler_booter.py --usage validator https > logs/validator_scheduler.log 2>&1 &
    nohup python proxy_server.py > /dev/null 2>&1 &

    #nohup python squid_update.py --usage https --interval 3 > squid.log 2>&1 &
    #rm -rf /var/run/squid.pid
    #squid -N -d1


    echo "process start success..."
}

stop() {


    ps -ef | grep python | grep -v grep | grep crawler_booter | grep crawler | grep common | awk '{print $2}' | xargs kill -9


    ps -ef | grep python | grep -v grep | grep scheduler_booter | grep crawler | grep common | awk '{print $2}' | xargs kill -9


    ps -ef | grep python | grep -v grep | grep crawler_booter | grep validator | grep init | awk '{print $2}' | xargs kill -9


	ps -ef | grep python | grep -v grep | grep crawler_booter | grep validator | grep https | awk '{print $2}' | xargs kill -9


	ps -ef | grep python | grep -v grep | grep scheduler_booter | grep validator | grep https | awk '{print $2}' | xargs kill -9


    ps -ef | grep python | grep -v grep | grep proxy_server | awk '{print $2}' | xargs kill -9


    sleep 2

	status
	[ $? -eq 0 ] && echo "process stop success..." && return 1

	echo "process stop fail..."
	return 0
}

status() {

    pid=`ps -ef | grep python | grep -v grep | grep crawler_booter | grep crawler | grep common | awk '{print $2}'`
    if [ -z "${pid}" ]; then
        echo "python crawler_booter.py --usage crawler common 不存在..."
        return 0
    fi
    echo "python crawler_booter.py --usage crawler common ${pid}"

    pid=`ps -ef | grep python | grep -v grep | grep scheduler_booter | grep crawler | grep common | awk '{print $2}'`
    if [ -z "${pid}" ]; then
        echo "python scheduler_booter.py --usage crawler common 不存在..."
        return 0
    fi
    echo "python scheduler_booter.py --usage crawler common ${pid}"

    pid=`ps -ef | grep python | grep -v grep | grep crawler_booter | grep validator | grep init | awk '{print $2}'`
    if [ -z "${pid}" ]; then
        echo "python crawler_booter.py --usage validator init 不存在..."
        return 0
    fi
    echo "python crawler_booter.py --usage validator init ${pid}"

    pid=`ps -ef | grep python | grep -v grep | grep crawler_booter | grep validator | grep https | awk '{print $2}'`
    if [ -z "${pid}" ]; then
        echo "python crawler_booter.py --usage validator https 不存在..."
        return 0
    fi
    echo "python crawler_booter.py --usage validator https ${pid}"

    pid=`ps -ef | grep python | grep -v grep | grep scheduler_booter | grep validator | grep https | awk '{print $2}'`
    if [ -z "${pid}" ]; then
        echo "python scheduler_booter.py --usage validator https 不存在..."
        return 0
    fi
    echo "python scheduler_booter.py --usage validator https ${pid}"

    pid=`ps -ef | grep python | grep -v grep | grep proxy_server | awk '{print $2}'`
    if [ -z "${pid}" ]; then
        echo "python proxy_server.py 不存在..."
        return 0
    fi
    echo "python proxy_server.py ${pid}"

    return 1
}

restart() {
    stop
    sleep 1
    start
}

case "$1" in
	start|stop|restart|status)
  		$1
		;;
	*)
		echo $"Usage: $0 {start|stop|status|restart}"
		exit 1
esac
