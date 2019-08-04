命令由你
=======


> 授權： [CC-BY-4.0](./LICENSE.md)

> 版本： v1.0.0

讓 Vim 可依目錄區分來簡易設定所欲執行的命令。



## 使用方式


**命令：**

```
:CmdByURun     <method> [global|path/to/run.sh]   " 以容器執行
:CmdByUHostRun <method> [global|path/to/run.sh]   " 以主機執行
```

建議使用容器來運行命令以策安全，
該容器為 "local/vimcmdbyu:latest" 名稱的 docker 映像文件。

若欲調整運行容器命令的選項可透過以下方式：

```
let g:cmdbyu_dockerCarryOption = '--network host'
```

關於方法名稱可自由取名，唯獨用以下二者為前綴時較為特殊：

  * `format`: 將標準輸出覆寫到文件上。
  * `syntax`: 將標準輸出顯示於 quickfix-window 窗格。


**執行文件：**

關於執行文件可參考
[`./test/exampleDirectory/.vimcode/cmdbyu.sh`](./test/exampleDirectory/.vimcode/cmdbyu.sh)
文件。

關於命令中第二項參數可指定執行文件，
其中 `global` 表示全域的執行文件，
可透過以下方式設定：

```
let g:cmdbyu_globalShFilePath = '~/.vimcode/cmdbyu.sh'
```

