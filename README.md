# infra-inotify
Tutorial and learning report with infrastructure and usage with inotify base open source software.

## inode

+ 訊息提取
    - 使用 ```stat <file / directories>```
    - 使用 ```ls -il <file>```
    - 使用 ```ls -idl <directories>```

+ 讀取檔案
```
find -inum <inode-number> -exec cat {} \;
```

+ 搜尋目錄或檔案列表
```
find <root-directory> -maxdepth 1 -type f -exec ls -i {} \;
find <root-directory> -maxdepth 1 -type d -exec ls -id {} \;
```

+ benchmark
    - 在檔案數量提升下，搜尋檔案速度
    - 在檔案內容增加下，```sed -n '<start>,<end>p' filename``` 速度
    - 在檔案內容增加下，```tail -n 50``` 速度

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

+ [inode](https://zh.wikipedia.org/zh-tw/Inode)
    - [Inodes in Linux: limit, usage and helpful commands](https://www.stackscale.com/blog/inodes-linux/)
    - [How to find a file’s Inode in Linux](https://www.serverlab.ca/tutorials/linux/administration-linux/how-to-find-a-files-inode-in-linux/)
    - [Using the find -exec Command Option on Linux](https://www.tutorialspoint.com/using-the-find-exec-command-option-on-linux)
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
