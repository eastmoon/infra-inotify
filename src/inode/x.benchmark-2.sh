#!/bin/bash

# 在單一檔案內容不斷增長對搜尋固定行數、尾端內容是否有效率影響

# Declare variable
log=/data/benchmark.2
file=/tmp/out.2

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
        echo $(printf "%0*d" 10 ${NUM}), `date +%s%N` >> ${file}
    done

    ## 進行隨機搜尋
    ### 檢測多次，以此抓取平均值
    tt=0
    for al in $(seq 1 ${ASSERT_LOOP}); do
        rt=$(assert-sed)
        tt=$((tt + rt))
        echo ">> STEP $(printf "%0*d" 3 ${LOOP_STEP}) C1 - ${al} Diff ${rt}"
    done
    t1t=$((tt / ${ASSERT_LOOP}))
    ### 檢測多次，以此抓取平均值
    tt=0
    for al in $(seq 1 ${ASSERT_LOOP}); do
        rt=$(assert-tail)
        tt=$((tt + rt))
        echo ">> STEP $(printf "%0*d" 3 ${LOOP_STEP}) C2 - ${al} Diff ${rt}"
    done
    t2t=$((tt / ${ASSERT_LOOP}))
    ### 計算平均時間差
    echo "> Sed Avg.Diff ${t1t}, Tail Avg.Diff ${t2t}"
    echo "${LOOP_STEP}, ${LOOP_MAX}, ${ASSERT_MAX}, ${ASSERT_LOOP}, ${t1t}, ${t2t}" >> ${log}
}

function assert-sed() {
    ### 初始輸出記錄檔
    [ -e ${log}.tmp ] && rm ${log}.tmp
    touch ${log}.tmp

    ### 取得起始時間
    TSTART=`date +%s%N`
    ### 進行隨機搜尋，以此計算在搜尋指定次數下的所需時間變化
    for am in $(seq 1 ${ASSERT_MAX}); do
      TNUM=$((RANDOM % ${LOOP_MAX}))
      TNUM=$((TNUM + 1))
      TNUM_S=${TNUM}
      TNUM_E=$((TNUM + 20))
      find ${dir} -maxdepth 1 -type f -iname "*$(printf "%0*d" 5 ${TNUM})" >> ${log}.tmp
      sed -n "${TNUM_S},${TNUM_E}p" ${file} | wc -l >> ${log}.tmp
    done
    ### 取得結束時間
    TEND=`date +%s%N`

    ### 輸出資訊
    echo $((${TEND} - ${TSTART}))
}

function assert-tail() {
    ### 初始輸出記錄檔
    [ -e ${log}.tmp ] && rm ${log}.tmp
    touch ${log}.tmp

    ### 取得起始時間
    TSTART=`date +%s%N`
    ### 進行隨機搜尋，以此計算在搜尋指定次數下的所需時間變化
    for am in $(seq 1 ${ASSERT_MAX}); do
      TNUM=$((RANDOM % 50))
      TNUM=$((TNUM + 1))
      tail -n ${TNUM} ${file} | wc -l >> ${log}.tmp
    done
    ### 取得結束時間
    TEND=`date +%s%N`

    ### 輸出資訊
    echo $((${TEND} - ${TSTART}))
}

# Execute script
# 建立或修改檔案
[ -e ${file} ] && rm ${file}
touch ${file}

# 取得檔案或目錄儲存資訊
echo "===== Directory stat ====="
stat ${file}

echo "-----"
[ -e ${log} ] && rm ${log}
for s in $(seq 0 100); do
    step ${s} 100
done

## Draw benchmark
python x.benchmark-2-line-chart.py
