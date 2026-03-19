#!/bin/bash

# stdinからJSONを読み取る
INPUT=$(cat)

# jqでfile_pathを抽出（jqがない場合はgrepで代替）
if command -v jq &> /dev/null; then
    FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
else
    # jqがない場合の簡易的な抽出
    FILE_PATH=$(echo "$INPUT" | grep -o '"file_path":"[^"]*"' | cut -d'"' -f4)
fi

# マイグレーションファイルかどうかチェック
if echo "$FILE_PATH" | grep -q "migrations/.*\.sql"; then
    echo "⚠️  データベースマイグレーション実行前の確認:" >&2
    echo "  - ロールバック手順は準備済みですか？" >&2
    echo "  - バックアップは取得しましたか？" >&2
    echo "  - 影響範囲を確認しましたか？" >&2
    exit 1
fi

# マイグレーションファイルでない場合は静かに通過
exit 0