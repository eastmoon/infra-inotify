#!/bin/bash

# 移除舊執行
if [ $(ps aux | grep inotifywait | grep -v grep | wc -l) -gt 0 ];
then
    ps aux | grep inotifywait | grep -v grep | awk '{print $2}' | xargs kill  -9
fi

# 顯示自訂格式的監看記錄
inotifywait -m --format "%:e %f" -o /data/events-1.log /tmp
