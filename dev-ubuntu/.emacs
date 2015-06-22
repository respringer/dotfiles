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
    projectile
    helm-projectile
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

(require 'clj-refactor)
(add-hook 'clojure-mode-hook (lambda ()
;;                               (clj-refactor-mode 1)
                               ;;(yas-minor-mode 1) ; for adding require/use/import
                               ;; insert keybinding setup here
;;			                   (cljr-add-keybindings-with-prefix "C-c C-m")
                               ;; eg. rename files with `C-c C-m rf`.
                               ))

;; include underscore as a word character for evil for * searches

(add-hook 'clojure-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))
(add-hook 'js-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))
(add-hook 'python-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))

;; projectile

(projectile-global-mode)
(projectile-mode 1)

(projectile-add-known-project "/home/vagrant/ripcord/spock")

;; helm

(add-to-list 'load-path "/home/vagrant/emacs-async")
(add-to-list 'load-path "/home/vagrant/helm")

(require 'helm-config)

(helm-mode 1)

(setq projectile-completion-system 'helm)
(helm-projectile-on)

(global-set-key (kbd "M-x") 'helm-M-x)
(setq helm-M-x-fuzzy-match t)

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


(add-to-list 'auto-mode-alist '("\\.edn\\'" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.boot\\'" . clojure-mode))

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


(define-key evil-normal-state-map (kbd "M-.") 'cider-find-var)
 

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (helm-projectile projectile clj-refactor evil-leader evil cider))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
