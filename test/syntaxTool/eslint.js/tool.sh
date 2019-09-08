
fnMain_syntax() {
    case "$fileExt" in
        js | vue )
            cd "$projectDir"

            # 暫存文件空間
            local sameFilePath="$filePath.cmdbyu.$fileExt"
            local stdoutTmpPath="$filePath.stdout.cmdbyu.tmp"
            cat "$chanBufferContentPath" > "$sameFilePath"

            # 命令執行
            local tmpRtnCode regexTxt
            regexTxt+="^.*: line \([0-9]\+\), col \([0-9]\+\),"
            regexTxt+=" \(E\|W\)\(rror\|arning\) - \(.\+\)"
            npx eslint --fix --format "compact" "$sameFilePath" |
                tee "$stdoutTmpPath"
            tmpRtnCode=${PIPESTATUS[0]}

            # 命令處理
            if [ $tmpRtnCode -eq 0 ]; then
                mv "$sameFilePath" "$chanFormatCodePath"

                cat "$stdoutTmpPath" |
                    grep "$regexTxt" |
                    sed "s/$regexTxt/\1:\2:\3:\5/" |
                    awk "{print \"$filePath:\"\$0}" \
                    > "$chanSyntaxInfoPath"
            fi

            # 復原環境
            [ ! -f "$sameFilePath"  ] || rm "$sameFilePath"
            [ ! -f "$stdoutTmpPath" ] || rm "$stdoutTmpPath"
            ;;
        * ) return 1 ;;
    esac
}

