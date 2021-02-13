;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Jack Sweeney"
      user-mail-address "annoyatron255@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Fira Mono" :size 17)
      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 18))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'my-doom-dark+)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;;(setq display-line-numbers-type 'relative)
(setq display-line-numbers-type nil)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;(global-set-key (kbd "TAB") 'self-insert-command)

;; Default to 8 space hard tabs
(setq-default indent-tabs-mode t)
(setq-default tab-width 8)

;; 4 space soft tabs in python
(add-hook 'python-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq tab-width 4)
            (setq python-indent-offset 4)))

;; C linux style
(setq c-default-style '((other . "linux")))
(defvaralias 'c-basic-offset 'tab-width)

;; LaTeX style
(defun my-latex-hook ()
  (setq indent-tabs-mode t)
  (setq tab-width 8)
  (setq LaTeX-indent-level 8)
  (setq font-latex-fontify-script nil)
  (setq +latex-indent-item-continuation-offset 'auto)
  (setq TeX-electric-escape nil)
  (setq TeX-electric-sub-and-superscript nil))

(add-hook 'LaTeX-mode-hook `my-latex-hook)
(add-hook 'latex-mode-hook `my-latex-hook)

(setq yas-snippet-dirs (list "/home/jack/.config/doom/snippets"))
;;(setq yas-key-syntaxes (list "w_.()" "w_." "w_" "w" (lambda (_start-point) (skip-chars-backward "[:graph:]" 2))))
(setq yas-key-syntaxes (list "w_.()" "w_." "w_" "w"
                             (lambda (_start-point) (condition-case nil (let (_) (backward-char 1) -1) (error 0)))
                             (lambda (_start-point) (condition-case nil (let (_) (backward-char 2) -2) (error 0)))
                             (lambda (_start-point) (condition-case nil (let (_) (backward-char 3) -3) (error 0)))
                             (lambda (_start-point) (condition-case nil (let (_) (backward-char 4) -4) (error 0)))
                             (lambda (_start-point) (condition-case nil (let (_) (backward-char 5) -5) (error 0)))))
                             ;;(lambda (_start-point) (backward-char 3) -3)
                             ;;(lambda (_start-point) (backward-char 4) -4)))
(setq yas-triggers-in-field t)
(defun my-yas-try-expanding-auto-snippets ()
  (when (and (boundp 'yas-minor-mode) yas-minor-mode)
    (let ((yas-buffer-local-condition ''(require-snippet-condition . auto)))
      (yas-expand))))
(add-hook 'post-self-insert-hook #'my-yas-try-expanding-auto-snippets)

(defun my-auto-frac-snippet ()
  (if (and (texmathp) (looking-back "[ \t\n\r]\\(\\([0-9]+\\)\\|\\([0-9]*\\)\\(\\\\\\)?\\([A-Za-z]+\\)\\(\\(\^\\|_\\)\\(\{[0-9]+\}\\|[0-9]\\)\\)*\\)/"))
      (yas-expand-snippet (concat "\\frac{"
                                  (substring-no-properties (match-string 1))
                                  "}{$1}$0")
                          (match-beginning 1)
                          (+ (match-end 1) 1))))
(add-hook 'post-self-insert-hook #'my-auto-frac-snippet)

;; Disable indent/parathesis "help"
(when (fboundp 'electric-indent-mode) (electric-indent-mode -1))
(when (fboundp 'electric-pair-mode) (electric-pair-mode -1))
(setq sp-autoinsert-pair nil)

;; Remove extraneous evil- prefix on motions
(setq which-key-allow-multiple-replacements t)
(after! which-key
  (pushnew!
   which-key-replacement-alist
   '(("" . "\\`+?evil[-:]?\\(?:a-\\)?\\(.*\\)") . (nil . "◂\\1"))
   '(("\\`g s" . "\\`evilem--?motion-\\(.*\\)") . (nil . "◃\\1"))))

;; Scrolling adjustments
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-scroll-amount '(3 ((shift) . hscroll) ((meta) . nil) ((control) . text-scale)))
;;(setq jit-lock-defer-time 0)
;;(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))
(setq scroll-margin 3)

;; Terminal mouse scrolling
(unless (display-graphic-p)
  (xterm-mouse-mode t)
  (global-set-key (kbd "<mouse-4>") (lambda () (interactive) (scroll-down 3)))
  (global-set-key (kbd "<mouse-5>") (lambda () (interactive) (scroll-up 3))))

;; Keep everything the same color (key color)
(after! solaire-mode
  (solaire-global-mode -1))

(after! verilog-mode
  (substitute-key-definition 'backward-delete-char-untabify 'backward-delete-char verilog-mode-map))

;; Avoid flycheck/polymode conflicts
(setq flycheck-global-modes '(not python-mode latex-mode polymode-mode))

;; Use ipython for inferior python
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "/home/jack/.pythontexcustomcode.py --no-banner --simple-prompt -i")

;; Polymode Setup
(require 'polymode)

(define-hostmode poly-latex-hostmode :mode 'latex-mode)

(define-innermode poly-pycode-latex-innermode
  :mode 'python-mode
  :head-matcher "\\\\begin{pycode}\n"
  :tail-matcher "\\\\end{pycode}"
  :adjust-face nil
  :head-mode 'host
  :tail-mode 'host)

(define-innermode poly-pyblock-latex-innermode
  :mode 'python-mode
  :head-matcher "\\\\begin{pyblock}\n"
  :tail-matcher "\\\\end{pyblock}"
  :adjust-face nil
  :head-mode 'host
  :tail-mode 'host)

(define-innermode poly-py-latex-innermode
  :mode 'python-mode
  :head-matcher "\\\\py"
  :tail-matcher "}"
  :adjust-face nil
  :head-mode 'host
  :tail-mode 'host)

(defun poly-latex-python-eval-chunk (beg end msg)
  (python-shell-send-region beg end))

(define-polymode poly-latex-mode
  :hostmode 'poly-latex-hostmode
  :innermodes '(poly-pycode-latex-innermode
                poly-pyblock-latex-innermode
                poly-py-latex-innermode)
  (setq polymode-eval-region-function #'poly-latex-python-eval-chunk))

(add-to-list 'auto-mode-alist '("\\.tex$" . poly-latex-mode))
