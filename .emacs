;; .emacs

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cua-mode t nil (cua-base))
 '(diff-switches "-u")
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(yasnippet-snippets yasnippet cape company cmake-mode flycheck tree-sitter-langs tree-sitter reverse-im toml lua-mode org-ref markdown-mode auctex cdlatex projectile treemacs treemacs-projectile)))

;;; uncomment for CJK utf-8 support for non-Asian users
;; (require 'un-define)

(require 'package)
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
         (set (make-local-variable 'TeX-engine) 'luatex)))

;; (treesit-available-p)

;; flycheck

(add-hook 'after-init-hook #'global-flycheck-mode)
