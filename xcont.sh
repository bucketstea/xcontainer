#!/bin/bash

##################################################カレントディレクトリの初期化
SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR

##################################################除外するコンテナ名nameをlistでecho
isFile=".xcontignore";

if [ -e $isFile ]; then
    xcntlist=`cat .xcontignore`;
    cat .xcontignore | sed 's/ //g' | sed '/^$/d' > /tmp/ignorelist;
    xcntlistnull=/tmp/ignorelist;
    if [ -s $xcntlistnull ]; then
        echo -e $xcntlist "\nare Excluded\n"
        rm /tmp/ignorelist;
    fi
fi

##################################################rm対象になるコンテナを絞り込む
function cntList() {
    mkdir /tmp/xcont.d 2> /dev/null;
    docker ps -a|awk '{print $NF}'|tail -n +2 > /tmp/xcont.d/xcontall.txt; 
    sort /tmp/xcont.d/xcontall.txt|cat > /tmp/xcont.d/sortedxcontall.txt;
    sed '/^$/d' .xcontignore > /tmp/xcont.d/xcontignore.txt 2>&1;
    sort /tmp/xcont.d/xcontignore.txt|cat > /tmp/xcont.d/sortedxcontignore.txt;
    comm -23 /tmp/xcont.d/sortedxcontall.txt /tmp/xcont.d/sortedxcontignore.txt;
    rm -rf /tmp/xcont.d 2> /dev/null;
}

newcnt=`cntList`

##################################################コンテナの停止・削除処理(停止・削除できた場合はその旨echo)
docker stop `echo $newcnt` 2> /dev/null
if [ $? -eq 0 ]; then
    echo -e "are Stoped\n"
else
    echo -e "There are no stoppable containers\n"
fi

docker rm `echo $newcnt` 2> /dev/null
if [ $? -eq 0 ]; then
	echo -e "are Removed\n"
else
    echo -e "There are no deletable containers\n"
fi

##################################################最新のコンテナ稼働状況を表示
docker ps -a --format "table {{.ID}} {{.Names}} {{.Status}}" | sed -e "s/CONTAINER.ID/CONTAINER_ID/g"
echo -e "are Current Container\n"

