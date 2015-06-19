;; Package stuff

(require 'cl) ;; needed for loop

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
;; had a funky cert problem
;;(add-to-list 'package-archives
;;             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

(defvar required-packages
  '(
    cider
    evil
    evil-leader
    clj-refactor
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
(evil-mode 1)

(require 'evil-leader)
(evil-leader/set-leader "<SPC>")

;; cider stuff

(defun my-cider-repl-mode-hook ()
;;  (setq show-trailing-whitespace nil)
;;  (smartparens-strict-mode 1)
;;  (company-mode 1)
;;  (eldoc-mode)
  (fill-keymaps '(evil-insert-state-local-map evil-normal-state-local-map)
                "M-." 'my-cider-find-var
                "C-c M-." 'my-cider-find-resource
                "M-," 'cider-jump-back)
  (whitespace-mode 0)
  (evil-force-normal-state))
(add-hook 'cider-repl-mode-hook #'my-cider-repl-mode-hook)

(defun my-clojure-mode-hook ()
  (cider-mode 1)
  (fill-keymap cider-mode-map
               "C-c C-e" 'cider-eval-defun-at-point
               "C-c C-m" nil
               "C-c h" 'clojure-cheatsheet
               "C-c M-b" 'cider-browse-ns-all
               "C-c m" 'cider-macroexpand-1
               "C-c c" 'cider-clear-errors
               "C-c M" 'cider-macroexpand-all)
  (cljr-add-keybindings-with-prefix "C-c C-m")
  (local-set-key (kbd "RET") 'newline-and-indent)
  (fill-keymap evil-normal-state-local-map
               "M-q" '(lambda () (interactive) (clojure-fill-paragraph))
               "M-." 'my-cider-find-var
               "C-c M-." 'my-cider-find-resource
               "M-," 'cider-jump-back
               "M-n" 'flycheck-next-error
               "M-p" 'flycheck-previous-error
               "C-c s" 'toggle-spy
               "C-c f" 'toggle-print-foo
               "C-c R" 'cider-component-reset))

(add-hook 'clojure-mode-hook #'my-clojure-mode-hook)

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

;; Turn off auto-saves

(setq auto-save-default nil)

;; Turn off backups

(setq backup-inhibited t)

;; Add highlighting type thing for the selected region

(transient-mark-mode 1)

;; sane scrolling

(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq auto-window-vscroll nil)

;;  Terminal Mode Tweaks

(defun my-terminal-mode ()
  (interactive)
  (ansi-term "/bin/bash"))

;; Window movement

(defun my-next-window ()
  (interactive)
  (other-window 1))

(defun my-previous-window ()
  (interactive)
  (other-window -1))

;;  Hotkeys

;;(global-set-key (kbd "C-`")  'my-terminal-mode)

(global-set-key (kbd "<f2>") 'save-buffer)

(global-set-key (kbd "C-1")  'previous-buffer)
(global-set-key (kbd "C-2")  'next-buffer)
(global-set-key (kbd "C-3")  'my-previous-window)
(global-set-key (kbd "C-4")  'my-next-window)
(global-set-key (kbd "C-5")  'other-frame)

(global-set-key (kbd "C-8")  'edit-dot-emacs)
(global-set-key (kbd "C-9")  'reload-dot-emacs)

(global-set-key (kbd "C-x C-b") 'ibuffer)

 

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (cider evil-leader))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
