
fnMain_syntax() {
    case "$fileExt" in
        js | vue )
            cd "$projectDir"

            local sameExtFilePath="$filePath.cmdbyu.$fileExt"
            cat "$chanBufferContentPath" > "$sameExtFilePath"

            local regexTxt="^.*: line \([0-9]\+\), col \([0-9]\+\), \(E\|W\)\(rror\|arning\) - \(.\+\)"
            npx eslint --fix --format "compact" "$sameExtFilePath" |
                grep "$regexTxt" |
                sed "s/$regexTxt/\1:\2:\3:\5/" |
                awk "{tFN=\"$filePath\"}"'{print tFN":"$0}' \
                1> "$chanSyntaxInfoPath"

            mv "$sameExtFilePath" "$chanFormatCodePath"
            ;;
        * )
            echo "\"$method\" 方法無法處理 \"$fileExt\" 副檔名。"
            exit 1
            ;;
    esac
}

