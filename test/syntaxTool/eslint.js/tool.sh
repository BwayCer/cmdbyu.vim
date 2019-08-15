
fnMain_syntax() {
    case "$fileExt" in
        .js | .vue )
            # 如果 cd "$projectDir" 會出現以下錯誤
            # warning  File ignored because of a matching ignore pattern.
            # Use "--no-ignore" to override
            cd "$projectDir/eslint.js"

            local sameExtFilePath="$filePath.cmdbyu$fileExt"
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

