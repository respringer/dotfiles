;; TO DO
;;         friendly way to exit insert mode like fj or something
;;         
;;
;; Package stuff
;;
;;

(require 'cl) ;; needed for loop

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
;; had a funky cert problem
;;(add-to-list 'package-archives
;;             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

;; really good: evil, evil-leader, evil-escape
;; good: projectile, helm projectile
;; clojure: cider, clj-refactor
;;  for lein, check out the versions at: https://clojars.org/cider/cider-nrepl/versions
;;                                  and: https://clojars.org/refactor-nrepl/versions
;;  for cider, clj-refactor with java 1.7, do this before lein repl:
;;       export JAVA_OPTS="-XX:MaxPermSize=128m"

;; to check out: guide-key, hydra, rainbow identifiers

(defvar required-packages
  '(
    evil
    evil-leader
    evil-escape
    projectile
    helm-projectile
    cider
    clj-refactor
    rainbow-delimiters
    rainbow-identifiers
  ) "a list of packages to ensure are installed at launch.")

; method to check if all packages are installed
(defun packages-installed-p ()
  (loop for p in required-packages
        when (not (package-installed-p p)) do (return nil)
        finally (return t)))

; if not all packages are installed, check one by one and install the missing ones.
(unless (packages-installed-p)
  ; check for new packages (package versions)
  (message "%s" "Emacs is now refreshing its package database...")
  (package-refresh-contents)
  (message "%s" " done.")
  ; install the missing packages
  (dolist (p required-packages)
    (when (not (package-installed-p p))
      (package-install p))))

;; evil

(require 'evil)
(require 'evil-leader)

(evil-leader/set-leader "<SPC>")
(setq evil-leader/in-all-states t)
;; enable evil-leader before enabling evil
(global-evil-leader-mode)
(evil-mode 1)

(set-default-font "Monospace-16")

;; This will cause dired to default to Normal mode

(setq evil-normal-state-modes (append evil-motion-state-modes evil-normal-state-modes))
(setq evil-motion-state-modes nil)

(evil-escape-mode 1)

;;(setq-default evil-escape-delay 0.2)
;;(setq-default evil-escape-delay 2.0)
;; give me a couple of minutes to decide if i want to exit insert mode... heh
(setq-default evil-escape-delay 120.0)

(setq-default evil-escape-key-sequence "fj")
;(setq-default evil-escape-key-sequence "jk")
(setq evil-escape-unordered-key-sequence 1)

(require 'clj-refactor)
(add-hook 'clojure-mode-hook (lambda ()
                               (clj-refactor-mode 1)
                               ;;(yas-minor-mode 1) ; for adding require/use/import
                               ;; insert keybinding setup here
;;			                   (cljr-add-keybindings-with-prefix "C-c C-m")
                               ;; eg. rename files with `C-c C-m rf`.
                               ))

;; include underscore as a word character for evil for * searches

(add-hook 'clojure-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))
(add-hook 'js-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))
(add-hook 'python-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))
(evil-set-initial-state 'ibuffer-mode 'normal)

;; projectile

(require 'projectile)

(projectile-global-mode)
(projectile-mode 1)

(projectile-add-known-project "/home/vagrant/ripcord/spock")

;;

;;(require 'smartparens)
;;(require 'smartparens-config)

;; rainbow delimiters

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook #'rainbow-identifiers-mode)

;; helm

(add-to-list 'load-path "/home/vagrant/emacs-async")
(add-to-list 'load-path "/home/vagrant/helm")

(require 'helm-config)

(helm-mode 1)

(setq projectile-completion-system 'helm)
(helm-projectile-on)

(global-set-key (kbd "M-x") 'helm-M-x)
(setq helm-M-x-fuzzy-match t)

(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match    t)

(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-c h o") 'helm-occur)
(global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)
(global-set-key (kbd "C-c h x") 'helm-register)
(global-set-key (kbd "C-c h h") 'helm-google-suggest)
(global-set-key (kbd "C-c h M-:") 'helm-eval-expression-with-eldoc)

(setq helm-semantic-fuzzy-matching t
      helm-locate-fuzzy-match    t
      helm-apropos-fuzzy-match    t
      helm-lisp-fuzzy-completion    t
      helm-imenu-fuzzy-match    t)

(add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)

(require 'helm-eshell)
(add-hook 'eshell-mode-hook
	  #'(lambda () (define-key eshell-mode-map (kbd "C-c C-l") 'helm-eshell-history)))

(define-key shell-mode-map (kbd "C-c C-l") 'helm-comint-input-ring)
(define-key minibuffer-local-map (kbd "C-c C-l") 'helm-minibuffer-history)

;; edit and reload .emacs

(defun edit-dot-emacs ()
  "Load the .emacs file into a buffer for editing."
  (interactive)
  (find-file "~/.emacs"))

(defun reload-dot-emacs ()
  "Save .emacs, if it is in a buffer, and reload it."
  (interactive)
  (if (bufferp (get-file-buffer "~/.emacs"))
    (save-buffer (get-buffer "~/.emacs")))
  (load-file "~/.emacs"))

;; backup files

(setq make-backup-files nil)

;; No tabs! - spaces only

(setq tab-width 4)
(setq indent-tabs-mode nil)

;; No bell at all

(setq ring-bell-function 'ignore)

;;(load-theme 'afternoon t)

;; disable the tool bar
(tool-bar-mode -1)

;; Turn off auto-saves

(setq auto-save-default nil)

;; Turn off backups

(setq backup-inhibited t)

;; Add highlighting type thing for the selected region

(transient-mark-mode 1)

(show-paren-mode)

;; sane scrolling

(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq auto-window-vscroll nil)

(add-to-list 'auto-mode-alist '("\\.edn\\'" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.boot\\'" . clojure-mode))

;; display a clock

(setq display-time-day-and-date t
      display-time-24hr-format t)
(display-time)

;; line numbers

(add-hook 'clojure-mode-hook (lambda () (linum-mode 1)))

;; todo, rebind ` in ibuffer 
;;(add-hook 'ibuffer-mode-hook
;;          (lambda ()
;;            (define-key 1)))

;;  Terminal Mode Tweaks

(defun my-terminal-mode ()
  (interactive)
  (ansi-term "/bin/bash"))

(defun my-next-window ()
  (interactive)
  (other-window 1))

(defun my-previous-window ()
  (interactive)
  (other-window -1))

;; term stuff

(require 'term)

(defun jnm/term-toggle-mode ()
  "Toggles term between line mode and char mode"
  (interactive)
  (if (term-in-line-mode)
      (term-char-mode)
    (term-line-mode)))

(defun rs-term-enter-scroll-mode ()
  (interactive)
  (term-line-mode)
  (evil-normal-state)) 

(defun rs-term-exit-scroll-mode ()
  (interactive)
  (end-of-buffer)
  (term-char-mode)
  (evil-insert-state)) 

(define-key term-mode-map (kbd "C-c C-j") 'jnm/term-toggle-mode)
(define-key term-mode-map (kbd "C-c C-k") 'jnm/term-toggle-mode)

(define-key term-raw-map (kbd "C-c C-j") 'jnm/term-toggle-mode)
(define-key term-raw-map (kbd "C-c C-k") 'jnm/term-toggle-mode)

;; send string or current kill to the term without changing modes
(defun my-term-paste (&optional string)
  (interactive)
  (process-send-string
   (get-buffer-process (current-buffer))
   (if string string (current-kill 0))))

;;  Hotkeys

;; i want a backquote as a prefix key

(define-prefix-command 'my-backquote-keymap)
(define-key my-backquote-keymap (vector ?`) 'my-insert-backquote)
(define-key my-backquote-keymap (vector ?q) 'rs-term-exit-scroll-mode)
(define-key my-backquote-keymap (vector ?b) 'ibuffer)
(define-key my-backquote-keymap (vector ?9) 'edit-dot-emacs)
(define-key my-backquote-keymap (vector ?0) 'reload-dot-emacs)
(define-key my-backquote-keymap (vector ?p) 'projectile-find-file)

(define-key my-backquote-keymap (vector ?g) 'helm-keyboard-quit)
(define-key my-backquote-keymap (vector ?h) 'previous-buffer)
(define-key my-backquote-keymap (vector ?j) 'my-next-window)
(define-key my-backquote-keymap (vector ?k) 'my-previous-window)
(define-key my-backquote-keymap (vector ?l) 'next-buffer)
(define-key my-backquote-keymap (vector ? ) 'rs-term-enter-scroll-mode)

(define-key my-backquote-keymap (vector ?s) 'split-window-below)
(define-key my-backquote-keymap (vector ?v) 'split-window-right)
(define-key my-backquote-keymap (vector ?x) 'helm-M-x)

(define-key my-backquote-keymap (vector ?,) 'rename-buffer)

(define-key my-backquote-keymap (kbd "<up>") 'enlarge-window)
(define-key my-backquote-keymap (kbd "<down>") 'shrink-window)
(define-key my-backquote-keymap (kbd "<left>") 'shrink-window-horizontally)
(define-key my-backquote-keymap (kbd "<right>") 'enlarge-window-horizontally)

(defun my-insert-backquote ()
  (interactive)
  (insert "`"))

(define-key evil-normal-state-map (kbd "`") 'my-backquote-keymap)
(define-key evil-insert-state-map (kbd "`") 'my-backquote-keymap)
(define-key evil-emacs-state-map (kbd "`") 'my-backquote-keymap)


(define-key evil-normal-state-map (kbd "M-.") 'cider-find-var)
 
;; it looks like 3 relavant helms are
;;
;; helm-mini
;; helm-buffers-list

;; this one is for finding new files
;; helm-find-files

(evil-leader/set-key
  "e" 'eshell
  "t" 'my-terminal-mode

  "s" 'save-buffer
  "d" 'cider-doc
  "f" 'helm-find-files
  "g" 'helm-keyboard-quit

  "p" 'projectile-find-file
  "]" 'helm-buffers-list

  "<tab>" 'helm-keyboard-quit

  "x" 'helm-M-x

  "i" 'ibuffer
  "b" 'ibuffer
;;  "i" 'helm-buffers-list

  "h" 'previous-buffer
  "j" 'my-next-window
  "k" 'my-previous-window
  "l" 'next-buffer

  "3" 'my-previous-window
  "4" 'my-next-window
  "5" 'other-frame

  "9" 'edit-dot-emacs
  "0" 'reload-dot-emacs

  "[" 'split-window-below
  "]" 'split-window-right

  "<up>"     'shrink-window
  "<down>"   'enlarge-window
  "<left>"   'shrink-window-horizontally
  "<right>"  'enlarge-window-horizontally
)

;;(setq cljr--debug-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (afternoon-theme evil-escape rainbow-identifiers rainbow-delimiters helm-projectile evil-leader clj-refactor))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
