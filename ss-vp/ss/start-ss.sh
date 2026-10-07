#!/bin/bash

# 定义程序名称或启动命令关键字
APP_NAME="shadowsocks2-linux"

# 1. 检查程序是否存在
# 使用 pgrep 获取进程 PID，-x 表示精确匹配程序名
PID=$(pgrep -f "$APP_NAME")

# 2. 如果存在，则停止并删除（kill）
if [ -n "$PID" ]; then
    echo "检测到 $APP_NAME 正在运行 (PID: $PID)，正在停止..."
    # 发送 SIGTERM 信号优雅停止
    kill "$PID" 
    
    # 等待进程完全退出，最多等待 5 秒
    WAIT_TIME=0
    while [ $WAIT_TIME -lt 5 ]; do
        if ! kill -0 "$PID" 2>/dev/null; then
            echo "程序已安全停止。"
            break
        fi
        sleep 1
        ((WAIT_TIME++))
    done
    
    # 如果 5 秒后仍未退出，强制杀死
    if kill -0 "$PID" 2>/dev/null; then
        echo "程序未响应，正在强制终止..."
        kill -9 "$PID"
    fi
else
    echo "$APP_NAME 未在运行，准备直接启动。"
fi

# 3. 重新启动程序
# 注意：建议加上 nohup 和 & 让程序在后台运行，并将日志输出到文件
echo "正在启动 $APP_NAME..."
nohup /opt/shadowsocks2-linux -s 'ss://AEAD_CHACHA20_POLY1305:7966c347-b5f5-46a0-b720-ef2d76e1836a@:38488' -verbose > /opt/ss.log 2>&1 &

# 4. 验证启动结果
sleep 2
NEW_PID=$(pgrep -f "$APP_NAME")
if [ -n "$NEW_PID" ]; then
    echo "$APP_NAME 启动成功，新的 PID 为: $NEW_PID"
else
    echo "$APP_NAME 启动失败，请检查日志！"
    exit 1
fi
