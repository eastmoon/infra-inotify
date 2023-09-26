#!/bin/bash

# Declare variable
file=/tmp/output.0

# 建立或修改檔案
echo `date` | tee -a ${file}

# 取得檔案或目錄儲存資訊
stat ${file}

# 計算資訊
echo "-------"
inum=$(stat -c "%i" ${file})
imtime=$(stat -c "%X %Y" ${file})
[ ${imtime% *} -eq ${imtime#* } ] && echo "CREATE ${file} (${inum})" || echo "MODIFY ${file} (${inum})"
