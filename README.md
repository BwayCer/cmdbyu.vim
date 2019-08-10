命令由你
=======


> 授權： [CC-BY-4.0](./LICENSE.md)

> 版本： v1.0.0

讓 Vim 可依目錄區分來簡易設定所欲執行的命令。



## 依賴


* [GitHub BwayCer/bway.vim/autoload/canUtils.vim](https://github.com/BwayCer/bway.vim/blob/master/autoload/canUtils.vim)



## 使用方式


**命令：**

```vim
:CmdByURun     <method> [global|path/to/runShDir]   " 以容器執行
:CmdByUHostRun <method> [global|path/to/runShDir]   " 以主機執行
```

_建議使用容器來運行命令以策安全。_

若欲調整運行容器命令的選項可透過以下方式：

```vim
" {shCmd}  : 運行命令。
" {volume} : 命令所需的掛載目錄。
let g:cmdbyu_dockerCommand
    \ = 'docker run --rm {volume}'
    \ . ' --network host local/vimcmdbyu -- {shCmd}'
```

關於方法名稱可自由取名，
唯獨以 `syntax` 為前綴時較為特殊，
其會觸發**覆寫文件**及**quickfix 窗格顯示資訊**的功能。

第二項參數可指定執行文件目錄來變更執行文件的所在路徑，
其目錄必須包含 `.vimcode/cmdbyu.sh` 文件，
其中 `global` 表示全域的執行文件目錄，
可透過以下方式設定：

```vim
" 對 Vim Script 而言，`~` 必須使用 fnamemodify('~', ':p') 取得絕對路徑
let g:cmdbyu_globalDirectory = fnamemodify('~', ':p')
```


**執行文件：**

命令預設會由當前文件路徑開始向上層目錄查找包含 `.vimcode/cmdbyu.sh` 文件的目錄，
將其視為專案目錄，
並帶入相關參數運行其文件：

```
sh <專案目錄路徑>/.vimcode/cmdbyu.sh <方法 (format|syntax|*)> \
    <當前文件路徑> <當前文件副檔名> <專案目錄路徑> \
    <使用容器資訊 (inDocker|unDocker)>
```

關於執行文件可參考
[`./test/exampleDirectory/.vimcode/cmdbyu.sh`](./test/exampleDirectory/.vimcode/cmdbyu.sh)
文件。

