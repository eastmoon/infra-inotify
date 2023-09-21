#!/bin/bash

# 移除舊執行
if [ $(ps aux | grep inotifywait | grep -v grep | wc -l) -gt 0 ];
then
    ps aux | grep inotifywait | grep -v grep | awk '{print $2}' | xargs kill  -9
fi

# 指定監看事件並處理
inotifywait -m -e create -e delete -s /tmp | while read dir action file
do
    echo "$dir 目錄透過 $action 方式新增檔案 $file" >> /data/event-3-p.log
done
