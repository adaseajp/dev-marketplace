# UTF-8 BOM付きで保存すること
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Import-Module PnP.PowerShell

# stdinからJSONを読み取る
INPUT=$args[0]

# jqでfile_pathを抽出（jqがない場合はgrepで代替）
#if command -v jq &> /dev/null; then
if (-not (command)) {
    #FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
}else{
    # jqがない場合の簡易的な抽出
    #FILE_PATH=$(echo "$INPUT" | grep -o '"file_path":"[^"]*"' | cut -d'"' -f4)
}

# マイグレーションファイルかどうかチェック
#if echo "$FILE_PATH" | grep -q "migrations/.*\.sql"; then
if (-not (Test-Path $FILE_PATH)) {
    Write-Error "⚠️  データベースマイグレーション実行前の確認:" 
    Write-Error "  - ロールバック手順は準備済みですか？" 
    Write-Error "  - バックアップは取得しましたか？" 
    Write-Error "  - 影響範囲を確認しましたか？" 
    exit 1
}

# マイグレーションファイルでない場合は静かに通過
exit 0
