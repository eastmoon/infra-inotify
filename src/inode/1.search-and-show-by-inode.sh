#!/bin/bash

# Declare variable
dir=/tmp/out.1d
file=${dir}/output.1

# Declare function
function checkm() {
    t=${1}
    inum=$(stat -c "%i" ${t})
    imtime=$(stat -c "%X %Y" ${t})
    [ ${imtime% *} -eq ${imtime#* } ] && echo "CREATE ${t} (${inum})" || echo "MODIFY ${t} (${inum})"
}

# 建立或修改檔案
[ ! -d ${dir} ] && mkdir ${dir}
echo `date` | tee -a ${file}

# 取得檔案或目錄儲存資訊
echo "===== Directory stat ====="
stat ${dir}
echo "===== File stat ====="
stat ${file}

# 計算資訊
echo "-------"
checkm ${dir}
checkm ${file}
