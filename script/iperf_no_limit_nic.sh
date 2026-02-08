#!/bin/bash

PASS="rjRXnExEzpK7"
TIME=30

# 节点信息
NODES=("n0" "n1" "n2" "n3")
HOSTS=("nf7.usc.edu" "nf8.usc.edu" "nf9.usc.edu" "nf5.usc.edu")
IPS=("10.0.4.3" "10.0.5.3" "10.0.6.3" "10.0.7.3")
PORTS=("5010" "5011" "5012" "5013")

BW=1G
PKT=512

for i in {0..3}; do
    SERVER_NODE=${NODES[$i]}
    SERVER_HOST=${HOSTS[$i]}
    SERVER_IP=${IPS[$i]}
	SERVER_PORT=${PORTS[$i]}

    echo "=============================="
    echo "SERVER: $SERVER_NODE ($SERVER_IP)"
    echo "=============================="

    # 1. 启动 iperf server（只 kill 自己的 iperf）
    sshpass -p $PASS ssh -o StrictHostKeyChecking=no node1@$SERVER_HOST \
		"nohup iperf -s -p $SERVER_PORT" \
		 > ./log/nic/iperf_server_${SERVER_NODE}.log 2>&1 &
	sleep 1

    # 2. 其他节点作为 client
    for j in {0..3}; do
        if [ $j -ne $i ]; then
            CLIENT_NODE=${NODES[$j]}
            CLIENT_HOST=${HOSTS[$j]}

            echo "Client $CLIENT_NODE -> Server $SERVER_NODE"

            sshpass -p $PASS ssh -o StrictHostKeyChecking=no node1@$CLIENT_HOST \
                "iperf -c $SERVER_IP -p $SERVER_PORT" \
				> ./log/nic/iperf_client_${CLIENT_NODE}_to_${SERVER_NODE}.log 2>&1 &
        fi
    done
done

# 3.服务器杀进程
echo "=============================="
echo "Stopping all iperf servers"
echo "=============================="

for i in {0..3}; do
    SERVER_HOST=${HOSTS[$i]}
    SERVER_PORT=${PORTS[$i]}

    sshpass -p $PASS ssh -o StrictHostKeyChecking=no node1@$SERVER_HOST \
        "pid=\$(ss -lntp | grep :$SERVER_PORT | sed -n 's/.*pid=\\([0-9]*\\).*/\\1/p'); \
         if [ -n \"\$pid\" ]; then kill \$pid; fi"
done

