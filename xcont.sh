#!/bin/bash
SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR

#除外するコンテナ名name_list
xcntlist=`cat .xcontignore`
echo -e $xcntlist "\nare excluded\n"

#rm対象になるコンテナを絞り込む関数
function cntList() {
    docker ps -a|awk '{print $NF}'|tail -n +2 > /tmp/xcontall.txt
    sort /tmp/xcontall.txt|cat > /tmp/sortedxcontall.txt
    sed '/^$/d' .xcontignore > /tmp/xcontignore.txt
    sort /tmp/xcontignore.txt|cat > /tmp/sortedxcontignore.txt
    comm -23 /tmp/sortedxcontall.txt /tmp/sortedxcontignore.txt
}

newcnt=`cntList`

docker stop `echo $newcnt`
if [ $? -eq 0 ]; then
	echo -e "are Stoped\n"
fi

docker rm `echo $newcnt`
if [ $? -eq 0 ]; then
	echo -e "are Removed\n"
fi

docker ps -a | sed -e "s/CONTAINER.ID/CONTAINER_ID/g" | awk '{$1="";print}'
echo -e "are Current Container\n"

cd /tmp/ && rm `ls /tmp/xcont/|grep xcont`; cd $SCRIPT_DIR

