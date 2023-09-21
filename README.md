# infra-inotify
Tutorial and learning report with infrastructure and usage with inotify base open source software.

## inotify-tools

使用 linux 工具監控目錄、檔案變動，但若使用 Docker 掛載的目錄若從目錄外產生新增、修改、刪除並不會讓此工具觸發事件。

相關腳本參考 [src/inotify-tools](./src/inotify-tools)，測試方式分為兩部：

+ 啟用監看
```
bash 0.monitor-directory.sh &
```
> 使用 ```&``` 讓此執行推入背景運作

+ 執行動作
```
x-action.sh
```

## iWatch

基於 inotify-tools 的進階工具，可主動發送信件與觸發執行命令，其程式基於 Perl 語言設計。

考量其增加用途並無使用需求，暫不調查與撰寫範例。

## 文獻

+ [inotify-tools](https://github.com/inotify-tools/inotify-tools)
    - [Bash 程式設計教學與範例：inotify-tools 監控檔案變動、觸發處理動作](https://officeguide.cc/bash-tutorial-inotify-tools-file-system-monitoring/)
+ [iWatch](https://iwatch.sourceforge.net/index.html)
    - [iwatch - Ubuntu manuals ](https://manpages.ubuntu.com/manpages/xenial/man1/iwatch.1.html)
+ [Watchman](https://facebook.github.io/watchman/docs/install.html#installing-from-source)
    - [Watchman – A File and Directory Watching Tool for Changes](https://www.tecmint.com/watchman-monitor-file-changes-in-linux/)
    - [使用watchman命令監控Linux系統文件的變化](https://kknews.cc/zh-tw/code/e5z93j4.html)
+ [Pyinotify](https://pypi.org/project/pyinotify/)
    - [Pyinotify – Monitor Filesystem Changes in Real-Time in Linux](https://www.tecmint.com/pyinotify-monitor-filesystem-directory-changes-in-linux/)
    - [python pyinotify sample code 偵測指定路徑底下的文件變化](https://www.wongwonggoods.com/all-posts/python/python_system/python-pyinotify/)
