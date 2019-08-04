#!/bin/bash
# cmdByU.vim 執行腳本

# # 參數說明：
# #   * 方法
# #     * format:   標準輸出格式化後的程式碼。
# #     * syntax:   標準輸出程式碼檢查的提示訊息。
# #     * run:      運行該文件或專案。
# #     * dev:      開發模式下運行該文件或專案。
# [[USAGE]] <方法 (format|syntax|run|dev)>


##shStyle 介面函式


fnMain() {
    local method="$1"
    local filePath="$2"
    local fileExt="$3"
    local projectDir="$4"
    local useDockerMsg="$5"

    case "$method" in
        format )
            curl -s "https://www.president.gov.tw/RSSGazette.aspx"
            ;;
        syntax )
            printf "$filePath:%s\n" \
                "1:11: 不看立場，只論是非，改變總在跳脫舒適圈之後" \
                "3:17: 生活融於政治，言行落實律法" \
                "5:21: 信仰是有價值的，而且沒人買得起"
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
    printf "in %s\n" "`realpath "$0"`"
    printf "CmdByU:"
    printf " %s," "$@"
    echo " nil"
    printf "method: %s\nfPat: %s\nfExt: %s\npDir: %s\nuseDockerMsg: %s\n" \
        "$1" "$2" "$3" "$4" "$5"
}


##shStyle ###


fnMain "$@"

