#!/bin/bash

# 移除舊執行
if [ $(ps aux | grep inotifywait | grep -v grep | wc -l) -gt 0 ];
then
    ps aux | grep inotifywait | grep -v grep | awk '{print $2}' | xargs kill  -9
fi

# 指定監看事件
inotifywait -m -e create -e delete -o /data/events-2.log /tmp
