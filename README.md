# infra-inotify
Tutorial and learning report with infrastructure and usage with inotify base open source software.

## inode

inode 是 Linux 對檔案系統的資訊管理機制，其設計概念是將檔案與目錄的主要資訊存儲在 inode，並以此搜尋實際儲存的位元區塊。

相關腳本參考 [src/inode](./src/inode)，其調查分為基礎操作與基準測試：

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

## inode-watcher

基於 inode 機制規劃並設計的監控腳本，其設計包括以下功能：

+ 監控事件為產生、更新、刪除
+ 可針對檔案與目錄
    - 檔案若被刪除，監控仍然持續，但 inode 再次產生應已經更換
    - 目錄中若有目錄則以廣度優先來原則依據處理目錄的監控
        + 單依據 inode 搜尋目錄的設計來看，當目錄中檔案越多搜尋效率越差
        + 建議若有多個目錄監控可分為多個監控執行程序處理
+ 事件處理為指令字串，每個事件僅對應一個字串
    - 字串中若有 ```{event}``` 則會套入事件名稱
    - 字串中若有 ```{}``` 則會套入變更的檔案或目錄完整路徑

## inotify-tools

使用 linux 工具監控目錄、檔案變動。

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

需注意若使用 Docker 掛載的目錄若從目錄外產生新增、修改、刪除並不會讓此工具觸發事件，相關議題參考文獻

+ [inotify does not work when mounting volumes to docker daemons running in virtual machines](https://github.com/moby/moby/issues/18246)
+ [Missing file system events on mounts](https://github.com/docker/for-mac/issues/2216)

依據討論文獻，在 Windows 或 Mac 環境會因為沒有檔案系統事件 ( filesystem event ) 而導致 inotify 無法正常運作，對此改善方案：

+ 採用讀寫目錄分離
    - 避免讀入與寫出同目錄，導致單方向複寫異常
+ 目錄定時循環同步至內部目錄，從而觸發事件
    - 容器自行同步，僅能使用 nsleep + rsync
    - 主機協助同步，可在主機使用 inotfiy + rsync

以上做法有以下缺失：

+ 需額外再主機設置監看者機制
+ 對於大檔案同步會過度消耗效率
+ 容易累積垃圾文件，需透過監看者定期清除

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
