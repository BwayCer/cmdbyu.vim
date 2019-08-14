#!/bin/bash
# cmdByU.vim 執行腳本

# # 參數說明：
# #   * 方法
# #     * syntax   觸發格式化和提示訊息功能。
# #     * run      運行該文件或專案。
# #     * dev      開發模式下運行該文件或專案。
# [[USAGE]] <方法 (syntax|run|dev)>
#           <文件路徑> <文件副檔名> <專案目錄路徑> <執行文件目錄路徑>
#           <使用容器資訊 (inDocker|unDocker)>


##shStyle 共享變數


method="$1"
filePath="$2"
fileExt="$3"
projectDir="$4"
vimcodeDir="$5"
useDockerMsg="$6"

# 約定通訊文件
chanBufferContentPath="$vimcodeDir/chanBufferContent.cmdbyu.tmp"
chanFormatCodePath="$vimcodeDir/chanFormat.cmdbyu.tmp"
chanSyntaxInfoPath="$vimcodeDir/chanSyntax.cmdbyu.tmp"


##shStyle 介面函式


fnMain() {
    case "$method" in
        syntax )
            printf "stamp: %s\n\nHI %s\n" \
                "`date -u +"%Y-%m-%dT%H:%M:%S.%9NZ"`" \
                "`whoami`" \
                > "$chanFormatCodePath"

            printf "$filePath:%s\n" \
                "1:11::พิคาชูเป็นสายพันธุ์ของโปเกมอน" \
                "3:13:W:woring: Пикачу считается одним из самых узнаваемых и популярных покемонов" \
                "5:15:E:Ունի զարգացման երեք ձև։ Առաջինը Պիչուն է, իսկ երրորդ ձևը Ռաիչուն։" \
                > "$chanSyntaxInfoPath"
            ;;
        run )
            fnMain_carryArgs "$@"
            ;;
        dev )
            fnMain_carryArgs "$@"
            exit 1
            ;;
        * )
            echo "找不到 \"$method\" 方法。"
            exit 1
            ;;
    esac
}
fnMain_carryArgs() {
    printf "PWD: %s\nfile: %s\n" "$PWD" "`realpath "$0"`"
    printf "CmdByU: (%s)" "$#"
    printf " %s," "$@"
    echo " nil"
    printf "method: %s\nfPat: %s\nfExt: %s\npjDir: %s\nvcDir: %s\nuseDockerMsg: %s\n" \
        "$1" "$2" "$3" "$4" "$5" "$6"
}


##shStyle ###


fnMain "$@"

