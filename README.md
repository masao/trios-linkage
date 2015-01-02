trios-linkage
=============

以下の要領で書誌同定を行う：

1. データベースダンプ (pg_dump）
2. データベースSQL（pg_restore）
3. タブ区切りテキスト（書誌データ; ares-import.rb）
4. データベースファイル（ares-import.rb）
5. 同定候補リスト（ext-candidate.rb）

ares_20131008.pg_dump -> (ares-import.rb) -> ares_article.txt -> (ares-import.rb) -> ares_article.db

ares_article.db + cinii2011.txt -> (ext-candidate.rb) -> ...

