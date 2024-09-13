#!/bin/bash

max_gas_fee=3000
while true; do
    response=$(curl -s https://mempool.fractalbitcoin.io/api/v1/fees/recommended)
    fastestFee=$(echo $response | jq '.fastestFee') 
    echo $fastestFee

    # 如果没有获取到 fastestFee，默认给 1700
    if [ -z "$fastestFee" ] || [ "$fastestFee" == "null" ]; then
        fastestFee=1700
    fi

    echo $fastestFee
    if (( $(echo "$fastestFee <= $max_gas_fee" | bc -l) )); then
        command="yarn cli mint -i 45ee725c2c5993b3e4d308842d87e973bf1951f5f7a804b21e4dd964ecd12d6b_0 5 --fee-rate $fastestFee"
        $command

        if [ $? -ne 0 ]; then
            echo "命令执行失败，退出循环"
            exit 1
        fi
    else
        echo "fastestFee 超过 $max_gas_fee，忽略执行 command"
    fi

    sleep 10
done