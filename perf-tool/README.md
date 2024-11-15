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

### build on L4T35.4.1

Need additional install

- DWARF: `libdw-dev libdwarf-dev`
- PYTHON: `python3-dev`

and change `Makefile.config`

```diff
PYTHON_AUTO := python
PYTHON_AUTO := $(if $(call get-executable,python3),python3,$(PYTHON_AUTO))
- PYTHON_AUTO := $(if $(call get-executable,python),python,$(PYTHON_AUTO))
- PYTHON_AUTO := $(if $(call get-executable,python2),python2,$(PYTHON_AUTO))
+ # PYTHON_AUTO := $(if $(call get-executable,python),python,$(PYTHON_AUTO))
+ # PYTHON_AUTO := $(if $(call get-executable,python2),python2,$(PYTHON_AUTO))
```

```sh
sudo apt install libdw-dev libdwarf-dev python3-dev 

make -C perf-tool deb
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
