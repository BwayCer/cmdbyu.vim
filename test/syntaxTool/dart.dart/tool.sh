
fnMain_syntax() {
    case "$fileExt" in
        dart )
            local tmpRtnCode regexTxt

            cat "$chanBufferContentPath" > "$sameFilePath"

            # 命令執行
            dartfmt "$sameFilePath" 2>&1 | tee "$stdoutTmpPath"
            tmpRtnCode=${PIPESTATUS[0]}

            # 命令處理
            regexTxt+="^line \([0-9]\+\), column \([0-9]\+\)"
            regexTxt+=" of .\+\.cmdbyu\.$fileExt: \([A-Z].\+\)"
            if [ $tmpRtnCode -eq 0 ]; then
                mv "$stdoutTmpPath" "$chanFormatCodePath"
            else
                cat "$stdoutTmpPath" |
                    grep "$regexTxt" |
                    sed "s/$regexTxt/\1:\2::\3/" |
                    awk "{print \"$filePath:\"\$0}" \
                    > "$chanSyntaxInfoPath"
            fi
            ;;
        * ) return 1 ;;
    esac
}
fnMain_syntaxDev() {
    case "$fileExt" in
        dart )
            local tmpRtnCode regexTxt

            cat "$chanBufferContentPath" > "$sameFilePath"

            # 命令執行
            dart --enable-asserts "$sameFilePath" 2>&1 | tee "$stdoutTmpPath"
            tmpRtnCode=${PIPESTATUS[0]}

            # 命令處理
            regexTxt+="^.\+\.cmdbyu\.$fileExt:\([0-9]\+\):\([0-9]\+\):"
            regexTxt+=" \(\(E\|W\)\(rror\|arning\): \)\?\(.\+\)"
            if [ $tmpRtnCode -ne 0 ]; then
                cat "$stdoutTmpPath" |
                    grep "$regexTxt" |
                    sed "s/$regexTxt/\1:\2:\4:\6/" |
                    awk "{print \"$filePath:\"\$0}" \
                    > "$chanSyntaxInfoPath"
            fi
            ;;
        * ) return 1 ;;
    esac
}

