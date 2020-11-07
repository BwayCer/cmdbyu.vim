#!/bin/bash
# cmdByU.vim 執行腳本

# # 參數說明：
# #   * 方法
# #     * syntax      觸發格式化和提示訊息功能。
# #     * syntaxRun   運行該文件或專案。
# #     * syntaxDev   開發模式下運行該文件或專案。
# [[USAGE]] <方法 (syntax|syntaxRun|syntaxDev)>
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

# 暫存文件空間
sameFilePath="$filePath.cmdbyu.$fileExt"
stdoutTmpPath="$filePath.stdout.cmdbyu.tmp"


##shStyle 介面函式


fnMain() {
    local execFnName="fnMain_$method"
    if type "$execFnName" &> /dev/null ; then
        local tmpRtnCode
        cd "$projectDir"
        # "$execFnName"
        # "$@" 以存於共享變數中，此處只為示範使用。
        "$execFnName" "$@"
        tmpRtnCode=$?

        # 復原環境
        [ ! -f "$sameFilePath"  ] || rm "$sameFilePath"
        [ ! -f "$stdoutTmpPath" ] || rm "$stdoutTmpPath"

        if [ $tmpRtnCode -ne 0 ]; then
            echo "\"$method\" 方法無法處理 \"$fileExt\" 副檔名。"
            exit 1
        fi
    else
        echo "找不到 \"$method\" 方法。"
        exit 1
    fi
}
fnMain_syntax() {
    printf "stamp: %s\n\nHI %s\n" \
        "`date -u +"%Y-%m-%dT%H:%M:%S.%9NZ"`" \
        "`whoami`" \
        > "$chanFormatCodePath"

    printf "$filePath:%s\n" \
        "1:11::พิคาชูเป็นสายพันธุ์ของโปเกมอน" \
        "3:13:W:woring: Пикачу считается одним из самых узнаваемых и популярных покемонов" \
        "5:15:E:Ունի զարգացման երեք ձև։ Առաջինը Պիչուն է, իսկ երրորդ ձևը Ռաիչուն։" \
        > "$chanSyntaxInfoPath"
}
fnMain_syntaxRun() {
    fnCarryArgs "$@"
}
fnMain_syntaxDev() {
    fnCarryArgs "$@"
    exit 1
}


##shStyle 函式庫


fnCarryArgs() {
    printf "PWD: %s\nfile: %s\n" "$PWD" "`realpath "$0"`"
    printf "CmdByU: (%s)" "$#"
    printf " %s," "$@"
    echo " nil"
    printf "method: %s\nfPat: %s\nfExt: %s\npjDir: %s\nvcDir: %s\nuseDockerMsg: %s\n" \
        "$1" "$2" "$3" "$4" "$5" "$6"
}


##shStyle ###


fnMain "$@"

