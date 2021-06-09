## xcont

You can leave only the containers you need, you can delete all other unnecessary containers. <br>
必要なコンテナのみ残し、それ以外のコンテナをすべて削除するシェルスクリプトです。

#### How to use

- Specify the names of the containers you do not want to delete in .xcontignore, separated by line break.
  - e.g. `$ echo "buckets_container" >> .xcontignore`
- When xcont.sh runs, it reads .xcontignore in the same directory as the script file and excludes its containers from deletion.

- 削除したくないコンテナのContainer Nameを.xcontignoreに改行区切りで記入します。
  - __例：__
  - `$ echo "buckets_container" >> .xcontignore`

- xcont.shは走るときにスクリプトファイルと同じディレクトリにある.xcontignoreを読み込み、削除対象から除外します。

__例:__

```bash
$ docker run -itd --name buckets_container alpine

Unable to find image 'alpine:latest' locally
latest: Pulling from library/alpine
540db60ca938: Pull complete 
Digest: sha256:69e70a79f2d41ab5d637de98c1e0b055206ba40a8145e7bddb55ccc04e13cf8f
Status: Downloaded newer image for alpine:latest
6a28f32c2b13f1d3bcff3bf4e796007322c3f5038d1af0c074b9f9f4d90667d3

$ docker run -itd --name foo alpine

15db6abd323d0daf76b408976043d45cf9f09f4b760be191ae78f07715d00092

$ docker run -itd --name hoge alpine

87fkdsaljob9809fdsa860860adsf7fdadfsa89860575656d9b9da89fda8769d

$ docker ps -a --format "table {{.ID}} {{.Names}}"

CONTAINER ID   NAMES
6a28f32c2b13   buckets_container
15db6abd323d   foo   
87fkdsaljob9   hoge

$ echo "buckets_container" >> .xcontignore
$ cat .xcontignore

buckets_container

$ xcont.sh

buckets_container 
are Excluded

foo
hoge
are Stoped

foo
hoge
are Removed

CONTAINER_ID NAMES STATUS
6a28f32c2b13 buckets_container Up 4 minutes
are Current Container

$ docker ps -a --format "table {{.ID}} {{.Names}}"

CONTAINER ID   NAMES
6a28f32c2b13   buckets_container
```
