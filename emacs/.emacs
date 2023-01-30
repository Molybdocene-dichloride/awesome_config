;;; .emacs --- .emacs file
;;; Commentary:
;; My bad code

;;; Code:

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cua-mode t nil (cua-base))
 '(diff-switches "-u")
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(yasnippet-snippets yasnippet dtrt-indent cape company cmake-mode cmake-font-lock cmake-project flycheck tree-sitter-langs tree-sitter reverse-im toml lua-mode org-ref markdown-mode auctex cdlatex projectile treemacs treemacs-projectile)))

;;; uncomment for CJK utf-8 support for non-Asian users
;; (require 'un-define)

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(setq frame-resize-pixelwise t)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(reverse-im-mode t)

;; Keys

(reverse-im-activate "russian-computer")

;; Undo

(global-unset-key (kbd "C-z"))
(global-set-key (kbd "C-z")   'undo-fu-only-undo)
(global-set-key (kbd "C-A-z") 'undo-fu-only-redo)
(put 'upcase-region 'disabled nil)

;; Tex

(add-hook 'TeX-mode-hook
      '(lambda ()
	 (set (make-local-variable 'TeX-engine) 'luatex)
         (setq TeX-view-program-selection '(output-pdf "zathura"))
      )
)
;; (treesit-available-p)

;; flycheck

(add-hook 'after-init-hook #'global-flycheck-mode)

;; dtrt

(add-hook 'prog-mode-hook #'dtrt-indent-mode)

(add-hook 'TEX-mode-hook #'dtrt-indent-mode)

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
			    (setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "EDU(e)" "|" "DONE(d)" "CANCELLED(c)")))
			    (setq org-tag-persistent-alist '("project" "maybe" "no_deadline" "delegating" "low_priority" "medium_priority" "high_priority" "extreme_priority" "@imbeciles" "@travelling" "@shopping" "@document" "@science" "@education" "@university" "@programming" "@toolchain" "@feature" "@bugfix" "@project_support" "@free_software" "@open_source" "@reverse_engeniring" "@minecraft" "@minetest" "@horizon_modding_kernel" "@horizon" "@inner_core" "mineprogramming" "MineExplorer" "ZhekaSmirnov" "VSDum" "viacheslav_veshnyakov" "konstantin_vorontsov" "shkaeva_natalia" "sevastyanova_julia" "kholmova_marina" "khadyko_igor" "plakhin_"))
			    (setq org-tags-exclude-from-inheritance '("project" "low_priority" "medium_priority" "high_priority" "extreme_priority" "delegating"))
			    (message "der %s" org-todo-keywords)
			  )
)
;;;.emacs
