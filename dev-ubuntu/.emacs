;; TO DO
;;
;;    evil + lispy + paredit
;;    get more into cider
;;    get more into clj refactor
;;    https://www.reddit.com/r/emacs/comments/3hvx2l/as_an_evil_user_should_i_learn_paredit_or_lispy/
;;
;; Package stuff
;;
;;
;; cool quote from the arcanesentiment blog:
;;
;;   When I feel stupid or ignorant, I study to become less so, but when I feel wise, I do nothing.

(require 'cl) ;; needed for loop

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
;; had a funky cert problem
;;(add-to-list 'package-archives
;;             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

;; to check out: gnugol, abbrev mode, org mode

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
    evil-snipe
    ;;    evil-surround
    aggressive-indent
    projectile
    helm-projectile
    helm-ag
    hydra
    helm-swoop
    cider
    clj-refactor
    lispy
    ;;    magit
    smartparens
    evil-cleverparens
    ;;    evil-smartparens
    rainbow-delimiters
    rainbow-identifiers
    ace-window
    ;;    persp-mode
    workgroups2
    nyan-mode
    yasnippet
    clojure-snippets
    ) "a list of packages to ensure are installed at launch.")

; method to check if all packages are installed
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

;; (setq-default cursor-type 'bar)
(setq evil-insert-state-cursor '((bar . 5) "purple")
      evil-normal-state-cursor '((bar . 5) "green"))
;; evil-normal-state-cursor '(box "purple"))

(blink-cursor-mode -1)

;; exw`m

;;(require 'exwm)
;;(require 'exwm-config)
;;(exwm-config-default)

;; workgroups2

(require 'workgroups2)
(workgroups-mode 1)

;; evil

(require 'evil)
(require 'evil-leader)

(evil-leader/set-leader "<SPC>")
(setq evil-leader/in-all-states t)
;; enable evil-leader before enabling evil
(global-evil-leader-mode)
(evil-mode 1)

;;(set-default-font "Monospace-16")
;;(set-default-font "DejaVu Sans Mono 13")
(set-default-font "DejaVu Sans Mono 14")
;;(set-default-font "DejaVu Sans Mono 15")
;; (set-default-font "DejaVu Sans Mono 12")
;; (set-default-font "DejaVu Sans Mono 10")
;; (set-default-font "DejaVu Sans Mono 9")
;; (set-default-font "DejaVu Sans Mono 8")

;; This will cause dired to default to Normal mode

;; (setq evil-normal-state-modes (append evil-motion-state-modes evil-normal-state-modes))
(setq evil-motion-state-modes nil)

;; (evil-escape-mode 1)
(evil-escape-mode 0)

;;(setq-default evil-escape-delay 0.2)
;;(setq-default evil-escape-delay 2.0)
;; give me a couple of minutes to decide if i want to exit insert mode... heh
(setq-default evil-escape-delay 120.0)

;; (setq-default evil-escape-key-sequence "fj")
(setq-default evil-escape-key-sequence "M-<SPC>")
                                        ;(setq-default evil-escape-key-sequence "jk")
(setq evil-escape-unordered-key-sequence 1)

;; evil-search-highlight-persist

(require 'highlight)
(require 'evil-search-highlight-persist)
(global-evil-search-highlight-persist t)

;; To only display string whose length is greater than or equal to 3
;; (setq evil-search-highlight-string-min-len 3)

;; which key

(require 'which-key)
(which-key-mode)

(require 'clj-refactor)
(add-hook 'clojure-mode-hook (lambda ()
                               (clj-refactor-mode 1)
                               ;;(yas-minor-mode 1) ; for adding require/use/import
                               ;; insert keybinding setup here
			       ;; (cljr-add-keybindings-with-prefix "C-c C-m")
                               ;; eg. rename files with `C-c C-m rf`.
                               ))

;; include underscore as a word character for evil for * searches

(add-hook 'clojure-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))
(add-hook 'js-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))
(add-hook 'python-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))
(evil-set-initial-state 'ibuffer-mode 'normal)

;; zone

(require 'zone-nyan)
(setq zone-programs [zone-nyan])

;; evil-snipe

(require 'evil-snipe)
(evil-snipe-mode 1)

;; OPTIONAL: Replaces evil-mode's f/F/t/T motions with evil-snipe
;;(evil-snipe-override-mode 1)

;; aggresive-indent

(add-hook 'emacs-lisp-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode nil)
            ))

;; (add-hook 'clojure-mode-hook #'aggressive-indent-mode)
(global-aggressive-indent-mode)

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

;; avy

(require 'evil-avy)

(evil-avy-mode 1)

(require 'ace-window)

(setq aw-dispatch-always t)

;; evil-surround
;;(require 'evil-surround)
;;(global-evil-surround-mode 1)

;; (require 'key-leap)

;; projectile
(require 'projectile)

(projectile-global-mode)
(projectile-mode 1)

(projectile-add-known-project "/home/vagrant/ripcord/spock")

;;

(global-visual-line-mode 1)

;;

(require 'smartparens)
(require 'smartparens-config)
;;(smartparens-global-mode 1)
;;(add-hook 'smartparens-enabled-hook #'evil-smartparens-mode)

;; evil smartparens looks very minimal

;; evil cleverparens
;; this is a win, now x on a delimeter deletes both delimiters
;; however it messes up double quote stuff fairly badly
;; (require 'evil-cleverparens)
;; (setq evil-move-beyond-eol t)
;; (add-hook 'emacs-lisp-mode-hook #'evil-cleverparens-mode)
;; (add-hook 'clojure-mode-hook #'evil-cleverparens-mode)

;; lispy

(require 'lispy)
;; Note: lispy is active in insert mode in evil
;;(add-hook 'clojure-mode-hook (lambda () (lispy-mode 1)))
;;(add-hook 'emacs-lisp-mode-hook (lambda () (lispy-mode 1)))

;; make lispy use the normal undo tree stuff
(lispy-define-key lispy-mode-map "u" 'undo-tree-undo)
;; lispy keybinds are >>> than paredit
;; for instance, [ is bound to lispy-backwards in lispy
;; but it inserts the square bracket in the paredit emulation mode
(lispy-set-key-theme '(special lispy c-digits))
;; (lispy-set-key-theme '(paredit))

;; rainbow delimiters

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook #'rainbow-identifiers-mode)

(defvar xah-right-brackets nil "list of close bracket chars.")
(setq xah-right-brackets '("\)" "]" "}" ">" "〕" "】" "〗" "〉" "》" "」" "』" "”" "’" "›" "»" "\"" "\'" ":"))

(defun xah-forward-right-bracket ()
  "Move cursor to the next occurrence of right bracket.
    The list of brackets to jump to is defined by xah-right-brackets."
  (interactive)
  (search-forward-regexp (eval-when-compile (regexp-opt xah-right-brackets)) nil t))

;; yasnippet

(require 'yasnippet)
(require 'clojure-snippets)
(yas-global-mode 1)
(add-to-list 'yas-snippet-dirs "~/.emacs.d/snippets")
(yas-load-directory "~/.emacs.d/snippets")
(define-key yas-minor-mode-map (kbd "<tab>") nil)
(define-key yas-minor-mode-map (kbd "TAB") nil)
(define-key yas-minor-mode-map (kbd "C-]") 'yas-expand)
(define-key yas-minor-mode-map (kbd "M-]") 'yas-expand)

;; helm

(add-to-list 'load-path "/home/vagrant/emacs-async")
(add-to-list 'load-path "/home/vagrant/helm")
(add-to-list 'load-path "/home/vagrant/.emacs.d/fireplace")

(require 'fireplace)

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
      helm-locate-fuzzy-match    t
      helm-apropos-fuzzy-match    t
      helm-lisp-fuzzy-completion    t
      helm-imenu-fuzzy-match    t)

(add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)

(require 'helm-descbinds)

(global-set-key (kbd "C-h b") 'helm-descbinds)

(require 'helm-eshell)
(add-hook 'eshell-mode-hook
	  #'(lambda () (define-key eshell-mode-map (kbd "C-c C-l") 'helm-eshell-history)))

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

;; align cljlet

(require 'align-cljlet)  

;; rst mode

(require 'rst)


;; magit

;;(require 'magit)

;; cider

(setq cider-prompt-for-symbol nil)

;; indent a defun

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

;; backup files

(setq make-backup-files nil)

;; no lock files either

(setq create-lockfiles nil)

;; No tabs! - spaces only

(setq tab-width 4)
(setq indent-tabs-mode nil)

;; No bell at all

(setq ring-bell-function 'ignore)

;;(load-theme 'afternoon t)
;;(disable-theme 'autumn-light t)
(load-theme 'cyberpunk t)

;; disable the tool bar
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Turn off auto-saves

(setq auto-save-default nil)

;; Turn off backups

(setq backup-inhibited t)
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

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

(add-hook 'clojure-mode-hook (lambda ()
                               (linum-mode 1)))
(add-hook 'python-mode-hook (lambda () (linum-mode 1)))

;; todo, rebind ` in ibuffer
;;(add-hook 'ibuffer-mode-hook
;;          (lambda ()
;;            (define-key 1)))


;; change mode-line color by evil state
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

(require 'hydra)

(defhydra hydra-yank-pop ()
  "yank"
  ("C-y" yank nil)
  ("M-y" yank-pop nil)
  ("y" (yank-pop 1) "next")
  ("Y" (yank-pop -1) "prev")
  ("l" helm-show-kill-ring "list" :color blue))

(global-set-key (kbd "C-y") #'hydra-yank-pop/yank)
(global-set-key (kbd "M-y") #'hydra-pank-pop/yank-pop)

(defhydra hydra-workgroups ()
  "Workgroups:
   c create    k kill     s save
   , rename    r reload
   z switch    f load"
  ("c" wg-create-workgroup)
  ("," wg-rename-workgroup)
  ("z" wg-switch-to-workgroup)
  ("k" wg-kill-workgroup)
  ("r" wg-reload-session)
  ("f" wg-load-session)
  ("s" wg-save-session))

;; (global-set-key (kbd "C-)") 'hydra-workgroups/body)

;; <prefix> c    - create workgroup
;; <prefix> A    - rename workgroup
;; <prefix> k    - kill workgroup
;; <prefix> v    - switch to workgroup
;; <prefix> C-s  - save session
;; <prefix> C-f  - load session

;; my hybrid mode

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

(setq org-directory "/home/vagrant/grive/orgmode")
:

;;(add-to-list 'auto-mode-alist '("\\.org.txt\\'" . org-mode))

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

;; do not prompt when executing code

(setq org-confirm-babel-evaluate nil)

;; active Babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((sh . t)
   (emacs-lisp . t)
   ))



;; keep all the org files in the agenda

(defun org-add-eventually()
  "Adding a file to org-agenda when saved"
  (interactive)
  (if (string= major-mode "org-mode")
      (org-agenda-file-to-front)))

(add-hook 'before-save-hook 'org-add-eventually)

(defun subtree-to-new-file ()
  (interactive)
  "sloppily assists in moving an org subtree to a new file"
  (org-copy-subtree nil t)
;;; This long setq statement gets the title of the first heading, to use as a default filename for the new .org file.
(setq first-heading
  (with-temp-buffer
    (yank)
    (beginning-of-buffer)
    (search-forward " " nil nil 1)
    (setq title-start (point))
    (end-of-visual-line)
    (setq title-end (point))
    (setq first-heading (buffer-substring title-start title-end))
  ))
(setq def-filename (concat first-heading ".org"))
(let ((insert-default-directory t))
  (find-file-other-window  
    (read-file-name "Move subtree to file:" def-filename)
  ))
(org-paste-subtree)
;;; this final command adds the new .org file to the agenda
(org-agenda-file-to-front)
)

(setq org-refile-targets '((nil :maxlevel . 2)
                                ; all top-level headlines in the
                                ; current buffer are used (first) as a
                                ; refile target
                           (org-agenda-files :maxlevel . 2)))

;; provide refile targets as paths, including the file name
;; (without directory) as level 1 of the path
(setq org-refile-use-outline-path 'file)

;; allow to create new nodes (must be confirmed by the user) as
;; refile targets
(setq org-refile-allow-creating-parent-nodes 'confirm)

(defun grive-sync ()
  (interactive)
  (async-shell-command "cd ~/grive && grive"))

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

;; ediff stuff

;;(csetq ediff-window-setup-function 'ediff-setup-windows-plain)
;;(csetq ediff-split-window-function 'split-window-horizontally)

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

;; (defadvice ibuffer (after collapse-helm)
;;   (dolist (group mp/ibuffer-collapsed-groups)
;; 	  (progn
;; 	    (goto-char 1)
;; 	    (when (search-forward (concat "[ " group " ]") (point-max) t)
;; 	      (progn
;; 		(move-beginning-of-line nil)
;; 		(ibuffer-toggle-filter-group)
;; 		)
;; 	      )
;; 	    )
;; 	  )
;;     (goto-char 1)
;;     (search-forward "[ " (point-max) t)
;;   )

;; (ad-activate 'ibuffer)

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
   (concat "/home/vagrant/ripcord/spock/test/scripts/install-agent-demo.py 10.0.3." arg)))

(defun run-prov-demo (arg)
  "Prompt user to enter a string, with input history support."
  (interactive (list (read-string "Ip address last octet: ")) )
  (async-shell-command
   (concat "/home/vagrant/ripcord/spock/test/scripts/node-install-demo.py 10.0.3." arg)))

(defun run-dse-demo ()
  "run the dse demo"
  (interactive)
  (async-shell-command "/home/vagrant/bin/run-dse-test" "run-dse-test"))

(defun run-create-unmanaged ()
  "Prompt user to enter a string, with input history support."
  (interactive)
  (async-shell-command "/home/vagrant/bin/run-create-unmanaged" "run-create-unmanaged"))

(defun ttt ()
  (interactive)
  ;; (let (last-octet (shell-command-to-string "sudo lxc-ls --fancy | grep ubu | grep RUN | tr -s ' ' | cut -d ' ' -f 3 | cut -d '.' -f 4"))

  (let (last-octet (shell-command-to-string "whoami"))
    (message "ttt")
    (message last-octet)))

(defun unclutter-the-mouse (arg)
  "Prompt user to enter a string, with input history support."
  (interactive)
  (async-shell-command
   (concat "xdotool mousemove 1440 900")))

;; (defun ssh-ubu (arg)
;;   "Prompt user to enter a string, with input history support."
;;   (interactive (list (read-string "Ip address last octet:")) )
;;   (async-shell-command
;;    (concat "ssh ubuntu@10.0.3." arg)))

(defun run-lein-test ()
  (interactive)
  (async-shell-command "/home/vagrant/bin/run-lein-test"
                       "run-lein-test"))

(defun run-lein-install-spock ()
  (interactive)
  (async-shell-command "/home/vagrant/bin/lein-install-spock"
                       "*lein-install-spock*")
  (message "DONE"))

;; dizzee stuff

(require 'dizzee)

(dz-defservice my-opscenter "refresh-opsc"
               :args ()
               :cd "/home/vagrant/ripcord/opscenterd")

;;(dz-defservice my-spockd "run-spock
;;:args ()
;;:cd "/home/vagrant/ripcord/spock")

(dz-defservice my-refresh-ubu "run-refresh-ubu"
               :args ()
               :cd "/home/vagrant/ripcord/spock")

;;(dz-defservice-group my-spock (my-spockd my-refresh-ubu))
;;(dz-defservice-group my-ospock (my-opscenter my-refresh-ubu))
(dz-defservice-group my-ospock (my-opscenter))

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

(nyan-mode 1)
(setq nyan-wavy-trail nil)

(defun open-org-todo ()
  (interactive)
  (find-file "/home/vagrant/grive/orgmode/work-todo.org"))

(defun open-standups-org ()
  (interactive)
  (find-file "/home/vagrant/grive/orgmode/standups.org"))

(defun open-emacs-notes-org ()
  (interactive)
  (find-file "/home/vagrant/grive/orgmode/emacs-notes.org"))

(defun open-magit-org ()
  (interactive)
  (find-file "/home/vagrant/grive/orgmode/magit.org"))

(defun open-secondary-org-todo ()
  (interactive)
  (find-file "/home/vagrant/grive/orgmode/secondary-work-todo.org"))

(defun dired-orgmode ()
  (interactive)
  (dired "/home/vagrant/grive/orgmode"))

(defun open-org-for-current-jira ()
  (interactive)
  (find-file "/home/vagrant/grive/orgmode/jiras/opsc-6988-spock-agent-install.org"))

(defun rs-clean-slate ()
  (interactive)
  (open-standups-org)
  (kill-other-buffers))

;;  Hotkeys

;; i want a backquote as a prefix key

;; this is for automated stuff
(define-prefix-command 'my-backquote-automation-keymap)
(define-key my-backquote-automation-keymap (vector ?+) 'run-lein-test)
(define-key my-backquote-automation-keymap (vector ?1) 'my-refresh-ubu-restart)
(define-key my-backquote-automation-keymap (vector ?2) 'my-ospock-restart)
(define-key my-backquote-automation-keymap (vector ?3) 'run-create-unmanaged)
(define-key my-backquote-automation-keymap (vector ?4) 'run-dse-demo)
(define-key my-backquote-automation-keymap (vector ?5) 'my-opscenter-restart)
                                        ;(define-key my-backquote-automation-keymap (vector ?6) 'my-spock-restart)
(define-key my-backquote-automation-keymap (vector ?0) 'run-lein-install-spock)

(define-prefix-command 'my-backquote-keymap)
(define-key my-backquote-keymap (vector ?`) 'my-insert-backquote)
(define-key my-backquote-keymap (vector ?!) 'open-org-for-current-jira)
(define-key my-backquote-keymap (vector ?$) 'open-standups-org)
(define-key my-backquote-keymap (vector ?^) 'grive-sync)
(define-key my-backquote-keymap (vector ?*) 'open-org-todo)
(define-key my-backquote-keymap (vector ?&) 'open-secondary-org-todo)
(define-key my-backquote-keymap (vector ?+) 'my-backquote-automation-keymap)
(define-key my-backquote-keymap (vector ?q) 'rs-term-exit-scroll-mode)
(define-key my-backquote-keymap (vector ?Q) 'rs-term-enter-scroll-mode)

(define-key my-backquote-keymap (vector ?w) 'ace-window)
(define-key my-backquote-keymap (vector ?t) 'my-terminal-mode)
(define-key my-backquote-keymap (vector ?y) 'my-term-paste)
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
(define-key my-backquote-keymap (vector ?g) 'magit-status)
;;(define-key my-backquote-keymap (vector ?h) 'previous-buffer)
(define-key my-backquote-keymap (vector ?h) 'my-next-window)
;;(define-key my-backquote-keymap (vector ?j) 'my-next-window)
(define-key my-backquote-keymap (vector ?j) 'my-next-window)
(define-key my-backquote-keymap (vector ?k) 'my-previous-window)
(define-key my-backquote-keymap (vector ?K) 'kill-this-buffer)
;;(define-key my-backquote-keymap (vector ?k) 'my-previous-window)
;;(define-key my-backquote-keymap (vector ?l) 'next-buffer)
(define-key my-backquote-keymap (vector ?l) 'my-previous-window)

(define-key my-backquote-keymap (vector ?z) 'hydra-workgroups/body)
(define-key my-backquote-keymap (vector ?c) 'rs-capture-task)
(define-key my-backquote-keymap (vector ?a) 'align-cljlet)
(define-key my-backquote-keymap (vector ?s) 'split-window-below)
(define-key my-backquote-keymap (vector ?d) 'indent-defun)
(define-key my-backquote-keymap (vector ?v) 'split-window-right)
(define-key my-backquote-keymap (vector ?x) 'helm-M-x)
(define-key my-backquote-keymap (vector ?M) 'open-magit-org)

(define-key my-backquote-keymap (vector ?,) 'rename-buffer)
(define-key my-backquote-keymap (vector ?/) 'helm-projectile-ag)
(define-key my-backquote-keymap (vector ?=) 'open-org-todo)
(define-key my-backquote-keymap (vector ?.) 'dot-emacs-sync)

(define-key my-backquote-keymap (kbd ";") 'avy-goto-char)
(define-key my-backquote-keymap (kbd "'") 'avy-goto-char-2)
(define-key my-backquote-keymap (kbd "\"") 'avy-goto-char-2)
(define-key my-backquote-keymap (kbd "SPC") 'other-window)
(define-key my-backquote-keymap (kbd "<up>") 'enlarge-window)
(define-key my-backquote-keymap (kbd "<down>") 'shrink-window)
(define-key my-backquote-keymap (kbd "<left>") 'shrink-window-horizontally)
(define-key my-backquote-keymap (kbd "<right>") 'enlarge-window-horizontally)

(defun my-insert-backquote ()
  (interactive)
  (insert "`"))

(define-key evil-normal-state-map (kbd "<kp-add>") 'my-backquote-automation-keymap)
(define-key evil-normal-state-map (kbd "M-1") 'delete-other-windows)
(define-key evil-normal-state-map (kbd "C-p") 'projectile-find-file)

(define-key evil-normal-state-map (kbd "C-o") 'other-window)
(define-key evil-insert-state-map (kbd "C-o") 'other-window)

(define-key evil-normal-state-map (kbd "C-l") 'helm-buffers-list)
(define-key evil-insert-state-map (kbd "C-l") 'helm-buffers-list)

(define-key evil-normal-state-map (kbd "`") 'my-backquote-keymap)
(define-key evil-insert-state-map (kbd "`") 'my-backquote-keymap)
(define-key evil-insert-state-map (kbd "C-l") 'xah-forward-right-bracket)
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
  "`" 'other-window
  "!" 'open-org-for-current-jira
  "$" 'open-standups-org
  "^" 'grive-sync
  "*" 'open-org-todo
  "&" 'open-secondary-org-todo

  ")" 'open-standups-org

  "-" 'toggle-truncate-lines ;; back and forth from word wrap
  "=" 'open-org-todo
  "w" 'ace-window
  "e" 'eshell
  "t" 'my-terminal-mode

  "s" 'save-buffer
  ;;"d" 'cider-doc
  "d" 'indent-defun
  ;;  "f" 'helm-find-files
  "f" 'find-file
  "g" 'magit-status

  "o" 'dired-orgmode
  "p" 'projectile-find-file
  ;;  "]" 'helm-buffers-list

  "<tab>" 'helm-keyboard-quit
  ;; "z" 'wg-switch-to-workgroup
  "z" 'hydra-workgroups/body
  "x" 'helm-M-x

  "u" 'cljr-find-usages
  "i" 'helm-swoop
  "b" 'helm-buffers-list
  "B" 'ibuffer
  ;;  "i" 'helm-buffers-list

  "a" 'align-cljlet

  "h" 'previous-buffer
  "j" 'my-next-window
  "k" 'my-previous-window
  "K" 'kill-this-buffer
  "l" 'next-buffer
  "M" 'open-magit-org
  ";" 'avy-goto-char
  "'" 'avy-goto-char-2
  "\"" 'avy-goto-char

  "c" 'rs-capture-task

  "3" 'my-previous-window
  "4" 'my-next-window
  "5" 'new-frame

  "9" 'edit-dot-emacs
  "0" 'reload-dot-emacs

  "[" 'split-window-below
  "]" 'split-window-right

  "," 'open-emacs-notes-org
  "." 'dot-emacs-sync
  "/" 'helm-projectile-ag

  "<up>"     'shrink-window
  "<down>"   'enlarge-window
  "<left>"   'shrink-window-horizontally
  "<right>"  'enlarge-window-horizontally
  )

(global-set-key (kbd "<f4>") 'evil-search-highlight-persist-remove-all)

;; some org-mode stuff for evil

;; (define-key evil-normal-state-map (kbd "]a") 'org-insert-heading)
;; (define-key evil-normal-state-map (kbd "]h") 'org-metaright)
;; (define-key evil-normal-state-map (kbd "[h") 'org-metaleft)
;; (define-key evil-normal-state-map (kbd "]j") 'org-metadown)
;; (define-key evil-normal-state-map (kbd "[j") 'org-metaup)
;; (define-key evil-normal-state-map (kbd "]k") 'outline-demote)
;; (define-key evil-normal-state-map (kbd "[k") 'outline-promote)
;; (define-key evil-normal-state-map (kbd "]o") 'outline-next-visible-heading)
;; (define-key evil-normal-state-map (kbd "[o") 'outline-previous-visible-heading)
;; (define-key evil-normal-state-map (kbd "]t") 'outline-forward-same-level)
;; (define-key evil-normal-state-map (kbd "[t") 'outline-backward-same-level)
;; (define-key evil-normal-state-map (kbd "]b") 'org-next-block)
;; (define-key evil-normal-state-map (kbd "[b") 'org-previous-block)
;; (define-key evil-normal-state-map (kbd "]r") 'org-table-move-row-down)
;; (define-key evil-normal-state-map (kbd "[r") 'org-table-move-row-up)
;; (define-key evil-normal-state-map (kbd "]c") 'org-table-move-column-right)
;; (define-key evil-normal-state-map (kbd "[c") 'org-table-move-column-left)
;; (define-key evil-normal-state-map (kbd "]f") 'org-table-next-field)
;; (define-key evil-normal-state-map (kbd "[f") 'org-table-previous-field)
;; (define-key evil-normal-state-map (kbd "]l") 'org-next-link)
;; (define-key evil-normal-state-map (kbd "[l") 'org-previous-link)
;; (define-key evil-normal-state-map (kbd "]u") 'org-down-element)
;; (define-key evil-normal-state-map (kbd "[u") 'org-up-element)

(global-set-key (kbd "M-SPC") 'evil-escape)
(global-set-key (kbd "M-\\") 'wg-switch-to-workgroup-right)
(global-set-key (kbd "<kp-subtract>") 'text-scale-decrease)
(global-set-key (kbd "<kp-add>") 'my-backquote-automation-keymap)

;;(setq cljr--debug-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   (quote
    ("~/grive/orgmode/standups.org" "~/grive/orgmode/spock-api-common.org" "~/grive/orgmode/clojure-macros.org" "~/grive/orgmode/debug-ctn.org" "~/grive/orgmode/openstack.org" "~/grive/orgmode/keyboards.org" "~/grive/orgmode/spock-cacerts.org" "~/grive/orgmode/eap.org" "~/grive/orgmode/keytool.org" "~/grive/orgmode/jython.org" "~/grive/orgmode/spock-opscd.org" "~/grive/orgmode/debugging.org" "~/grive/orgmode/wireshark.org" "~/grive/orgmode/clojure-java-interop.org" "~/grive/orgmode/cloud-usage.org" "~/grive/orgmode/ssl.org" "~/grive/orgmode/opscd.org" "~/grive/orgmode/clojure.org" "~/grive/orgmode/jenkins.org" "~/grive/orgmode/spock-cluster-import.org" "~/grive/orgmode/notes.org" "~/grive/orgmode/lein.org" "~/grive/orgmode/intellij.org" "~/grive/orgmode/aws-spock.org" "~/grive/orgmode/ctool.org" "~/grive/orgmode/squid.org" "~/grive/orgmode/centos.org" "~/grive/orgmode/java-aot.org" "~/grive/orgmode/meld.org" "~/grive/orgmode/ergo-stuff.org" "~/grive/orgmode/python-logging.org" "~/grive/orgmode/git.org" "~/grive/orgmode/strace.org" "~/grive/orgmode/lxc.org" "~/grive/orgmode/magit.org" "~/grive/orgmode/yasnippet.org" "~/grive/orgmode/emacs-usage.org" "~/grive/orgmode/jar-resources.org" "~/grive/orgmode/work-todo.org" "~/grive/orgmode/lisphaskell.org" "~/grive/orgmode/spock-timeouts.org" "~/grive/orgmode/jiras/opsc-6738-run-wo-port.org" "~/grive/orgmode/java-exceptions.org" "~/grive/orgmode/music.org" "~/grive/orgmode/window-manager.org" "~/grive/orgmode/apt-caching.org" "~/grive/orgmode/fonts.org" "~/grive/orgmode/jira-work-process.org" "~/grive/orgmode/jiras/opsc-7362-spock-loves-dse-5.org" "~/grive/orgmode/jiras/opsc-7306-uber-create-cluster.org" "~/grive/orgmode/workgroups.org" "~/grive/orgmode/jiras/opsc-7245-agent-install.org" "~/grive/orgmode/component.org" "~/grive/orgmode/emacs-clojure.org" "~/grive/orgmode/jiras/opsc-6988-spock-agent-install.org" "~/grive/orgmode/emacs-notes.org" "~/grive/orgmode/secondary-work-todo.org")))
 '(package-selected-packages
   (quote
    (helm-swoop magit clojure-snippets yasnippet key-leap zone-nyan dizzee exwm ox-rst hydra aggressive-indent which-key evil-search-highlight-persist evil-smartparens helm-descbinds smartparens lispy evil-surround yaml-mode workgroups2 rainbow-identifiers rainbow-delimiters persp-mode nyan-mode helm-projectile helm-ag focus evil-snipe evil-leader evil-escape evil-cleverparens evil-avy esxml cyberpunk-theme clj-refactor autumn-light-theme afternoon-theme ace-window))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-search-highlight-persist-highlight-face ((t (:background "blue4")))))
