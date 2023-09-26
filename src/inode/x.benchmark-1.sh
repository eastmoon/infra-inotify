#!/bin/bash

# 在目錄內容不斷增長對搜尋單一目標、隨機目標是否有影響
# 考量多次檢測，並計算均值

# Declare variable
log=/data/benchmark.1
dir=/tmp/out.1d

# Declare function
function step() {
    ## 宣告變數
    LOOP_STEP=${1}
    LOOP_COUNT=${2}
    LOOP_MAX=$((${LOOP_STEP} + 1))
    LOOP_MAX=$((${LOOP_MAX}* ${LOOP_COUNT}))
    ASSERT_LOOP=5
    ASSERT_MAX=100

    ## 每個階段分為兩步，建立檔案與隨機檢索，以此計算在檔案逐次增加後搜尋指定次數下的所需時間變化
    echo "STEP $(printf "%0*d" 3 ${LOOP_STEP})"
    ## 產生檔案
    for val in $(seq 1 ${LOOP_COUNT}); do
        NUM=$((${LOOP_STEP} * ${LOOP_COUNT} + ${val}))
        echo ${NUM} > ${dir}/out.$(printf "%0*d" 5 ${NUM})
    done

    ## 進行隨機搜尋
    ### 檢測多次，以此抓取平均值
    tt=0
    for al in $(seq 1 ${ASSERT_LOOP}); do
        rt=$(assert)
        tt=$((tt + rt))
        echo ">> STEP $(printf "%0*d" 3 ${LOOP_STEP}) - ${al} Diff ${rt}"
    done
    tt=$((tt / ${ASSERT_LOOP}))
    ### 計算平均時間差
    echo "> Avg.Diff ${tt}"
    echo "${LOOP_STEP}, ${LOOP_MAX}, ${ASSERT_MAX}, ${ASSERT_LOOP}, ${tt}" >> ${log}
}

function assert() {
    ### 初始輸出記錄檔
    [ -e ${log}.tmp ] && rm ${log}.tmp
    touch ${log}.tmp

    ### 取得起始時間
    TSTART=`date +%s%N`
    ### 進行隨機搜尋，以此計算在搜尋指定次數下的所需時間變化
    for am in $(seq 1 ${ASSERT_MAX}); do
      TNUM=$((RANDOM % ${LOOP_MAX}))
      TNUM=$((TNUM + 1))
      find ${dir} -maxdepth 1 -type f -iname "*$(printf "%0*d" 5 ${TNUM})" >> ${log}.tmp
    done
    ### 取得結束時間
    TEND=`date +%s%N`

    ### 輸出資訊
    echo $((${TEND} - ${TSTART}))
}

# Execute script
## 建立或修改檔案
[ -d ${dir} ] && rm -rf ${dir}
mkdir ${dir}

## 取得檔案或目錄儲存資訊
echo "===== Directory stat ====="
stat ${dir}

echo "-----"
[ -e ${log} ] && rm ${log}
for s in $(seq 0 100); do
    step ${s} 100
done
