;;; .emacs --- .emacs file
;;; Commentary:
;; My bad code

;;; Code:

(custom-set-variables
 ;; custom-set-variabltes was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cua-mode t nil (cua-base))
 '(diff-switches "-u")
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(use-package yasnippet-snippets yasnippet dtrt-indent cape company cmake-mode cmake-project flycheck tree-sitter-langs tree-sitter reverse-im toml lua-mode org-ref markdown-mode auctex auctex-latexmk cdlatex preview-latex projectile treemacs treemacs-projectile eglot eglot-jl)
 )
)

;;; uncomment for CJK utf-8 support for non-Asian users
;; (require 'un-define)

(require 'package)
 (add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
;; (add-to-list 'package-archives
;;             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(setq frame-resize-pixelwise t)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(reverse-im-mode t)

;; RC

(let ((path (shell-command-to-string "source ~/.bashrc; echo -n $AsyPATH")))
  (print "AsyPATH")
  (setenv "AsyPATH" path)
)

;; Keys

(reverse-im-activate "russian-computer")

;; Undo

(global-unset-key (kbd "C-z"))
(global-set-key (kbd "C-z")   'undo-fu-only-undo)
(global-set-key (kbd "C-A-z") 'undo-fu-only-redo)
(put 'upcase-region 'disabled nil)

;; flycheck

(add-hook 'after-init-hook #'global-flycheck-mode)
(add-hook 'julia-mode-hook #'flymake-mode)

;; eglot

(set 'eglot-connect-timeout 250)

;; julia

;; (package-generate-autoloads "flycheck-julia" "~/.emacs.d/elpa/flycheck-julia-0.1.1/")
(eglot-jl-init)
(add-hook 'julia-mode-hook 'eglot-ensure)

;; latexmk


;; TeX

(print (concat (getenv "PATH") ":" (getenv "HOME") "/texlive/bin/x86_64-linux/"))
(setenv "PATH" (concat (getenv "PATH") ":" (getenv "HOME") "/texlive/bin/x86_64-linux/"))

(add-hook 'TeX-mode-hook
      '(lambda ()	 
	 (auctex-latexmk-setup)
	 (add-hook 'LaTeX-mode-hook #'turn-on-cdlatex)

	 (put 'TeX-narrow-to-group 'disabled nil)
	 (put 'LaTeX-narrow-to-environment 'disabled nil)
	 (put 'narrow-to-region 'disabled nil)

	 (defun ltxmk (TeXfile)
	   (TeX-save-document TeXfile)
	   (TeX-command "LatexMk" TeXfile -1)
	 )

	 (defun ltxmk-master ()
	   (interactive)
	   (ltxmk 'TeX-master-file)
	 )

	 (defun ltxmk-master-v ()
	   (interactive)
	   (ltxmk 'TeX-master-file)
	   (if (file-exists-p output-file)
	     (message "error")
	     (TeX-command "View" 'TeX-active-master 0)
	   )
	 )

	 (defun ltxmk-local ()
	   (interactive)
	   (setq tex-bf-file-name (buffer-file-name (window-buffer (minibuffer-selected-window))))
	   (ltxmk (lambda(&optional extension nondirectory ask) tex-bf-file-name))
	 )

	 (defun ltxmk-local-v ()
	   (interactive)
	   (setq tex-bf-file-name (buffer-file-name (window-buffer (minibuffer-selected-window))))
	   (ltxmk 'tex-bf-file-name)
	   (if (file-exists-p output-file)
	     (message "error")
	     (TeX-command "View" 'TeX-active-master 0)
	   )
	 )

	 
	 (set (make-local-variable 'TeX-engine) 'luatex)
	 (setq TeX-command-default "LatexMk")
	 (add-to-list 'TeX-view-program-list '("zathura" "zathura %o"))
	 (setq TeX-view-program-selection '((output-pdf "zathura")))
	 (local-set-key (kbd "C-c C-g C-g") 'ltxmk-master)
	 ;; (local-set-key (kbd "C-c C-g C-v") 'ltxmk-master-v)
	 (local-set-key (kbd "C-c C-g C-l") 'ltxmk-local)
	 ;; (local-set-key (kbd "C-c C-g C-w") 'ltxmk-local-v)
	 
	 (setq TeX-electric-math (cons "$" "$"))
	 (setq LaTeX-electric-left-right-brace t)
	 (setq TeX-insert-braces nil)
	 
	 (setq LaTeX-default-width "\textwidth")
	 (setq LaTeX-math-abbrev-prefix ":")

	 (setq LaTeX-indent-level 8)
	 (setq LaTeX-item-indent 2)
	 (setq indent-tabs-mode t)

	 (TeX-fold-mode 1)

	 (local-set-key (kbd "C-c C-y") 'prettify-symbols-mode)
	 (local-set-key (kbd "C-c y") 'prettify-symbols-mode)
	 (setq prettify-symbols-unprettify-at-point t)
	 (setq prettify-symbols-unprettify-right-edge t)
	 (add-to-list
	  'TeX-expand-list
	  (list "%(extraopts)"
		(lambda nil TeX-command-extra-options)))
      )
)


;; Asymptote

;; (add-to-list 'load-path "AsyPATH")
(autoload 'asy-mode (concat (getenv "AsyPATH") "/asy-mode.el") "Asymptote major mode." t)
(autoload 'lasy-mode (concat (getenv "AsyPATH") "/asy-mode.el") "hybrid Asymptote/Latex major mode." t)
(autoload 'asy-insinuate-latex (concat (getenv "AsyPATH") "/asy-mode.el") "Asymptote insinuate LaTeX." t)
(add-to-list 'auto-mode-alist '("\\.asy$" . asy-mode))

(setq asy-command "asy -V -f pdf")
(setq asy-command-no-view "asy -f pdf")

;; (treesit-available-p)

;; dtrt

(add-hook 'prog-mode-hook #'dtrt-indent-mode)
(add-hook 'TeX-mode-hook #'dtrt-indent-mode)

;; Org

(setq org-blank-before-new-entry
      '((heading . always)
       (plain-list-item . nil)))

(defun call-rebinding-org-blank-behaviour (fn)
   (message "%s" "Dumbs")
   
    (let ((org-blank-before-new-entry
           (copy-tree org-blank-before-new-entry)))
    (message "%s" "DumbsA")
    (if (and (org-at-heading-p) (= 1 (org-current-level)))
      (message "level lower than 2, blank line")
      (rplacd (assoc 'heading org-blank-before-new-entry) nil)
      ;; (message "level bigger than 2, no blank line")
    )
    
    (call-interactively fn))
)

(defun smart-org-meta-return-dwim ()
  (interactive)
  (message "%s" "Dumb")
  (call-rebinding-org-blank-behaviour 'org-meta-return))

(defun smart-org-insert-todo-heading-dwim ()
  (interactive)
  (call-rebinding-org-blank-behaviour 'org-insert-todo-heading))

(add-hook 'org-mode-hook '(lambda()
			    (define-key org-mode-map (kbd "M-RET") 'smart-org-meta-return-dwim)
			    (setq org-refile-targets '(
						       ("~/Desktop/org/all.org" :maxlevel . 2) ;;; All GTD
						       ("~/Desktop/org/day.org" :maxlevel . 2) ;;; Daily
						       ("~/Desktop/org/university.org" :maxlevel . 2) ;;; University
			    ))
			    (setq org-todo-keywords '((sequence "TODO(t)" "WAIT(w@/!)" "EDU(e@/!)" "|" "DONE(d@/!)" "CANCELED(c@/!)" "TRASH(b@)" "MAYBE(b@)" "REFERENCE(b@)")))
			    (setq org-tag-persistent-alist '(("project" . nil) ("maybe" . nil) ("no_deadline" . nil)  ("delegating" . nil) ("low_priority" . nil) ("medium_priority" . nil) ("high_priority" . nil) ("extreme_priority" . nil) ("@imbeciles" . nil) ("@travelling" . nil) ("@shopping" . nil) ("@document" . nil) ("@science" . nil) ("@education" . nil) ("@university" . nil) ("@programming" . nil) ("@toolchain" . nil) ("@feature" . nil) ("@bugfix" . nil) ("@project_support" . nil) ("@free_software" . nil) ("@open_source" . nil) ("@reverse_engeniring" . nil) ("@minecraft" . nil) ("@minetest" . nil) ("@horizon" . nil) ("@inner_core" . nil) ("mineprogramming" . nil) ("MineExplorer" . nil) ("ZhekaSmirnov" . nil) ("VSDum" . nil) ("viacheslav_veshnyakov" . nil) ("konstantin_vorontsov" . nil) ("natalia_shkaeva" . nil) ("julia_sevastyanova" . nil) ("marina_kholmova" . nil) ("igor_khadyko" . nil) ("_plakhin" . nil)))
			    (setq org-tags-exclude-from-inheritance '("project" "delegating"))
			    (setq ml-priority-low 10)
			    (setq ml-priority-medium 20)
			    (setq ml-priority-high 30)
			    (setq ml-priority-extreme 40)
			    (setq org-priority-highest 50)
			    (setq org-priority-lowest 1)
			    (setq org-priority-default 20)
			  )
)

(add-to-list 'auto-mode-alist '("treemacs-persist" . org-mode))

;; projectile
(projectile-mode +1)

(define-key projectile-mode-map (kbd "C-c q") 'projectile-command-map)

(setq projectile-enable-caching t)

(projectile-register-project-type 'innercore '("make.json" "toolchain"))

;; Treemacs
(add-hook 'imenu-mode-hook (setq imenu-auto-rescan t))

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-wide-toggle-width 80
	  treemacs-width 24
	  treemacs-indentation 1
    )
  )
)
;; (add-hook 'emacs-startup-hook (message("d %s" treemacs-indentation)))
;; (add-hook 'treemacs-mode-hook (setq treemacs-indentation 2))

;; (add-hook 'emacs-startup-hook 'treemacs)
;; (add-hook 'emacs-startup-hook 'treemacs-project-follow-mode)
;; (add-hook 'emacs-startup-hook 'treemacs-tag-follow-mode)

;; (setq treemacs-tag-follow-mode t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

;;;.emacs
