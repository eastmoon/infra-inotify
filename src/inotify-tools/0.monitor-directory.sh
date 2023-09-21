#!/bin/bash

# 移除舊執行
if [ $(ps aux | grep inotifywait | grep -v grep | wc -l) -gt 0 ];
then
    ps aux | grep inotifywait | grep -v grep | awk '{print $2}' | xargs kill  -9
fi

# 監看記錄
inotifywait -m /tmp
