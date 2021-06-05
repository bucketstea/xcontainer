#!/bin/bash

##################################################カレントディレクトリの初期化
SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR

##################################################除外するコンテナ名nameをlistでecho
xcntlist=`cat .xcontignore`
echo -e $xcntlist "\nare Excluded\n"

##################################################rm対象になるコンテナを絞り込む関数
function cntList() {
    docker ps -a|awk '{print $NF}'|tail -n +2 > /tmp/xcontall.txt
    sort /tmp/xcontall.txt|cat > /tmp/sortedxcontall.txt
    sed '/^$/d' .xcontignore > /tmp/xcontignore.txt
    sort /tmp/xcontignore.txt|cat > /tmp/sortedxcontignore.txt
    comm -23 /tmp/sortedxcontall.txt /tmp/sortedxcontignore.txt
}

##################################################コンテナ絞り込み関数の戻り値を代入
newcnt=`cntList`

##################################################コンテナの停止・削除処理(停止・削除できた場合はその旨echo)
docker stop `echo $newcnt`
if [ $? -eq 0 ]; then
	echo -e "are Stoped\n"
fi

docker rm `echo $newcnt`
if [ $? -eq 0 ]; then
	echo -e "are Removed\n"
fi

##################################################最新のコンテナ稼働状況を表示
docker ps -a | sed -e "s/CONTAINER.ID/CONTAINER_ID/g" | awk '{$1="";print}'
echo -e "are Current Container\n"

##################################################一時的に生成したファイルを削除
cd /tmp/ && rm `ls|grep xcont`; cd $SCRIPT_DIR

