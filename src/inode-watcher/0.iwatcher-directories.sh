#!/bin/bash

# 宣告目標
WATCHER_T=/data

# 移除舊執行
if [ $(ps aux | grep "iwatcher.sh ${WATCHER_T}" | grep -v grep | wc -l) -gt 0 ];
then
    ps aux | grep "iwatcher.sh ${WATCHER_T}" | grep -v grep | awk '{print $1}' | xargs kill  -9
fi

# 監看記錄
bash iwatcher.sh ${WATCHER_T} &
