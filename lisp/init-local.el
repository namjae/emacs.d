;;; init-local.el --- My custom settings
;;; Commentary:
;;; 환경변수
;;;   직접 참조:
;;;     - HANGUL_KEYBOARD_TYPE=(3f | 2)
;;;     - LANG=ko_KR.UTF-8
;;;   아마도 참조:
;;;     - LANGUAGE=ko:en

;; ref: https://github.com/purcell/emacs.d

;;; Code:

(setq system-time-locale "ko_kr.utf-8")

;; reading a file from: http://xahlee.info/emacs/emacs/elisp_read_file_content.html
(setq org-agenda-files
      (append (file-expand-wildcards "g:/My Drive/.org/*/*.org")
              (file-expand-wildcards "g:/내 드라이브/.org/*/*.org")
              (file-expand-wildcards "h:/My Drive/.org/*.org")
              (file-expand-wildcards "/mnt/g/내 드라이브/.org/*/*.org")
              (file-expand-wildcards "~/.org-mode/*.org")
              (file-expand-wildcards "~/Documents/journal/*.org")
              (when (file-exists-p "~/.org-agenda-files")
                (with-temp-buffer
                  (insert-file-contents "~/.org-agenda-files")
                  (split-string (buffer-string) "\n" t)))))

;; from: https://github.com/bastibe/org-journal/issues/96

;; (with-eval-after-load 'org-journal
;;   (setq org-journal-dir "~/Documents/journal/")
;;   (add-to-list 'org-agenda-files (file-expand-wildcards "~/.org-mode/*.org"))
;;   (add-to-list 'org-agenda-files (expand-file-name "~/Documents/journal/"))
;;   (setq org-journal-file-format "%Y%m%d.org")
;;   ;(org-journal-update-auto-mode-alist)
;;   (setq org-journal-date-prefix "#+TITLE: Daily Notes "))


;; ref: https://stackoverflow.com/questions/1817257/how-to-determine-operating-system-in-elisp

(setq org-journal-dir
      (pcase system-type
        ('gnu/linux "/mnt/g/내 드라이브/.org/journal")
        ('windows-nt "g:/내 드라이브/.org/journal")))

(setq org-journal-file-format "%Y%m%d.org")
(setq org-journal-date-prefix "#+TITLE: Daily Notes ")

;; from: https://emacs.stackexchange.com/questions/61819/how-can-i-bind-c-c-c-j-to-always-do-org-journal-new-entry
(global-set-key (kbd "C-c j") 'org-journal-new-entry)

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
  ;; (set-language-environment "Korean")
  (set-language-environment "UTF-8")
  (setq locale-value
        (if (string= (getenv "LANG") "ko_KR.UTF-8") 'utf-8 'euc-kr))
  ;; (setq locale-value 'utf-8)
  (prefer-coding-system locale-value)
  (set-default-coding-systems locale-value)

  (setq-default file-name-coding-system locale-value)
  (setq-default locale-coding-system locale-value)
  (set-terminal-coding-system locale-value)
  (set-keyboard-coding-system locale-value)
  (set-selection-coding-system locale-value))

;; from: https://stackoverflow.com/questions/24904208/emacs-windows-org-mode-encoding
(modify-coding-system-alist 'file "" 'utf-8-unix)

;; for pasted text (on windows)
;; from: https://rufflewind.com/2014-07-20/pasting-unicode-in-emacs-on-windows
;;(set-selection-coding-system 'utf-16-le)
(set-selection-coding-system 'utf-8)
;; OR (from https://stackoverflow.com/questions/22647517/emacs-encoding-of-pasted-text)
;; (set-clipboard-coding-system 'utf-16le)

(when (string-match "^3" (or (getenv "HANGUL_KEYBOARD_TYPE") ""))
  (setq default-korean-keyboard "3")
  (setq default-input-method "korean-hangul3f"))

(when (eq 'w32 window-system)
  (global-set-key [C-kanji] 'set-mark-command))


;; (setq-default left-margin-width 1 right-margin-width 1) ; Define new widths.
;; (set-window-buffer nil (current-buffer)) ; Use them now.

;; high light current line
(global-hl-line-mode 1)

;; Start of "week number on calendar"
;; from: https://www.emacswiki.org/emacs/CalendarWeekNumbers
(copy-face font-lock-constant-face 'calendar-iso-week-face)
(set-face-attribute 'calendar-iso-week-face nil
                    :height 0.7)
(setq calendar-intermonth-text
      '(propertize
        (format "%2d"
                (car
                 (calendar-iso-from-absolute
                  (calendar-absolute-from-gregorian (list month day year)))))
        'font-lock-face 'calendar-iso-week-face))

(copy-face 'default 'calendar-iso-week-header-face)
(set-face-attribute 'calendar-iso-week-header-face nil
                    :height 0.7)
(setq calendar-intermonth-header
      (propertize "주"                  ; or e.g. "KW" in Germany
                  'font-lock-face 'calendar-iso-week-header-face))

(set-face-attribute 'calendar-iso-week-face nil
                    :height 1.0 :foreground "salmon" :underline t)
;; End of "week number on calendar"

;; 월요일부터 일주일 시작
(setq calendar-week-start-day 1)

(provide 'init-local)
;;; init-local.el ends here
