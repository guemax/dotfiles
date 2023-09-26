;; MIT License

;; Copyright (c) 2023 guemax

;; Permission is hereby granted, free of charge, to any person
;; obtaining a copy of this software and associated documentation
;; files (the "Software"), to deal in the Software without
;; restriction, including without limitation the rights to use, copy,
;; modify, merge, publish, distribute, sublicense, and/or sell copies
;; of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
;; BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
;; ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
;; CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                ;;;
;;;                --- Package Archives/Manager ---                ;;;
;;;                                                                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
	     '("gnu" . "https://elpa.gnu.org/packages/") t)

(package-install 'use-package)

(eval-when-compile
  (require 'use-package))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                ;;;
;;;                     --- User Interface ---                     ;;;
;;;                                                                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Disable *fancy* stuff like menubar, toolbar or even scrollbar.
(menu-bar-mode -1)
(tool-bar-mode -1)
(set-scroll-bar-mode nil)

;;; Gruber darker theme by Alexey Kutepov a.k.a. rexim.
(use-package gruber-darker-theme
  :ensure t
  :config
  (load-theme 'gruber-darker t))

(if (member "Iosevka" (font-family-list))
    (progn
      (add-to-list 'initial-frame-alist '(font . "Iosevka-13"))
      (add-to-list 'default-frame-alist '(font . "Iosevka-13")))
  (progn
    (set-face-attribute 'default nil :height 120)))


;;; Hightlight matching parenthesis.
(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

;;; Display line number and column number in the mode line.
(column-number-mode)

;;; Display line numbers on the left margin.
(require 'display-line-numbers)

(defcustom display-line-numbers-exempt-modes
  '(vterm-mode eshell-mode shell-mode term-mode ansi-term-mode pdf-view-mode)
  "Major modes on which to disable line numbers."
  :group 'display-line-numbers
  :type 'list
  :version "green")

(defun display-line-numbers--turn-on ()
  "Turn on line numbers except for certain major modes.
Exempt major modes are defined in `display-line-numbers-exempt-modes'."
  (unless (or (minibufferp)
              (member major-mode display-line-numbers-exempt-modes))
    (display-line-numbers-mode)))

(global-display-line-numbers-mode)
(setq display-line-numbers-type 'relative)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                ;;;
;;;                    --- User Experience ---                     ;;;
;;;                                                                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file) (load custom-file))

(setq default-directory "~/Documents")

(setq debug-on-error t)
(setq visible-bell t)
(setq confirm-kill-emacs 'y-or-n-p)

;; Disable graphical prompts. (Use minibuffer instead.)
(setq use-dialog-box nil)

;; Save input of minibuffer prompts.
(setq history-length 25)
(savehist-mode 1)

(global-auto-revert-mode 1)

(save-place-mode 1)
(recentf-mode 1)

(put 'upcase-region 'disabled nil)

;;; Display possible keyboard shortcuts for prefix key.
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;;; Mode for entering Emacs commands without modifier keys, similar to
;;; Vim's separation of command mode and insert mode.
(use-package god-mode
  :ensure t
  :config
  (global-set-key (kbd "<escape>") #'god-mode-all))

(use-package move-text
  :ensure t
  :bind (("M-p" . move-text-up)
	 ("M-n" . move-text-down))
  :config
  (advice-add 'move-text-up :after 'indent-region-advice)
  (advice-add 'move-text-down :after 'indent-region-advice))

(defun indent-region-advice (&rest ignored)
  (let ((deactivate deactivate-mark))
    (if (region-active-p)
        (indent-region (region-beginning) (region-end))
      (indent-region (line-beginning-position) (line-end-position)))
    (setq deactivate-mark deactivate)))

(use-package multiple-cursors
  :ensure t
  :bind (("C->" . mc/mark-next-like-this)
	 ("C-<" . mc/mark-previous-like-this)
	 ("C-c C-<" . mc/mark-all-like-this)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                ;;;
;;;                       --- Completion ---                       ;;;
;;;                                                                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; For minibuffers.
(ido-mode t)

;;; For buffers.
(use-package ivy
  :commands ivy-mode
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) "))

(use-package counsel
  :ensure t)

(use-package swiper
  :ensure t)

(use-package company-box
  :ensure t
  :hook (company-mode . company-box-mode))

(use-package company
  :ensure t
  :config
  (global-company-mode)
  (setq company-minimum-prefix-length 1
	company-idle-delay 0.0))

;;; For languages.
(use-package lsp-mode
  :ensure t
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (
	 (python-mode . lsp)
	 (c++-mode . lsp)
	 (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(use-package lsp-ivy
  :ensure t
  :commands lsp-ivy-workspace-symbol)

(use-package lsp-treemacs
  :ensure t
  :commands lsp-treemacs-error-list)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                ;;;
;;;                       --- Projectile ---                       ;;;
;;;                                                                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map))
  :config
  (setq projectile-project-search-path
	'(
	  "~/projects/"
	  "~/work/"
	  ("~/Documents/programming" . 1)
	  ("~/Documents/school/" . 1)))
  (setq projectile-globally-ignored-directories
	(append
	 '(
	   "venv"
	   "__pycache__")
	 projectile-globally-ignored-directories)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                ;;;
;;;                       --- Dashboard ---                        ;;;
;;;                                                                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package dashboard
  :ensure t
  :config
  (setq dashboard-projects-backend 'projectile)
  (setq dashboard-items '((recents . 3)
			  (projects . 3)
			  (agenda . 5)))
  (setq dashboard-center-content t)
  (setq dashboard-banner-logo-title "Welcome, my friend!")
  (setq dashboard-week-agenda t)
  (setq dashboard-filter-agenda-entry 'dashboard-no-filter-agenda)
  (setq dashboard-startup-banner 1)
  (setq dashboard-footer-messages
	'("The one true editor, Emacs!"
	  "Who the hell uses VIM anyway? Go Evil!"
	  "Free as free speech, free as free Beer!"
	  "Happy coding!"
	  "Vi Vi Vi, the editor of the beast!"
	  "Welcome to the church of Emacs."
	  "While any text editor can save your files, only Emacs can save your soul."
	  "Emacs is a nice operating system, but I prefer UNIX."
	  "Calling Emacs an editor is like calling the Earth a hunk of dirt."
	  "No person, no idea, and no religion deserves to be illegal to insult, not even the Church of Emacs."
	  "I use Emacs, which might be thought of as a thermonuclear word processor."
	  "An infinite number of monkeys typing into GNU Emacs would never make a good program."
	  "Emacs is an acronym for \"Escape Meta Alt Control Shift\"."
	  "Customization is the corner stone of Emacs."
	  "Emacs is written in Lisp, which is the only computer language that is beautiful."
	  "Truth can be only found in one place: the code."))
  (dashboard-setup-startup-hook))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                ;;;
;;;                     --- Language Modes ---                     ;;;
;;;                                                                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Nix.
(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'")

;;; Rust.
(use-package rust-mode
  :ensure t
  :config
  (setq rust-format-on-save t)
  (add-hook 'rust-mode-hook #'lsp)
  (add-hook 'rust-mode-hook (lambda () (setq indent-tabs-mode nil))))

(use-package cargo-mode
  :ensure t
  :config
  (setq compilation-scroll-output t)
  (add-hook 'rust-mode-hook 'cargo-minor-mode))

;;; TeX.
(use-package tex
  :ensure auctex
  :config
  (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
	TeX-source-correlate-start-server t)
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil)
  :hook
  (TeX-after-TeX-LaTeX-command-finished . TeX-revert-document-buffer))

(use-package pdf-tools
  :ensure t
  :config
  (setq-default pdf-view-display-size 'fit-page)
  (setq pdf-annot-activate-created-annotations t)
  (pdf-tools-install :no-query)
  (require 'pdf-occur))

;;; YAML.
(use-package yaml-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
  (add-hook 'yaml-mode-hook
	    '(lambda ()
               (define-key yaml-mode-map "\C-m" 'newline-and-indent))))

;;; PHP
(use-package php-mode
  :ensure t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                ;;;
;;;                          --- Git ---                           ;;;
;;;                                                                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

(require 'git-commit)

;;; Pinentry for entering GPG key password inside Emacs.
(use-package pinentry
  :ensure t
  :init (pinentry-start))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                ;;;
;;;                   --- Custom Keybindings ---                   ;;;
;;;                                                                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(keymap-global-set "C-c c" 'compile)
(setq compile-command "grep -rn ")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                ;;;
;;;                        --- Org Mode ---                        ;;;
;;;                                                                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)))

(setq org-confirm-babel-evaluate nil)

(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))

(use-package org
  :ensure t
  :config
  (setq org-hide-emphasis-markers t)
  (setq org-agenda-files '("~/org/Tasks.org"
			   "~/org/Tests.org"
			   "~/org/Birthdays.org"))
  (setq org-startup-folded t)
  (setq org-startup-indented t)
  
  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
          (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)"
                    "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)"
                    "|" "COMPLETED(c)" "CANC(c@)")))
  (setq org-tag-alist
        '(("@home" . ?H)
          ("@school" . ?S)
          ("agenda" . ?A)
          ("planning" . ?p)
          ("publish" . ?p)
          ("batch" . ?b)
          ("note" . ?n)
          ("idea" . ?i))))

(use-package org-bullets
  :ensure t
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

;;; Exporting org mode files to markdown.
(require 'ox-md)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                ;;;
;;;                 --- Custom ELisp functions ---                 ;;;
;;;                                                                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun insert-elisp-header-comment (title)
  "Insert a  H U G E  Emacs Lisp comment for standout headers."
  (interactive "MTitle for header comment: ")
  (insert-header-comment title 3 ?\;))

(defun insert-haskell-header-comment (title)
  "Insert a  H U G E  Haskell comment for standout headers."
  (interactive "MTitle for header comment: ")
  (insert-header-comment title 2 ?-))

(defun insert-nix-header-comment (title)
  "Insert a  H U G E  Nix comment for standout headers."
  (interactive "MTitle for header comment: ")
  (insert-header-comment title 3 ?#))

(defun insert-c-header-comment (title)
  "Insert a  H U G E  C comment for standout headers."
  (interactive "MTitle for header comment: ")
  (insert-header-comment title 2 ?/))

(defun insert-tex-header-comment (title)
  "Insert a  H U G E  TeX comment for standout headers."
  (interactive "MTitle for header comment: ")
  (insert-header-comment title 3 ?%))

(defun insert-header-comment (title border-width char)
  "Insert a  H U G E  comment for standout headers."

  (let* ((styling "---")
	 (title (concat styling " " title " " styling))
	 (title-width (length title))
	 (comment-width 70)
	 ;; Subtract two for preventing the comment from touching the
	 ;; border.
	 (max-allowed-title-width (- comment-width (* 2 border-width) 2))
	 (padding-width (- comment-width title-width (* 2 border-width)))
	 (left-padding-width (/ padding-width 2))
	 (right-padding-width (- padding-width left-padding-width)))

    (when (> title-width max-allowed-title-width)
      (error "Error: Title is too long to fit inside 70 chars wide comment."))
    (insert (concat
	     "\n" "\n"
	     (make-string comment-width char) "\n"
	     
	     (make-string border-width char)
	     (make-string (+ padding-width title-width) ?\s)
	     (make-string border-width char) "\n"
	     
	     (make-string border-width char)
	     (make-string left-padding-width ?\s)
	     title
	     (make-string right-padding-width ?\s)
	     (make-string border-width char) "\n"
	     
	     (make-string border-width char)
	     (make-string (+ padding-width title-width) ?\s)
	     (make-string border-width char) "\n"
	     
	     (make-string comment-width char)
	     "\n" "\n"))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                ;;;
;;;                      --- Emacs Server ---                      ;;;
;;;                                                                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load "server")
(unless (server-running-p) (server-start))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                ;;;
;;;                       --- Mode Line ---                        ;;;
;;;                                                                ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package dim
  :ensure t)

(dim-minor-names '((company-mode "")
		   (company-box-mode "")
		   (which-key-mode "")
		   (ivy-mode "")))
