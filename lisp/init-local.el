;;; for korean keyboard (prevents "<C-kanji> is undefined" error when C-SPC)
;;; TODO: Windows에서만 동작하게 변경
(global-set-key [C-kanji] 'set-mark-command)

(provide 'init-local)
