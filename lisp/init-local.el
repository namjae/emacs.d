;;; init-local.el --- My custom settings
;;; Commentary:

;; ref: https://github.com/purcell/emacs.d

;;; Code:

;; (set-language-environment 'utf-8)
;; (prefer-coding-system 'utf-8-unix)
;; (set-default-coding-systems 'utf-8-unix)
;; (set-selection-coding-system 'utf-8-unix)

;; (set-input-method 'korean-hangul3f)
;; (global-set-key [C-kanji] 'set-mark-command)

;; (provide 'init-local)


;;
;; Korean settings (from: https://manime.tistory.com/entry/eshell-%EB%B0%8F-dired-%EC%97%90%EC%84%9C-%ED%95%9C%EA%B8%80%EC%9D%B4-%EC%A0%95%EC%83%81%EC%A0%81%EC%9C%BC%EB%A1%9C-%EC%B6%9C%EB%A0%A5%EB%90%98%EB%8F%84%EB%A1%9D-%EC%84%A4%EC%A0%95)
;;
(when enable-multibyte-characters
  (set-language-environment "Korean")
  ;; (setq locale-value
  ;;       (if (string= (getenv "LANG") "ko_KR.utf8") 'utf-8 'euc-kr))
  (setq locale-value 'utf-8)
  (prefer-coding-system locale-value)
  (set-default-coding-systems locale-value)

  (setq-default file-name-coding-system locale-value)
  (setq-default locale-coding-system locale-value)
  (set-terminal-coding-system locale-value)
  (set-keyboard-coding-system locale-value)
  (set-selection-coding-system locale-value))

(when (string-match "^3" (or (getenv "HANGUL_KEYBOARD_TYPE") ""))
  (setq default-korean-keyboard "3")
  (setq default-input-method "korean-hangul3f"))

(global-set-key [C-kanji] 'set-mark-command)

(provide 'init-local)
;;; init-local.el ends here
