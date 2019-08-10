#!/bin/bash
# 淨空溝通環境


for tmpTargetPath in "$@"
do
    [ ! -e "$tmpTargetPath" ] || rm -rf "$tmpTargetPath"
done

