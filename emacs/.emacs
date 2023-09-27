
;;; .emacs --- .emacs file
;;; Commentary:
;; My bad code

;;; Code:

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diff-switches "-u")
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(julia-mode use-package yasnippet-snippets yasnippet dtrt-indent cape company company-ctags cmake-mode cmake-project flycheck tree-sitter-langs tree-sitter reverse-im toml lua-mode org-ref auctex auctex-latexmk cdlatex preview-latex projectile treemacs treemacs-projectile eglot eglot-jl)))

;;; uncomment for CJK utf-8 support for non-Asian users
;; (require 'un-define)

;; packages

(require 'package)
 (add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
;; (add-to-list 'package-archives
;;             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; faces

(setq frame-resize-pixelwise t)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq-default cursor-type '(bar . 3))
(set-cursor-color "#778888")
(set-face-attribute 'region nil :background "#CCDDDD")
(set-face-attribute 'show-paren-match nil :background "#90F1E1")
(set-face-attribute 'show-paren-match-expression nil :background "#60F0E1")
(set-face-attribute 'show-paren-mismatch nil :background "#939DDD")


(delete-selection-mode t)
(setq x-select-enable-primary nil) ;; crutch for Arch (?)

;; RC

(print "exec-path")
(print exec-path)

;; Keys

(reverse-im-mode t)
(reverse-im-activate "russian-computer")

;; Undo

(global-unset-key (kbd "C-z"))
(global-set-key (kbd "C-z")   'undo-fu-only-undo)
(global-set-key (kbd "C-A-z") 'undo-fu-only-redo)

(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)

(add-hook 'after-init-hook #'electric-pair-mode)

;; flycheck

(add-hook 'after-init-hook #'global-flycheck-mode)
(add-hook 'julia-mode-hook #'flymake-mode)

;; eglot

(set 'eglot-connect-timeout 255)

;; Indent

(setq-default indent-tabs-mode t)
(setq-default tab-width 4)
(setq dtrt-indent-explicit-tab-mode t)

(add-hook 'prog-mode-hook #'dtrt-indent-mode)
(add-hook 'TeX-mode-hook #'dtrt-indent-mode)

;; projectile

(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c q") 'projectile-command-map)
(setq projectile-enable-caching t)
(projectile-register-project-type 'innercore-prj '("make.json" "toolchain"))
; (projectile-register-project-type 'julia-prj '("*.jl"))

(defun prj-get ()
  (interactive)
  (print projectile-project-types)
)
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

;;YASnippet

(defun eq-delete-backward-char (n) ;;only for n == 1
  (if (not (or (equal (char-before (point)) nil) (char-equal (char-before (point)) ?\n))) (progn
    (delete-backward-char n)
  ))
)

(defun eq-delete-forward-char (n) ;;only for n == 1
  (if (not (or (equal (char-after (point)) nil) (char-equal (char-after (point)) ?\n))) (progn
    (delete-forward-char n)
  ))
)

(add-to-list 'auto-mode-alist '("\\.yasnippet$" . snippet-mode))

(add-hook 'yas-minor-mode-hook
	  '(lambda ()
	     (define-key yas-minor-mode-map (kbd "<tab>") nil)
	     (define-key yas-minor-mode-map (kbd "TAB") nil)

	     (define-key yas-minor-mode-map (kbd "C-c d") #'yas-expand)
	     (define-key yas-minor-mode-map (kbd "C-c TAB") #'yas-insert-snippet)
	     ; (local-set-key (kbd "TAB") 'yas-expand)

	     (setq yas-snippet-dirs '("~/.emacs.d/elpa/yasnippet-snippets-20230815.820/snippets/" "~/.emacs.d/third_party_snippets/" "~/.emacs.d/snt/"))
             (with-eval-after-load 'warnings
              (cl-pushnew '(yasnippet backquote-change) warning-suppress-types
              :test 'equal))
   )
)

;;(add-hook 'prog-mode-hook #'yas-minor-mode) ; not work
;;(add-hook 'TeX-mode-hook #'yas-minor-mode)

(yas-global-mode)

;; company

(global-company-mode)

(defun b_load_company_sup ()
       (company-ctags-auto-setup)
	   (set (make-local-variable 'company-backends) '((company-files company-yasnippet company-capf company-ctags)))
)

(add-hook 'TeX-mode-hook '(lambda ()
       (b_load_company_sup)
   )
)
(add-hook 'org-mode-hook '(lambda ()
       (b_load_company_sup)
   )
)
(add-hook 'prog-mode-hook '(lambda ()
	   (b_load_company_sup)
   )
)

;; sh

(add-to-list 'auto-mode-alist '("\\.profile$" . sh-mode))

(defun insertln (str)
	(insert (concat str "\n"))
)

(defun outbuff(bfname jl-cmdd shc)
  (with-current-buffer (get-buffer-create bfname)
    (insertln (concat "!" bfname " buffer"))
	(insertln (concat "command: " jl-cmdd "\n"))
	(insert shc)
  )
)
;; julia

(eglot-jl-init)
(add-hook 'julia-mode-hook '(lambda()
		(eglot-ensure)
		(setq julia-indent-level 4)
		(setq indent-tabs-mode t)
		(setq projectile-project-type 'julia-prj)
		(defun jl-projectile-run-project ()
		  (interactive)
		  ;(setq jl-cmdd (make-list 0 "ferret"))
		  (setq jl-cmdd (format "julia %s" (buffer-file-name (window-buffer (minibuffer-selected-window)))))
		  ;(add-to-list 'jl-cmdd (buffer-file-name (window-buffer (minibuffer-selected-window))) t '(lambda (a1 a2) nil))
		  (print jl-cmdd)
		  (setq shc (shell-command-to-string jl-cmdd))
		  (print shc)
		  (outbuff "jl-output" jl-cmdd shc)		  
		)
		
   )
)

(setq diary-file (concat (getenv "scidir") "/misc/nrf/nrf.dar"))

;; TeX

;; (setenv "PATH" (concat (getenv "PATH") ":" (getenv "HOME") "/texlive/bin/x86_64-linux/"))

(defun nthss (start str)
  (substring str start (+ start 1))
)

(add-hook 'TeX-mode-hook
   '(lambda ()
	 (auctex-latexmk-setup)
	 (imenu-add-menubar-index)
	 
	 (turn-on-cdlatex)
     (define-key cdlatex-mode-map (kbd "C-c w") #'cdlatex-tab)
	 (add-hook 'cdlatex-tab-hook '(lambda()
	   (LaTeX-indent-line)
       (yas-expand)
	 ))
         
	 ; not work
	 ; (local-set-key (kbd "TAB") 'yas-expand)
	 ; (local-set-key (kbd "TAB") 'LaTeX-indent-line)
	 
	 (put 'TeX-narrow-to-group 'disabled nil)
	 (put 'LaTeX-narrow-to-environment 'disabled nil)

	 (defun add-to-listzo (adylist val)
	   (print "add-to-listzo")
	   (print (listp adylist))
	   (print (length adylist))
	   (print "frerrets")
	   (if (> (length adylist) 1) (progn
		   (print "car")
		   (setcar (nthcdr 0 adylist) val)
	   ) (progn
		   (print "add-to-list")
		   (add-to-list 'adylist val)
	   ))
	   (eval 'adylist)
	   )
	 
	 (defun eq-symbs ()
           (interactive)
	       (print "ferrets")
		   (print yas-snippet-beg)
           (setq eq-start-point (- (point) 2)) ; (yas-snippet-beg)
           (setq eq-start-symbol (string(char-after eq-start-point)))
	       (print eq-start-point)
	       (setq condaoi (equal eq-start-symbol "|"))
	       (print condaoi)
	       (if condaoi (progn
	         (setq eq-c-point eq-start-point)
	         (setq eq-c-symbol eq-start-symbol)
	         (print eq-start-symbol)
	         (print eq-c-point)
	         (print eq-c-symbol)

			 (setq eq-c-strings (make-list 0 "ferret"))
		 	 (setq eq-c-string "")
	         
			 (setq eq-c-points (make-list 1 (+ eq-c-point 2)))
	         (setq eq-c-point (- eq-c-point 1))
	         ; (string(char-after eq-c-point))

			 (while (and (not (equal eq-c-symbol " ")) (not (equal eq-c-symbol "\t")) (not (equal eq-c-symbol "\n"))) (progn
		       (print "while")
	           (setq eq-c-symbol (string(char-after eq-c-point)))
		       (print eq-c-point)
	           (print eq-c-symbol)
		       (if (equal eq-c-symbol "|") (progn
                 (print "eq-c-string")
	             (print eq-c-string)
	             (add-to-list 'eq-c-strings (copy-tree eq-c-string))
			     (setq eq-c-points (add-to-listzo eq-c-points (copy-tree (- eq-c-point 0))))
			     (setq eq-c-string "")
			   ) (progn
                 (print "bbnn")
			     (setq eq-c-string (concat eq-c-symbol eq-c-string))
			   ))
               (setq eq-c-point (- eq-c-point 1))
	         ))
		   )(progn
			 (print "not | in (cursor - 2) position!")
			 (setq eq-c-strings (make-list 10 nil))
			 (setq eq-c-points (make-list 1 0))
		   ))

	   (print "eq-c-strings")
	   (print eq-c-strings)
	   (print "eq-c-points")
	   (print eq-c-points)
	   (print "")
     )

	 (defun eq-val (idx)
	   (print "eq-val")
	   (print (nth (- idx 1) eq-c-strings))
	   (nth (- idx 1) eq-c-strings)
	 )
	 
	 (defun eq-coeff (idx)
	   (print "eq-coeff")
	   (setq eq-avalue (eq-val idx))
	   (print (length eq-avalue))
	   (if (> (length eq-avalue) 1) (progn
	     (print (substring eq-avalue 0 1))
         (if (equal (substring eq-avalue 0 1) "'") (progn
		   (print "checkers")
		   (setq eq-avalue-s (concat "(" (substring eq-avalue 1) ")"))
		   (print eq-avalue-s)
           (setq eq-avalue (eval (car (read-from-string eq-avalue-s))))
	     ))
	   ))
	   (eval eq-avalue)
	 )

	 (defun eq-default (eq-avalue &optional default)
	   (if (or (equal eq-avalue "") (equal eq-avalue nil) (equal eq-avalue "\n")) (progn
         (setq eq-avalue default)
	   ))
	   (if (equal eq-avalue nil) (progn
         (setq eq-avalue "")
	   ))
	   (print eq-avalue)
	   (eval eq-avalue)
	 )

	 (defun eq-val-d (idx &optional default)
	   (print "eq-val-d")
	   (print default)
	   (setq eq-avalue (eq-val idx))
	   (eq-default eq-avalue default)
	 )
	 
	 (defun eq-coeff-d (idx &optional default)
	   (print "eq-coeff-d")
	   (setq eq-avalue (eq-coeff idx))
	   (eq-default eq-avalue default)
	 )

	 (defun eq-more-list (idx pattern) ;; pattern is default value
	   (print "eq-more-list")
	   (print pattern)
	   ;(print (substring pattern (length pattern)))
	   (seqq eq-op (nthss (- (length pattern) 1) pattern))
	   (print eq-op)
	   (if (string-match-p "[[:alnum:]]" eq-op) (setq eq-op " "))
	   (print "operator symbs")
	   (print eq-op)
	   
	   (setq idd 0)

	   (setq eq-t-s "eq-symbol")
	   (setq eq-t-o "eq-oper")
	   (setq eq-defaults (make-list 0 "ferret"))
	   (setq eq-types (make-list 0 "ferret"))

	   (print "other symbs")
		 
	   (while (<= idd (- (length pattern) 1)) (progn
		 (setq eq-char (nthss idd pattern))
		 (setq eq-chr (copy-tree eq-char))
		 (print (type-of eq-char))
		 (print eq-char)
		 (add-to-list 'eq-defaults eq-chr t '(lambda (a1 a2) nil))
		 (print "eq-char")
		 (if (string-match-p "[[:alnum:]]" eq-char) (progn
		   (add-to-list 'eq-types eq-t-s t '(lambda (a1 a2) nil)) ; a+b+c+d
		   (print "t-s")
		 )(progn
		   (add-to-list 'eq-types eq-t-o t '(lambda (a1 a2) nil))
		   (print "t-o")
		 ))
		 (print "eq-chars")
		 
		 (setq idd (1+ idd))
	   ))

	   (print "def, typs")
	   (print eq-defaults)
	   (print eq-types)

	   (print "str")
	   (setq eq-str (nth (- idx 1) eq-c-strings))
	   (print eq-str)

	   (setq eq-val "")
	   (setq idd 0)
	   (setq j 0)
	   (setq eq-notzero nil)
	   (print "eq-while")
	   (print (length eq-str))
	   (print (length eq-defaults))
	   (while (< idd (length eq-str)) (progn
		 (print "eq-str")
		 (setq eq-char (nthss idd eq-str))
		 (print eq-char)
		 (setq eq-od (copy-tree eq-char))
		 (print eq-od)
		 (if (< j (length eq-defaults)) (progn
           (print "part")
		   (print j)
		   (if (string= eq-char ",") (progn
		     (print "operator, new element")
			 (if (not eq-notzero) (progn
			   (setq eq-val (concat eq-val (nth j eq-defaults)))
				 
			 ))
			 (setq eq-notzero nil)
			 (setq j (1+ j))

			 (setq jdef (nth j eq-defaults))
			 (if (string= jdef "\\") (progn
               (print "bigger operator")
			   (while (not (string= (nth j eq-defaults) " "))
			     (setq eq-val (concat eq-val (nth j eq-defaults)))
				 (setq j (1+ j))
				 (print j)
				 (print eq-val)
			   )
			 ) (progn
			   (print "smal operator")
			   
			 ))
			 
			 (setq eq-val (concat eq-val (nth j eq-defaults)))
			 (print j)
			 (print eq-val)
			 (setq j (1+ j))
		   ) (progn
	         (print "symbol")
			 (setq eq-val (concat eq-val eq-char))
			 (setq eq-notzero t)
			   
		   ))
		 ) (progn
		   (setq j 0)
		   (print "operator, new part")
		   (setq eq-val (concat eq-val eq-char))
		   (print eq-val)
		 ))
		 
		 (setq idd (1+ idd))
	   ))

	   (print "eq-val")
	   (print eq-val)
	 )
	 
	 (defun eq-vall ()
	   (interactive)
	   (eq-symbs)
	   (print (eq-more-list 1 "a∪"))
	   (print (eq-more-list 1 "a\\union b∪"))
	 )
	 
	 (defun eq-clear-symbs ()
	   (interactive)
	   (setq eq-start-point nil)
       (setq eq-start-symbol nil)
	   
	   (setq eq-c-point nil)
	   (setq eq-c-points nil)
	   
	   (setq eq-c-symbol nil)
	   (setq eq-c-string nil)
	   (setq eq-c-strings nil)
     )

	 (defun eq-clearsyntax ()
	   (print "clearst")
	   (if (and (listp eq-c-points) (length> eq-c-points 1)) (progn
	     (delete-region (nth 0 eq-c-points) (nth 1 eq-c-points))
	   ))
	   (eq-clear-symbs)
	 )
	 
	 (add-hook 'yas-before-expand-snippet-hook '(lambda()
	   (print "bef")
	   ;(print snippet)
       ;(eq-symbs)
	 ))
	 
	 (add-hook 'yas-after-exit-snippet-hook '(lambda()
		(print "exit")
		(eq-clearsyntax)
	 ))
	 
	 (defun tex-set-master-file (mafile)
	   (interactive "masterfile: ")
	   (print mafile)
	   (setq TeX-macro-global 'mafile)
	 )
	 (defun ltxmk (TeXfile)
	   (TeX-save-document TeXfile)
	   (TeX-command "LatexMk" TeXfile -1)
	 )

	 (defun ltxmk-master ()
	   (interactive)
	   (ltxmk 'TeX-master-file)
	 )

	 (defun ltxmk-with-master (mafile)
	   (interactive "masterfile: ")
	   (setq tex-old-master 'TeX-master-file)
	   (tex-set-master-file mafile)
	   (ltxmk-master)
	   (setq TeX-master-file 'tex-old-master)
	 )

	 (defun ltxmk-with-set-master (mafile)
	   (interactive "masterfile: ")
	   (setq tex-old-master 'TeX-master-file)
	   (tex-set-master-file mafile)
	   (ltxmk-master)
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

	 (local-set-key (kbd "C-c C-t C-a") 'tex-set-master-file)
	 (local-set-key (kbd "C-c C-t C-f") 'ltxmk-with-master)

	 (setq TeX-electric-math (cons "$" "$"))
	 (setq LaTeX-electric-left-right-brace t)
	 (setq TeX-insert-braces nil)
	 
	 (setq LaTeX-default-width "\textwidth")
	 ; (setq LaTeX-math-abbrev-prefix ":")

	 (setq LaTeX-indent-level 4)
	 (setq LaTeX-item-indent 2)
	 (setq indent-tabs-mode t)
     (setq LaTeX-document-regexp "")

	 (setq TeX-auto-save t)
	 (setq TeX-parse-self t)
	 ;(setq TeX-style-path '('(concat (getenv "TeXMFDISTPATH") "/tex")))
	 
	 (local-set-key (kbd "C-b C-p") 'outline-next-visible-heading)
	 (local-set-key (kbd "C-b C-n") 'outline-previous-visible-heading)
	 (local-set-key (kbd "C-b C-f") 'outline-forward-same-level)
	 (local-set-key (kbd "C-b C-b") 'outline-previous-visible-heading)

	 (local-set-key (kbd "C-b C-c") 'outline-hide-entry)
	 (local-set-key (kbd "C-b C-e") 'outline-show-entry)

	 (local-set-key (kbd "C-b C-l") 'outline-hide-leaves)
	 (local-set-key (kbd "C-b C-k") 'outline-show-branches)

	 (local-set-key (kbd "C-b C-a") 'outline-show-all)
	 
	 (TeX-fold-mode 1)

	 (local-set-key (kbd "C-c C-y") 'prettify-symbols-mode)
	 (local-set-key (kbd "C-c y") 'prettify-symbols-mode)
	 (setq prettify-symbols-unprettify-at-point t)
	 (setq prettify-symbols-unprettify-right-edge t)

	 (setq cdlatex-command-alist '(("sec" "Insert section 2" "" cdlatex-environment ("section") t nil)
				       ("ssec" "Insert subsection 2" "" cdlatex-environment ("subsection") t nil)
				       ("sssec" "Insert subsection 2" "" cdlatex-environment ("subsubsection") t nil)
				       ("igr" "Insert graphics" "" cdlatex-environment ("includegraphics") t nil)
				       ("law" "Insert left arrow" "" cdlatex-environment ("leftarrow") t nil)
				       ("raw" "Insert right arrow" "" cdlatex-environment ("rightarrow") t nil)

				       ("xpow" "Insert powered expr" "" "?^{}" cdlatex-position-cursor nil nil)
				       ;; (" pow" "Insert powered expr" "" "^{?}" cdlatex-position-cursor nil nil)
				       ("xsq" "Insert expr^2 (squared)" "?^{2}" cdlatex-position-cursor nil nil)
				       ("xsr" "Insert expr^2 (squared)" "?^{2}" cdlatex-position-cursor nil nil)
				       ("xcb" "Insert expr^3 (cubed)" "?^{3}" cdlatex-position-cursor nil nil)

				       ("powx" "Insert x^exp" "?^{}" cdlatex-position-cursor nil nil)
				       ("sqx" "Insert 2^exp" "2^{?}" cdlatex-position-cursor nil nil)
				       ("srx" "Insert 2^exp" "2^{?}" cdlatex-position-cursor nil nil)
				       ("cbx" "Insert 3^expr" "3^{?}" cdlatex-position-cursor nil nil)
				       ("pgh" "Insert grav pressure" "\\rho gh" cdlatex-position-cursor nil nil)

				       ;; some equations
				       ("crt2" "Insert chemical reaction rate" "k?^{x} ^{y}" cdlatex-position-cursor nil nil)
				       ("crt3" "Insert chemical reaction rate" "k?^{x} ^{y} ^{z}" cdlatex-position-cursor nil nil)
				       ("drt" "Insert diffusion rate (first Fick law)" "-D\\nabla ?s" cdlatex-position-cursor nil nil)
				       ("drts" "Insert second Fick law" "-D\\laplacian ?s" cdlatex-position-cursor nil nil)
				       
				       ))
         (add-to-list
	  'TeX-expand-list
	  (list "%(extraopts)"
		(lambda nil TeX-command-extra-options)))

	 ;(define-key cdlatex-mode-map (kbd "TAB") nil)
	 ;(kill-buffer "*scratch*")
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
				(setq truncate-lines nil)
				(define-key org-mode-map (kbd "M-p") 'org-mode-restart)
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

;;;.emacs
