;;; Geneneral Setting

;;;; load all the icons
(all-the-icons-install-fonts t)
;;;; modus theme
(add-to-list 'load-path "~/.emacs.d/modus-themes")
(add-to-list 'load-path "~/.emacs.d/custom")
(require 'modus-themes)
;; Load the theme files before enabling a theme (else you get an error).
(modus-themes-load-themes)
(modus-themes-load-vivendi)             ; Dark theme

;; Theme settings
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

;; (use-package spaceline :ensure t
;;   :config
;;   (setq-default mode-line-format '("%e" (:eval (spaceline-ml-main)))))

;; (use-package spaceline-config :ensure spaceline
;;   :config
;;   (spaceline-helm-mode 1)
;;   (spaceline-emacs-theme))
;;;; expand region
(require 'expand-region)
(global-set-key (kbd "s-=") 'er/expand-region)
;;;; font size
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "M-=") 'text-scale-decrease)
            
;;;; line num
(require 'display-line-numbers)
(defcustom display-line-numbers-exempt-modes '(vterm-mode eshell-mode shell-mode term-mode ansi-term-mode)
  "Major modes on which to disable the linum mode, exempts them from global requirement"
  :group 'display-line-numbers
  :type 'list
  :version "green")

(defun display-line-numbers--turn-on ()
  "turn on line numbers but excempting certain majore modes defined in `display-line-numbers-exempt-modes'"
  (if (and
       (not (member major-mode display-line-numbers-exempt-modes))
       (not (minibufferp)))
      (display-line-numbers-mode)))

(global-display-line-numbers-mode)
;;;; start up msg repress
(tool-bar-mode -1)
(toggle-scroll-bar -1)
(setq inhibit-startup-screen t)  
(setq make-backup-files nil) ; stop creating ~ files
(setq warning-minimum-level :error)
;;;; line effects
(global-hl-line-mode t) ;; This highlights the current line in the buffer
(use-package beacon ;; This applies a beacon effect to the highlighted line
  :ensure t
  :config
  (beacon-mode 1))
; (global-hl-mode +1)
;;;; ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)
;;;; projectile 
(require 'projectile)
(projectile-mode +1)
;; (setq projectile-project-search-path '("~/projects/" "~/work/" "~/tmp"))
(setq projectile-project-search-path '("~/tmp"))
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
;;;; move buffer to frame
(defun ky-switch-current-window-into-frame ()
  (interactive)
  (let ((buffer (current-buffer)))
    (unless (one-window-p)
      (delete-window))
    (display-buffer-pop-up-frame buffer nil)))
;;;; display “lambda” as “λ”
(global-prettify-symbols-mode 1)
(setq prettify-symbols-alist '(("lambda" . 955)))
;;;; enable drag and drop
(setq mouse-drag-and-drop-region t)
(setq mouse-drag-and-drop-region-cut-when-buffers-differ t)
;;;; remap kill buffer and window
(global-set-key (kbd "C-k") 'kill-buffer-and-window)
            
;;;; remap other frame and window command
(global-set-key (kbd "M-o") 'other-window)
;;;; highlighting and region
(set-face-background 'hl-line "#3e4446")
(set-face-foreground 'highlight nil)
;; (set-face-attribute 'region nil :background "#666" :foreground "#ffffff")
(set-face-attribute 'region nil :background "MediumBlue" :foreground "#ffffff")
;;;; increase minibuffer font size
(defun increase-minibuffer-font-size ()
       (set (make-local-variable 'face-remapping-alist)
          '((default :height 1.5))))

(add-hook 'minibuffer-setup-hook 'increase-minibuffer-font-size)

;;; Outline Mode
;; Require packages for following code
(require 'dash)
(require 'outshine)
(require 'prog-mode)
;; (use-package prog-mode
;;   :config
;;  (add-hook 'prog-mode-hook 'outline-minor-mode)
;;  (add-hook 'prog-mode-hook 'hs-minor-mode))
;; Enables outline-minor-mode for *ALL* programming buffers
(add-hook 'prog-mode-hook 'outline-minor-mode)
(add-hook 'prog-mode-hook 'hs-minor-mode))

;; Required for outshine
(add-hook 'outline-minor-mode-hook 'outshine-hook-function)


(use-package outline-minor-faces
  :after outline
  :config (add-hook 'outline-minor-mode-hook
                    'outline-minor-faces-add-font-lock-keywords))

;; Narrowing now works within the headline rather than requiring to be on it
(advice-add 'outshine-narrow-to-subtree :before
            (lambda (&rest args) (unless (outline-on-heading-p t)
                                   (outline-previous-visible-heading 1))))

(setq my-black "#1b1b1e")
(custom-theme-set-faces
 'modus-vivendi
 `(outline-1 ((t (:height 1.25 :background "#268bd2"
                          :foreground ,my-black :weight bold))))
 `(outline-2 ((t (:height 1.15 :background "#2aa198"
                          :foreground ,my-black :weight bold))))
 `(outline-3 ((t (:height 1.05 :background "#b58900"
                          :foreground ,my-black :weight bold)))))


;;;; outline within dockerfile
(add-hook 'dockerfile-mode-hook
  (lambda ()
    (setq outline-regexp "##[#]\\{1,8\\} ")))
;;";;;\\(;* [^]\\|###autoload\\)\\|("
; note that the "^" is *implicit* at the beginning of the regexp


;;; Evil Mode
;;;; evil main deprecated
;; (use-package evil 
;;   :init
;;   (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
;;   (setq evil-want-keybinding nil)
;;   :config
;;   (evil-mode 1)
;;   (setq evil-emacs-state-cursor '("red" box)
;; 	evil-normal-state-cursor '("green" box)
;; 	evil-visual-state-cursor '("orange" box)
;; 	evil-insert-state-cursor '("yellow" bar)
;; 	evil-replace-state-cursor '("red" bar)
;; 	evil-operator-state-cursor '("red" hollow)
;; 	evil-cross-lines t)
;;   )
;; Enable hybrid mode (emacs binding in insert state)
;;;; preset evil variable
(setq evil-disable-insert-state-bindings t)
(setq evil-want-integration t) ;; This is optional since it's already set to t by default.
(setq evil-want-keybinding nil)
(setq evil-emacs-state-cursor '("red" box)
      evil-normal-state-cursor '("green" box)
      evil-visual-state-cursor '("orange" box)
      evil-insert-state-cursor '("yellow" bar)
      evil-replace-state-cursor '("red" bar)
      evil-operator-state-cursor '("red" hollow)
      evil-cross-lines t)
;;;; evil main
(require 'evil)
(evil-mode 1)
(define-key evil-normal-state-map "=" 'er/expand-region)
(define-key evil-normal-state-map (kbd "C-r") 'undo-redo)

;;
;; (add-hook 'outline-minor-mode-hook #'ky/outline-hide-all)
;; (add-hook 'outline-mode-hook 'ky/outline-hide-all)
;; (add-hook 'evil-collection-setup-hook #'ky/outline-hide-all)

;; (eval-after-load 'evil
;; (define-key outline-mode-map [C-tab] 'outline-hide-sublevels))
;;(global-set-key [C-tab] 'outline-hide-sublevels)
;;;; evil collection

;; (setq evil-collection-outline-bind-tab-p t)
;; (setq evil-collection-outline-enable-in-minor-mode-p t)
;; (setq outline-blank-line t)
;; (setq evil-collection-mode-list nil)
;; (when (require 'evil-collection nil t)
;;    (evil-collection-init 'outline))

(use-package evil-collection
;;   :bind (:map outline-minor-mode-map
;; 	    ([C-tab] . outline-hide-sublevels))
   :after evil
   ;; :ensure t
   :init
   (setq evil-collection-outline-bind-tab-p t)
   (setq evil-collection-outline-enable-in-minor-mode-p t)
   (setq outline-blank-line t)
   :config
   ;; (evil-collection-init 'outline)
   (evil-collection-init)
   )

(evil-collection-define-key 'normal 'outline-mode-map
    ;; folding
    ;; Evil default keys:
    ;; zO: Show recursively for current branch only.
    ;; za: Toggle first level like outline-toggle-children.
    ;; zc: Hide complete subtree.
    "zc" 'outline-hide-sublevels ; Hide all bodies, Emacs has "C-c C-t".
    ;; zm: Show only root notes.
    ;; zo: Show current node like "za".
    ;; zr: Show everything.
    ;; "ze" 'outline-hide-entry
    ;; "zE" 'outline-show-entry
    ;; "zl" 'outline-hide-leaves
    ;; "zb" 'outline-show-branches
    ;; "zo" 'outline-hide-other
    ) ; Hide all bodies, Emacs has "C-c C-t".

;; (add-hook 'outline-mode-hook
;; 	  (lambda () (local-set-key [C-tab] 'outline-hide-sublevels)))

;; (eval-after-load 'outline
;;     (define-key evil-normal-state-map [C-tab] 'outline-hide-sublevels))
;;;; comments
(require 'evil-commentary)
(evil-commentary-mode)
;;;; outline evil
;; (let ((kmap outline-minor-mode-map))
;;   (define-key kmap (kbd "M-RET") 'outshine-insert-heading)
;;   (define-key kmap (kbd "<backtab>") 'outshine-cycle-buffer)

;;   ;; Evil outline navigation keybindings
;;   (evil-define-key '(normal visual motion) kmap
;;     "gh" 'outline-up-heading
;;     "gj" 'outline-forward-same-level
;;     "gk" 'outline-backward-same-level
;;     "gl" 'outline-next-visible-heading
;;     "gu" 'outline-previous-visible-heading))


;;; Auto complete
;; enable globally    
(add-hook 'after-init-hook 'global-company-mode)
(global-set-key (kbd "<C-tab>") 'company-complete)

(setq company-idle-delay 0)
(setq company-dabbrev-downcase 0)
	
(defun tab-indent-or-complete ()
  (interactive)
  (if (minibufferp)
      (minibuffer-complete)
    (if (or (not yas-minor-mode)
	    (null (do-yas-expand)))
	(if (check-expansion)
	    (company-complete-common)
	  (indent-for-tab-command)))))

;; backtab is equivalent to Shift+Tab
;; (global-set-key [backtab] 'tab-indent-or-complete)

;;; Orderless
(use-package orderless
  :ensure t
  :custom (completion-styles '(orderless)))

(selectrum-mode +1)
;; (selectrum-prescient-mode +1)


;;; Consult
;; Example configuration for Consult
;; s key is "super key" which is also the window key
(use-package consult
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind (;; C-c bindings (mode-specific-map)
         ("C-c h" . consult-history)
         ("C-c m" . consult-mode-command)
         ("C-c b" . consult-bookmark)
         ("C-c k" . consult-kmacro)
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("s-y" . consult-yank-pop)                ;; orig. yank-pop
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ("<help> a" . consult-apropos)            ;; orig. apropos-command
         ;; M-g bindings (goto-map)
         ("M-<menu> e" . consult-compile-error)
         ("M-<menu> f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("s-g" . consult-goto-line)             ;; orig. goto-line
         ("M-<menu> M-g" . consult-goto-line)           ;; orig. goto-line
         ("s-o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-<menu> m" . consult-mark)
         ("M-<menu> k" . consult-global-mark)
         ("M-<menu> i" . consult-imenu)
         ("M-<menu> I" . consult-project-imenu)
         ;; M-s bindings (search-map)
         ("s-f" . consult-find)
         ("M-<menu> L" . consult-locate)
         ("M-<menu> g" . consult-grep)
         ("M-<menu> G" . consult-git-grep)
         ("M-<menu> r" . consult-ripgrep)
         ("s-l" . consult-line)
         ("M-<menu> m" . consult-multi-occur)
         ("M-<menu> k" . consult-keep-lines)
         ("M-<menu> u" . consult-focus-lines)
         ;; Isearch integration
         ("s-e" . consult-isearch)
         :map isearch-mode-map
         ("M-e" . consult-isearch)                 ;; orig. isearch-edit-string
         ("M-<menu> e" . consult-isearch)               ;; orig. isearch-edit-string
         ("M-<menu> l" . consult-line))                 ;; needed by consult-line to detect isearch

  ;; Enable automatic preview at point in the *Completions* buffer.
  ;; This is relevant when you use the default completion UI,
  ;; and not necessary for Selectrum, Vertico etc.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key (kbd "M-."))
  ;; (setq consult-preview-key (list (kbd "<S-down>") (kbd "<S-up>")))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme
   :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-file consult--source-project-file consult--source-bookmark
   :preview-key (kbd "M-."))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; (kbd "C-+")

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; Optionally configure a function which returns the project root directory.
  ;; There are multiple reasonable alternatives to chose from.
  ;;;; 1. project.el (project-roots)
  (setq consult-project-root-function
        (lambda ()
          (when-let (project (project-current))
            (car (project-roots project)))))
  ;;;; 2. projectile.el (projectile-project-root)
  ;; (autoload 'projectile-project-root "projectile")
  ;; (setq consult-project-root-function #'projectile-project-root)
  ;;;; 3. vc.el (vc-root-dir)
  ;; (setq consult-project-root-function #'vc-root-dir)
  ;;;; 4. locate-dominating-file
  ;; (setq consult-project-root-function (lambda () (locate-dominating-file "." ".git")))
)




;;; Modeline

