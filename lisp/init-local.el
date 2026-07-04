;;; init-local.el --- My custom settings
;;; Commentary:
;;; 환경변수
;;;   직접 참조:
;;;     - HANGUL_KEYBOARD_TYPE=(3f | 2)
;;;     - LANG=ko_KR.utf8 (ko_KR.UTF-8로 하면 안된다. calendar 요일 깨짐)
;;;   아마도 참조:
;;;     - LANGUAGE=ko:en
;;;     - LC_ALL=ko_KR.utf8 (ko_KR.UTF-8로 하면 안된다. calendar 요일 깨짐)

;; ref: https://github.com/purcell/emacs.d

;;; Code:

;; (setq system-time-locale "ko_kr.utf-8")
;; (setq system-time-locale "ko_KR.utf8")

;; reading a file from: http://xahlee.info/emacs/emacs/elisp_read_file_content.html
(defun update-org-agenda-files ()
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
                    (split-string (buffer-string) "\n" t))))))

(update-org-agenda-files)
;; https://emacs.stackexchange.com/questions/36208/call-a-function-and-insert-text-in-minibuffer-prompt --> 이거 아닌듯...
;; (add-hook 'minibuffer-setup-hook 'update-org-agenda-files)

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
;; (setq org-journal-date-prefix "#+TITLE: Daily Notes ")
;; (setq org-journal-date-prefix "일일 노트 -*- mode: org; encoding: utf-8; -*- ") ; prefix에 포함되어서 좀 못생기게 된다.

(setq org-journal-date-prefix "#+DATE: ")

;; from: https://github.com/bastibe/org-journal/issues/153
(defun org-journal-date-format-func (time)
  "Custom function to insert journal date header,
and some custom text on a newly created journal file."
  (when (= (buffer-size) 0)
    (insert
     (concat "# -*- mode: org; encoding: utf-8; -*-\n"
             (pcase org-journal-file-type
               (`daily "#+TITLE: 일간 저널")
               (`weekly "#+TITLE: 주간 저널")
               (`monthly "#+TITLE: 월간 저널")
               (`yearly "#+TITLE: 연간 저널"))
             )))
  (concat org-journal-date-prefix (format-time-string "%x(%a)" time)))

(setq org-journal-date-format 'org-journal-date-format-func)

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

;; ;; for pasted text (on windows)
;; ;; from: https://rufflewind.com/2014-07-20/pasting-unicode-in-emacs-on-windows
;; ;;(set-selection-coding-system 'utf-16-le)
;; (set-selection-coding-system 'utf-8)
;; ;; OR (from https://stackoverflow.com/questions/22647517/emacs-encoding-of-pasted-text)
;; ;; (set-clipboard-coding-system 'utf-16le)

(when (eq 'w32 window-system)
  (set-selection-coding-system 'utf-8)
  (set-clipboard-coding-system 'utf-16le))

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
                    :height 1.0 :foreground "salmon" :underline t :slant 'italic)
;; End of "week number on calendar"

;; 월요일부터 일주일 시작
(setq calendar-week-start-day 1)

;; https://stackoverflow.com/questions/5570451/how-to-start-emacs-server-only-if-it-is-not-started
(require 'server)
(unless (server-running-p) (server-start))

;; docker-container-shell command 실행 시 다음 에러 방지
;; tramp-error: ‘tramp-histfile-override’ uses invalid file ‘~/.tramp_history’
;; (docker 또는 tramp 패키지 업데이트시 삭제하고 정상동작하는지 확인할 필요 있음) - as of 2026.04
(setq tramp-histfile-override "/dev/null")

;; ref: https://share.google/aimode/b4BamQgcXDL7HN7M8
;; (defadvice find-file (around find-file-line-number activate)
;;   "파일 이름 뒤에 :라인번호가 붙어있으면 해당 라인으로 이동합니다."
;;   (let* ((filename (ad-get-arg 0))
;;          (match (string-match "\\(.*\\):\\([0-9]+\\)$" filename))
;;          (line-num (if match (string-to-number (match-string 2 filename)) nil))
;;          (real-file (if match (match-string 1 filename) filename)))
;;     (ad-set-arg 0 real-file)
;;     ad-do-it
;;     (when line-num
;;       (goto-char (point-min))
;;       (forward-line (1- line-num)))))

(defun my/find-file-line-column (orig-fun filename &rest args)
  "C-x C-f에서 파일명:라인:컬럼 또는 파일명:라인 형태로 열 수 있도록 확장합니다."
  (let ((line-num nil)
        (col-num nil)
        (real-file filename))
    ;; 1. 파일명:라인:컬럼 패턴 검사 (예: main.c:120:5)
    (if (string-match "\\(.*\\):\\([0-9]+\\):\\([0-9]+\\)$" filename)
        (setq real-file (match-string 1 filename)
              line-num (string-to-number (match-string 2 filename))
              col-num (string-to-number (match-string 3 filename)))
      ;; 2. 파일명:라인 패턴 검사 (예: main.c:120)
      (when (string-match "\\(.*\\):\\([0-9]+\\)$" filename)
        (setq real-file (match-string 1 filename)
              line-num (string-to-number (match-string 2 filename)))))

    ;; 원래 find-file 함수 실행
    (apply orig-fun real-file args)

    ;; 라인 및 컬럼 이동 처리
    (when line-num
      (goto-char (point-min))
      (forward-line (1- line-num))
      (when col-num
        ;; Emacs 컬럼은 0부터 시작하므로 1을 빼줍니다.
        (move-to-column (1- col-num))))))

;; find-file 함수에 위 기능을 적용
(advice-add 'find-file :around #'my/find-file-line-column)

;; from: https://emacs.stackexchange.com/questions/48720/disable-left-win-key-in-emacs-for-windows#:~:text=If%20you%20are%20trying,nil%29%20.
;; super key를 쓸 수 있게 하려는 목적인데, GUI mode에서만 동작하는 것으로 보인다
(setq w32-pass-lwindow-to-system nil
      w32-lwindow-modifier 'super) ;; Menu key

;; (defun super-test ()
;;   (interactive)
;;   (message "Super"))

;; (global-set-key (kbd "s-]") 'super-test)

(provide 'init-local)
;;; init-local.el ends here
