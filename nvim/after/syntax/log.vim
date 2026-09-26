" 中文關鍵字補充 (在外掛的 syntax/log.vim 之後載入)
"
" 外掛的 keyword 設定用的是 `syn keyword`，它要求關鍵字前後是「非單字字元」。
" 但中文字全部算單字字元，所以「批次處理完成」裡的「完成」永遠不會被配到。
" 這裡改用 `syn match`，不管前後接什麼字都能上色。

syn match LogLvError    display '失敗\|錯誤\|例外\|異常\|逾時\|中斷'
syn match LogLvWarning  display '警告\|注意\|重試'
syn match LogLvInfo     display '成功\|完成\|開始\|結束'
