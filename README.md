trios-linkage
=============

以下の要領で書誌同定を行う：

# データベースダンプ (pg_dump）
# データベースSQL（pg_restore）
# タブ区切りテキスト（書誌データ; ares-import.rb）
# データベースファイル（ares-import.rb）
# 同定候補リスト（ext-candidate.rb）

ares_20131008.pg_dump -> (ares-import.rb) -> ares_article.txt -> (ares-import.rb) -> ares_article.db

ares_article.db + cinii2011.txt -> (ext-candidate.rb) -> ...

