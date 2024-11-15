# perf-tool

## Make and Install

perfは対象となるJetsonと同じカーネルバージョンである必要があり、perf scriptなどのためにpython等とリンクするためには実際に使うJetson上でビルドをするのが早いです。
対象のJetsonにリポジトリをクローンしてビルド、インストールをしたらバイナリとスクリプトが`/opt/perf`以下に配置されます

```sh
# build deb package
make -C perf-tool deb

# install
sudo dpkg -i ./deb/linux-perf-jetson_*.deb
```

## How to use

```sh
# イベントにアクセスするために権限付与
sudo sysctl kernel.perf_event_paranoid=0

# record
/opt/perf/perf record -a --call-graph dwarf -F 99 <application command>

# export Flamegraph(stacks.json) from perf.data
/opt/perf/perf script report flamegraph -f json
```

`index.html`と`stacks.json`を同じディレクトリに配置してブラウザを開くとflamegraphを見ることができます。
