;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Section One: Packages
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; cl provides loop
(require 'cl)
(require 'package)

(add-to-list
    'package-archives
    '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)

;; really good: evil, evil-leader

(defvar required-packages
  '(
    ;; Code formatting
    aggressive-indent
    align-cljlet

    ;; vim emulation
    evil
    evil-leader
    evil-escape

    ;; vim navigation
    ;; TODO avy might be a superset of snipe
    ;; maybe remove snipe
    evil-snipe
    evil-avy

    ;; theme
    cyberpunk-theme
    rainbow-delimiters
    nyan-mode
    highlight

    ;; navigation
    bm

    ;; clojure
    cider

    ;; maybe replace helm with ivy
    projectile
    helm-projectile
    helm-descbinds
    helm-ag
    helm-swoop
    )
    "a list of packages to ensure are installed at launch.")

;; method to check if all packages are installed
(defun packages-installed-p ()
  (loop for p in required-packages
        when (not (package-installed-p p)) do (return nil)
        finally (return t)))

;; if not all packages are installed, check one by one and install the missing ones.
(unless (packages-installed-p)
  ;; check for new packages (package versions)
  (message "%s" "Emacs is now refreshing its package database...")
  (package-refresh-contents)
  (message "%s" " done.")
  ;; install the missing packages
  (dolist (p required-packages)
    (when (not (package-installed-p p))
      (package-install p))))

(add-to-list 'load-path "~/.emacs.d/lisp/")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Try to avoid emacs creating files everywhere
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; no lock files
(setq create-lockfiles nil)

;; Turn off auto-saves
(setq auto-save-default nil)
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; backup files
(setq make-backup-files nil)
(setq backup-inhibited t)
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; General Settings
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; edit and reload .emacs
(defun edit-dot-emacs ()
  "Load the .emacs file into a buffer for editing."
  (interactive)
  (find-file "~/.emacs"))

(defun reload-dot-emacs ()
  (interactive)
  (if (bufferp (get-file-buffer "~/.emacs"))
    (save-buffer (get-buffer "~/.emacs")))
  (load-file "~/.emacs"))

;; No bell at all
(setq ring-bell-function 'ignore)

;; No tabs! - spaces only
(setq tab-width 4)
(setq indent-tabs-mode nil)

;; sane scrolling
(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq auto-window-vscroll nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Theme
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq evil-insert-state-cursor '((bar . 5) "purple")
      evil-normal-state-cursor '((bar . 5) "green"))

(blink-cursor-mode -1)

(load-theme 'cyberpunk t)

(require 'highlight)

(set-default-font "DejaVu Sans Mono 16")

(global-visual-line-mode 1)

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; disable the tool bar
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

; Add highlighting type thing for the selected region
(transient-mark-mode 1)

(show-paren-mode)

;; display a clock
(setq display-time-day-and-date t
      display-time-24hr-format t)
(display-time)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Better interaction with i3
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load-file "~/git-repos/frames-only-mode/frames-only-mode.el")
(require 'frames-only-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Vim emulation
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'evil)
(require 'evil-leader)

(evil-leader/set-leader "<SPC>")
(setq evil-leader/in-all-states t)

;; We should enable evil-leader before enabling evil
(global-evil-leader-mode)
(evil-mode 1)

;; This will cause dired to default to Normal mode
(setq evil-motion-state-modes nil)

(require 'evil-escape)
(evil-escape-mode 1)

;; give me a couple of minutes to decide
;; if i want to exit insert mode... heh
(setq-default evil-escape-delay 120.0)

(setq-default evil-escape-key-sequence "jf")
;;(setq evil-escape-unordered-key-sequence 1)

;; Make movement keys work like they should
(define-key evil-normal-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)

;; up and down follow visual lines, not logical
(setq-default evil-cross-lines t)

;; Make evil treat _ as part of a word
(with-eval-after-load 'evil
  (defalias #'forward-evil-word #'forward-evil-symbol))

;; include underscore as a word character for evil for * searches

(add-hook 'clojure-mode-hook  #'(lambda () (modify-syntax-entry ?_ "w")))
(add-hook 'js-mode-hook       #'(lambda () (modify-syntax-entry ?_ "w")))
(add-hook 'python-mode-hook   #'(lambda () (modify-syntax-entry ?_ "w")))

;; Make ibuffer start in normal mode
(evil-set-initial-state 'ibuffer-mode 'normal)

;; snipe
(require 'evil-snipe)
(evil-snipe-mode 1)

;; OPTIONAL: Replaces evil-mode's f/F/t/T motions with evil-snipe
;;(evil-snipe-override-mode 1)

;; avy
(require 'evil-avy)
(evil-avy-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Clojure
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            ))

(add-hook 'clojure-mode-hook #'aggressive-indent-mode)

(add-to-list 'auto-mode-alist '("\\.edn\\'" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.boot\\'" . clojure-mode))

(defun indent-cond (indent-point state)
  (goto-char (elt state 1))
  (let ((pos -1)
        (base-col (current-column)))
    (forward-char 1)
    ;; `forward-sexp' will error if indent-point is after
    ;; the last sexp in the current sexp.
    (condition-case nil
        (while (and (<= (point) indent-point)
                    (not (eobp)))
          (clojure-forward-logical-sexp 1)
          (cl-incf pos))
      ;; If indent-point is _after_ the last sexp in the
      ;; current sexp, we detect that by catching the
      ;; `scan-error'. In that case, we should return the
      ;; indentation as if there were an extra sexp at point.
      (scan-error (cl-incf pos)))
    (+ base-col (if (evenp pos) 4 2))))
(put-clojure-indent 'cond #'indent-cond)

(require 'align-cljlet)

;; cider

(setq cider-prompt-for-symbol nil)

(defun indent-buffer ()
  "Indent the currently visited buffer."
  (interactive)
  (indent-region (point-min) (point-max)))

(defun indent-region-or-buffer ()
  "Indent a region if selected, otherwise the whole buffer."
  (interactive)
  (save-excursion
    (if (region-active-p)
        (progn
          (indent-region (region-beginning) (region-end))
          (message "Indented selected region."))
      (progn
        (indent-buffer)
        (message "Indented buffer.")))))

(defun indent-defun ()
  "Indent the current defun."
  (interactive)
  (save-restriction
    (widen)
    (narrow-to-defun)
    (indent-buffer)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Shell Scripting
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun rs-sh-mode-hook ()
  "My config for sh mode."
  (interactive)
  (set-key "\t" (lambda () (interactive) (insert-char 32 4))) ;; [tab] inserts four spaces
  (setq sh-basic-offset 4
        sh-indentation 4))
(add-hook 'sh-mode-hook 'rs-sh-mode-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; RST
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'rst)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Bookmark
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key (kbd "<C-f2>") 'bm-toggle)
(global-set-key (kbd "<f2>")   'bm-next)
(global-set-key (kbd "<S-f2>") 'bm-previous)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Projectile
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'projectile)

(projectile-global-mode)
(projectile-mode 1)

(projectile-add-known-project "/home/ryan/ripcord")
;;(projectile-add-known-project "/home/ryan/ripcord/spock")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Helm
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'load-path "/home/ryan/emacs-async")
(add-to-list 'load-path "/home/ryan/helm")

(require 'helm-config)

(helm-mode 1)

(setq projectile-completion-system 'helm)
(helm-projectile-on)

(global-set-key (kbd "M-x") 'helm-M-x)
(setq helm-M-x-fuzzy-match t)
(setq helm-split-window-in-side-p t)
(setq helm-split-window-default-side 'below)

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
      helm-locate-fuzzy-match      t
      helm-apropos-fuzzy-match     t
      helm-lisp-fuzzy-completion   t
      helm-imenu-fuzzy-match       t)

(add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)

(require 'helm-descbinds)

(global-set-key (kbd "C-h b") 'helm-descbinds)

(define-key shell-mode-map (kbd "C-c C-l") 'helm-comint-input-ring)
(define-key minibuffer-local-map (kbd "C-c C-l") 'helm-minibuffer-history)

(require 'helm-ag)
(require 'helm-swoop)

;; When doing evil-search, hand the word over to helm-swoop
(define-key evil-motion-state-map (kbd "M-i") 'helm-swoop-from-evil-search)

;; If you prefer fuzzy matching
(setq helm-swoop-use-fuzzy-match t)

;; Change the keybinds to whatever you like :)
(global-set-key (kbd "M-i") 'helm-swoop)
(global-set-key (kbd "M-I") 'helm-swoop-back-to-last-point)
(global-set-key (kbd "C-c M-i") 'helm-multi-swoop)
(global-set-key (kbd "C-x M-i") 'helm-multi-swoop-all)

; change mode-line color by evil state
(lexical-let ((default-color (cons (face-background 'mode-line)
                                   (face-foreground 'mode-line))))
  (add-hook 'post-command-hook
            (lambda ()
              (let ((color (cond ((minibufferp) default-color)
                                 ;;((evil-insert-state-p) '("#e80000" . "#ffffff"))
                                 ((evil-insert-state-p) '("#480000" . "#ffffff"))
                                 ((evil-emacs-state-p)  '("#444488" . "#ffffff"))
                                 ((buffer-modified-p)   '("#006fa0" . "#ffffff"))
                                 (t default-color))))
                (set-face-background 'mode-line (car color))
                (set-face-foreground 'mode-line (cdr color))))))

;; my hybrid mode

(define-key evil-insert-state-map   (kbd "C-SPC") #'evil-escape)
(define-key evil-insert-state-map   (kbd "C-a") #'move-beginning-of-line)
(define-key evil-insert-state-map   (kbd "C-b") #'backward-char)
(define-key evil-insert-state-map   (kbd "C-d") #'delete-char)
(define-key evil-insert-state-map   (kbd "C-e") #'move-end-of-line)
(define-key evil-insert-state-map   (kbd "C-f") #'forward-char)
(define-key evil-insert-state-map   (kbd "C-k") #'kill-line)
;;(define-key evil-insert-state-map   (kbd "C-n") #'next-line)
;;(define-key evil-insert-state-map   (kbd "C-p") #'previous-line)

;; focus on the buffer with a mouse

(setq mouse-autoselect-window t)

;; org-mode stuffy stuff

(setq org-directory "/home/ryan/grive/orgmode")

(setq org-default-notes-file (concat org-directory "/notes.org"))

(defun rs-capture-task ()
  (interactive)
  (org-capture nil "t"))

;; capture a task
(define-key global-map "\C-cc" 'rs-capture-task)

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
;;(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)



(global-set-key (kbd "C-;") 'avy-goto-char)
(global-set-key (kbd "C-'") 'avy-goto-char-2)
(global-set-key (kbd "C-l") 'avy-goto-line)

(defun grive-sync ()
  (interactive)
  (async-shell-command "cd ~/grive; and grive"))
  ;;(async-shell-command "cd ~/grive && grive"))

(defun refresh-ubu ()
  (interactive)
  (async-shell-command "sudo /root/refresh-ubu"))

(defun dot-emacs-sync ()
  (interactive)
  (async-shell-command "~/bin/sync-dot-emacs.sh"))

;; buffer gestion

(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

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

;; ibuffer stuff

(setq ibuffer-saved-filter-groups
      (quote (("default"
               ("Org" ;; all org-related buffers
                (mode . org-mode))
               ("Clojure" ;; all org-related buffers
                (mode . clojure-mode))
               ("Programming" ;; prog stuff not already in MyProjectX
                (or
                 (mode . c-mode)
                 (mode . c++-mode)
                 (mode . perl-mode)
                 (mode . python-mode)
                 (mode . emacs-lisp-mode)))
               ("LaTeX"
                (mode . latex-mode))
               ("Terminals"
                (mode . term-mode))
               ("Directories"
                (mode . dired-mode))
               ))))

;; do not show empty groups by default
(setq ibuffer-show-empty-filter-groups nil)

;; keep the filter list up to date
(add-hook 'ibuffer-mode-hook
          '(lambda ()
             (ibuffer-auto-mode 1)
             (ibuffer-switch-to-saved-filter-groups "home")))

(setq mp/ibuffer-collapsed-groups (list "Helm" "*Internal*" "Default"))

;; whitespace stuff

(require 'whitespace)
(setq whitespace-display-mappings
      ;; all numbers are Unicode codepoint in decimal. try (insert-char 182 ) to see it
      '(
        (space-mark 32 [183] [46]) ; 32 SPACE, 183 MIDDLE DOT 「·」, 46 FULL STOP 「.」
        (newline-mark 10 [182 10]) ; 10 LINE FEED
        (tab-mark 9 [187 9] [9655 9] [92 9]) ; 9 TAB, 9655 WHITE RIGHT-POINTING TRIANGLE 「▷」
        ))
(setq whitespace-style '(face tabs trailing tab-mark))
(set-face-attribute 'whitespace-tab nil
                    :background "#f0f0f0"
                    :foreground "#00a8a8"
                    :weight 'bold)
(set-face-attribute 'whitespace-trailing nil
                    :background "#e4eeff"
                    :foreground "#183bc8"
                    :weight 'normal)
(add-hook 'prog-mode-hook 'whitespace-mode)

(defun rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))

(defun run-agent-install (arg)
  "Prompt user to enter a string, with input history support."
  (interactive (list (read-string "Ip address last octet: ")) )
  (async-shell-command
   (concat "/home/ryan/ripcord/spock/test/scripts/install-agent-demo.py 10.0.3." arg)))

(defun run-prov-demo (arg)
  "Prompt user to enter a string, with input history support."
  (interactive (list (read-string "Ip address last octet: ")) )
  (async-shell-command
   (concat "/home/ryan/ripcord/spock/test/scripts/node-install-demo.py 10.0.3." arg)))

(defun run-dse-demo ()
  "run the dse demo"
  (interactive)
  (async-shell-command "/home/ryan/bin/run-dse-test" "run-dse-test"))

(defun run-create-unmanaged ()
  "Prompt user to enter a string, with input history support."
  (interactive)
  (async-shell-command "/home/ryan/bin/run-create-unmanaged" "run-create-unmanaged"))

(defun unclutter-the-mouse (arg)
  "Prompt user to enter a string, with input history support."
  (interactive)
  (async-shell-command
   (concat "xdotool mousemove 1440 900")))

(defun run-lein-test ()
  (interactive)
  (async-shell-command "/home/ryan/bin/run-lein-test"
                       "run-lein-test"))

(defun run-lein-install-spock ()
  (interactive)
  (async-shell-command "/home/ryan/bin/lein-install-spock"
                       "*lein-install-spock*")
  (message "DONE"))

;; term stuff

(nyan-mode 1)
(setq nyan-wavy-trail nil)

(defun open-org-todo ()
  (interactive)
  (find-file "/home/ryan/grive/orgmode/work-todo.org"))

(defun open-standups-org ()
  (interactive)
  (find-file "/home/ryan/grive/orgmode/standups.org"))

(defun open-emacs-notes-org ()
  (interactive)
  (find-file "/home/ryan/grive/orgmode/emacs-notes.org"))

(defun open-magit-org ()
  (interactive)
  (find-file "/home/ryan/grive/orgmode/magit.org"))

(defun open-secondary-org-todo ()
  (interactive)
  (find-file "/home/ryan/grive/orgmode/secondary-work-todo.org"))

(defun dired-orgmode ()
  (interactive)
  (dired "/home/ryan/grive/orgmode"))

(defun open-org-for-current-jira ()
  (interactive)
  (find-file "/home/ryan/grive/orgmode/jiras/opsc-6988-spock-agent-install.org"))

(defun rs-clean-slate ()
  (interactive)
  (open-standups-org)
  (kill-other-buffers))

;;  Hotkeys

;; i want a backquote as a prefix key

;; this is for automated stuff
(define-prefix-command 'my-backquote-automation-keymap)

(define-prefix-command 'my-backquote-keymap)
(define-key my-backquote-keymap (vector ?`) 'my-insert-backquote)
(define-key my-backquote-keymap (vector ?!) 'open-org-for-current-jira)
(define-key my-backquote-keymap (vector ?$) 'open-standups-org)
(define-key my-backquote-keymap (vector ?^) 'grive-sync)
(define-key my-backquote-keymap (vector ?*) 'open-org-todo)
(define-key my-backquote-keymap (vector ?&) 'open-secondary-org-todo)
(define-key my-backquote-keymap (vector ?+) 'my-backquote-automation-keymap)

(define-key my-backquote-keymap (vector ?b) 'helm-buffers-list)
(define-key my-backquote-keymap (vector ?B) 'ibuffer)
(define-key my-backquote-keymap (vector ?9) 'edit-dot-emacs)
(define-key my-backquote-keymap (vector ?0) 'reload-dot-emacs)
(define-key my-backquote-keymap (kbd "-") 'toggle-truncate-lines)
(define-key my-backquote-keymap (vector ?u) 'cljr-find-usages)
(define-key my-backquote-keymap (vector ?i) 'helm-swoop)
(define-key my-backquote-keymap (vector ?o) 'dired-orgmode)
(define-key my-backquote-keymap (vector ?p) 'projectile-find-file)


(define-key my-backquote-keymap (vector ?f) 'find-file)
(define-key my-backquote-keymap (vector ?h) 'my-next-window)
(define-key my-backquote-keymap (vector ?j) 'my-next-window)
(define-key my-backquote-keymap (vector ?k) 'kill-this-buffer)
(define-key my-backquote-keymap (vector ?K) 'kill-this-buffer)
(define-key my-backquote-keymap (vector ?l) 'my-previous-window)

(define-key my-backquote-keymap (vector ?a) 'align-cljlet)
(define-key my-backquote-keymap (vector ?d) 'indent-defun)
(define-key my-backquote-keymap (vector ?x) 'helm-M-x)

(define-key my-backquote-keymap (vector ?,) 'rename-buffer)
(define-key my-backquote-keymap (vector ?/) 'helm-projectile-ag)
(define-key my-backquote-keymap (vector ?=) 'open-org-todo)
(define-key my-backquote-keymap (vector ?.) 'dot-emacs-sync)

(define-key my-backquote-keymap (kbd ";") 'avy-goto-char)
(define-key my-backquote-keymap (kbd "'") 'avy-goto-char-2)
(define-key my-backquote-keymap (kbd "\"") 'avy-goto-char-2)
(define-key my-backquote-keymap (kbd "<up>") 'enlarge-window)
(define-key my-backquote-keymap (kbd "<down>") 'shrink-window)
(define-key my-backquote-keymap (kbd "<left>") 'shrink-window-horizontally)
(define-key my-backquote-keymap (kbd "<right>") 'enlarge-window-horizontally)

(defun my-insert-backquote ()
  (interactive)
  (insert "`"))

(defun my-insert-quote ()
  (interactive)
  (insert "'"))

(define-key evil-normal-state-map (kbd "<kp-add>") 'my-backquote-automation-keymap)
(define-key evil-normal-state-map (kbd "C-p") 'projectile-find-file)

(define-key evil-normal-state-map (kbd "C-l") 'helm-buffers-list)
(define-key evil-insert-state-map (kbd "C-l") 'helm-buffers-list)

(define-key evil-normal-state-map (kbd "`") 'my-backquote-keymap)
(define-key evil-insert-state-map (kbd "`") 'my-backquote-keymap)
(define-key evil-insert-state-map (kbd "C-j") 'evil-normal-state)
(define-key evil-emacs-state-map (kbd "`") 'my-backquote-keymap)
(define-key ibuffer-mode-map (kbd "`") 'my-backquote-keymap)

(define-key evil-normal-state-map (kbd "M-.") 'cider-find-var)

;; keep dired up to date

;; Auto refresh buffers
(global-auto-revert-mode 1)

;; Also auto refresh dired, but be quiet about it
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

;; it looks like 3 relevant helms are
;;
;; helm-mini
;; helm-buffers-list

;; this one is for finding new files
;; helm-find-files

(evil-leader/set-key
  "!" 'open-org-for-current-jira
  "$" 'open-standups-org
  "^" 'grive-sync
  "*" 'open-org-todo
  "&" 'open-secondary-org-todo

  "-" 'toggle-truncate-lines ;; back and forth from word wrap
  "=" 'open-org-todo

  "s" 'save-buffer
  "d" 'indent-defun
  "f" 'find-file

  "o" 'dired-orgmode
  "p" 'projectile-find-file

  "<tab>" 'helm-keyboard-quit
  "x" 'helm-M-x

  "u" 'cljr-find-usages
  "i" 'helm-swoop
  "b" 'helm-buffers-list
  "B" 'ibuffer

  "a" 'align-cljlet

  "h" 'previous-buffer
  "k" 'kill-this-buffer
  "l" 'next-buffer
  ";" 'avy-goto-char
  "'" 'avy-goto-char-2
  "\"" 'avy-goto-char

  "9" 'edit-dot-emacs
  "0" 'reload-dot-emacs

  "," 'open-emacs-notes-org
  "." 'dot-emacs-sync
  "/" 'helm-projectile-ag

  "<up>"     'shrink-window
  "<down>"   'enlarge-window
  "<left>"   'shrink-window-horizontally
  "<right>"  'enlarge-window-horizontally
  )

(global-set-key (kbd "C-SPC") 'evil-escape)
(global-set-key (kbd "C-<f9>") 'text-scale-decrease)
(global-set-key (kbd "C-<f10>") 'text-scale-increase)
(global-set-key (kbd "<kp-subtract>") 'text-scale-decrease)
(global-set-key (kbd "<kp-add>") 'my-backquote-automation-keymap)

;;(define-key evil-insert-state-map   (kbd "'") #'evil-escape)
;;(define-key evil-insert-state-map   (kbd "C-'") #'my-insert-quote)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (general cider js3-mode bm helm-swoop ox-rst aggressive-indent helm-descbinds yaml-mode rainbow-delimiters nyan-mode helm-projectile helm-ag evil-snipe evil-leader evil-escape evil-avy cyberpunk-theme clj-refactor))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
