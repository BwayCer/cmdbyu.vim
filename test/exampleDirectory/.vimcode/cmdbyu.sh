#!/bin/bash
# cmdByU.vim 執行腳本

# # 參數說明：
# #   * 方法
# #     * syntax         觸發格式化和提示訊息功能。
# #     * syntaxRun      運行該文件或專案。
# #     * syntaxDev      開發模式下運行該文件或專案。
# #     * syntaxGrep     查找使用字詞最多的單字。
# #     * syntaxSimple   最簡單的 Quickfix 使用方式。你做得到嗎？
# #     * hello          運行該文件或專案。
# [[USAGE]] <方法 (syntax|syntaxRun|syntaxDev|syntaxGrep|syntaxSimple|hello)>
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
    local googleTrendsUrl="https://trends.google.com.tw/trends/trendingsearches/daily/rss?geo=TW"
    curl -s "$googleTrendsUrl" > "$chanFormatCodePath"

    cat "$chanFormatCodePath" |
        grep -sn "<title>.*</title>" |
        fnQuickfixGrepProcess "$filePath" "title" |
        sed -e "s/[^:]*<title>\(.*\)<\/title>.*/\1/" \
        > "$chanSyntaxInfoPath"
}
fnMain_syntaxRun() {
    fnCarryArgs "$@"
}
fnMain_syntaxDev() {
    fnCarryArgs "$@"
    exit 1
}
fnMain_syntaxGrep() {
    local keyword=`
        sed "s/\W/\n/g" "$chanBufferContentPath" |
            grep "..." | sort | uniq -c | sort -rn | head -n 1 |
            sed -e "s/^ *[0-9]* \(.*\)/\1/"
    `
    echo "使用最多的字詞是 \"$keyword\""
    cat "$chanBufferContentPath" |
        fnQuickfixGrep "$filePath" "$keyword" \
        > "$chanSyntaxInfoPath"
}
fnMain_syntaxSimple() {
    local randIndex=`awk -F "" '{print $1":"($2$3)%88+1}' <<< "$RANDOM"`
    printf "$filePath:%s\n" \
        "$randIndex::不看立場，只論是非，改變總在跳脫舒適圈之後" \
        "3:13:W:生活融於政治，言行落實律法" \
        "5:15:E:信仰雖有價值，但是沒人買得起" \
        > "$chanSyntaxInfoPath"
}
fnMain_hello() {
    echo hello
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

# 顯示 Quickfix 規範的格式
fnQuickfixGrep() {
    _stdin=`[ ! -t 0 ] && while read pipeData; do echo "$pipeData"; done <&0`

    local fileName="$1"
    local keyword="$2"
    local content="$3"

    if [ -z "$content" ] && [ -n "$_stdin" ]; then
        content="$_stdin"
    else
        return 1
    fi

    grep -sn "$keyword" <<< "$content" |
        fnQuickfixGrepProcess "$fileName" "$keyword"
}
# Quickfix 的 Grep 資料加工
fnQuickfixGrepProcess() {
    _stdin=`[ ! -t 0 ] && while read pipeData; do echo "$pipeData"; done <&0`

    local fileName="$1"
    local keyword="$2"
    local grepResult="$3"

    if [ -z "$grepResult" ] && [ -n "$_stdin" ]; then
        grepResult="$_stdin"
    else
        return 1
    fi

    local awkExpr="{tPrefix=\"$fileName:\"\$1; tKW=\"$keyword\"}"
    local awkExpr+='$1="";'
    local awkExpr+="{tn=substr(\$0,2)}"
    local awkExpr+='{print tPrefix ":" index(tn,tKW) "::" tn}'

    awk -F ':' "$awkExpr" <<< "$grepResult"
}


##shStyle ###


fnMain "$@"

