#!/bin/bash
# cmdByU.vim 執行腳本

# # 參數說明：
# #   * 方法
# #     * format:   標準輸出格式化後的程式碼。
# #     * syntax:   標準輸出程式碼檢查的提示訊息。
# #     * run:      運行該文件或專案。
# #     * dev:      開發模式下運行該文件或專案。
# [[USAGE]] <方法 (format|syntax|run|dev)>
#           <文件路徑> <文件副檔名> <專案目錄路徑>
#           <使用容器資訊 (inDocker|unDocker)>


##shStyle 介面函式


fnMain() {
    local method="$1"
    local filePath="$2"
    local fileExt="$3"
    local projectDir="$4"
    local vimcodeDir="$5"
    local useDockerMsg="$6"

    case "$method" in
        format )
            curl -s "http://example.com"
            ;;
        syntax )
            printf "$filePath:%s\n" \
                "1:11: พิคาชูเป็นสายพันธุ์ของโปเกมอน" \
                "3:17: Пикачу считается одним из самых узнаваемых и популярных покемонов" \
                "5:21: Ունի զարգացման երեք ձև։ Առաջինը Պիչուն է, իսկ երրորդ ձևը Ռաիչուն։"
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

