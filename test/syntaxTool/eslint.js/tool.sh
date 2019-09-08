
fnMain_syntax() {
    case "$fileExt" in
        js | vue )
            local tmpRtnCode regexTxt

            cat "$chanBufferContentPath" > "$sameFilePath"

            # 命令執行
            npx eslint --fix --format "compact" "$sameFilePath" |
                tee "$stdoutTmpPath"
            tmpRtnCode=${PIPESTATUS[0]}

            # 命令處理
            regexTxt+="^.*: line \([0-9]\+\), col \([0-9]\+\),"
            regexTxt+=" \(E\|W\)\(rror\|arning\) - \(.\+\)"
            if [ $tmpRtnCode -eq 0 ]; then
                mv "$sameFilePath" "$chanFormatCodePath"

                cat "$stdoutTmpPath" |
                    grep "$regexTxt" |
                    sed "s/$regexTxt/\1:\2:\3:\5/" |
                    awk "{print \"$filePath:\"\$0}" \
                    > "$chanSyntaxInfoPath"
            fi
            ;;
        * ) return 1 ;;
    esac
}

