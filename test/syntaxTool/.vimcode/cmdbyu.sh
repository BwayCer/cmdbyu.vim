#!/bin/bash
# cmdByU.vim 執行腳本

# # 參數說明：
# #   * 方法
# #     * syntax         觸發格式化和提示訊息功能。
# [[USAGE]] <方法 (syntax)>
#           <文件路徑> <文件副檔名> <專案目錄路徑> <執行文件目錄路徑>
#           <使用容器資訊 (inDocker|unDocker)>


##shStyle 共享變數


method="$1"
filePath="$2"
fileExt="$3"
projectDir="$4"
vimcodeDir="$5"
useDockerMsg="$6"

# 溝通用文件
chanBufferContentPath="$vimcodeDir/chanBufferContent.cmdbyu.tmp"
chanFormatCodePath="$vimcodeDir/chanFormat.cmdbyu.tmp"
chanSyntaxInfoPath="$vimcodeDir/chanSyntax.cmdbyu.tmp"


##shStyle 介面函式


fnMain() {
    case "$method" in
        syntax )
            local timerStart_idCmdbyu=`date -u +"%M%S%3N"`
            fnMain_syntax
            local timerEnd_idCmdbyu=`date -u +"%M%S%3N" | grep -o "[1-9][0-9]*"`
            local timerStart_idCmdbyu=`grep -o "[1-9][0-9]*" <<< "$timerStart_idCmdbyu"`
            echo "運行耗時： $(($timerEnd_idCmdbyu - $timerStart_idCmdbyu)) ms"
            ;;
        * )
            echo "找不到 \"$method\" 方法。"
            exit 1
            ;;
    esac
}


##shStyle ###



source "$projectDir/`cat "$vimcodeDir/useTool.cmdbyu.tmp"`/tool.sh"

fnMain "$@"

