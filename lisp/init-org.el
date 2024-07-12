;;; init-org.el --- Initialize org configurations. -*- lexical-binding: t -*-

;;; Commentary:
;;
;; Org configurations.
;;

;;; Code:

(require 'init-const)
(require 'init-custom)

(use-package org
  :ensure nil
  :defer t
  :bind
  ("C-c b" . org-switchb)
  ("C-c 。" . org-time-stamp)
  ("C-c r" . org-refile)
  ("C-c t" . org-tags-sparse-tree)
  ("C-c g" . org-mark-ring-goto)
  ("C-c m" . org-mark-ring-push)
  ("C-c a" . org-agenda)
  ("C-c x" . org-capture)
  ("C-c C-f a" . consul-org-agenda)
  :config
  (define-key org-mode-map (kbd "C-c C-，") 'org-insert-structure-template)

  ;; 解决：Warning (org-element-cache): org-element--cache: Org parser error in slides.org::2206. Resetting.
  ;; The error was: (error "Invalid search bound (wrong side of point)")
  (customize-set-variable 'warning-suppress-log-types '((org-element-cache)))

  
  ;; org for GTD
  (load-library "find-lisp")
  (setq org-agenda-files (find-lisp-find-files org-gtd-path "\.org$"))

  (setq-default org-refile-targets '((org-gtd-path-projects :maxlevel . 5)
				     (org-gtd-path-todos :maxlevel . 5)
				     (org-gtd-path-schedule :maxlevel . 5)
				     (org-gtd-path-inbox :maxlevel . 5)
				     ))
  ;; 设置能在agenda中显示的deadline的时间
  (setq-default org-deadline-warning-days 30)
  ;; org-capture
  ;; 快捷键“C-c x”
  (setq-default org-capture-templates
		'(("i" "Inbox" entry
		   (file+headline org-gtd-path-inbox "Tasks")
		   "* TODO %?\n  %i\n"
		   :empty-lines 0)
		  ("s" "Schedule" entry
		   (file+headline org-gtd-path-schedule "Schedules")
		   "* TODO %?\n  %i\n"
		   :empty-lines 1)
		  ("t" "TODOs" entry
		   (file+headline org-gtd-path-todos "TODOs")
		   "* TODO %?\n  %i\n"
		   :empty-lines 1)
		  ("p" "Projects" entry
		   (file+headline org-gtd-path-projects "Projects")
		   "* TODO %?\n  %i\n"
		   :empty-lines 1)
		  )
		)


  ;; 设置任务流程
  ;; This is achieved by adding special markers ‘!’ (for a timestamp)
  ;; or ‘@’ (for a note with timestamp) in parentheses after each keyword.
  (setq org-todo-keywords
	'((sequence "DOING(i)" "TODO(t)" "HANGUP(h)" "|" "DONE(d)" "CANCEL(c)"))
	org-todo-keyword-faces '(("TODO" . (:foreground "#F4606C" :weight blod))
				 ("DOING" . (:foreground "#19CAAD" :weight blod))
				 ("HANGUP" . (:foreground "#F4606C" :weight bold))
				 ("DONE" . (:foreground "#939391" :weight blod))
				 ("CANCEL" . (:background "gray" :foreground "black"))))
  
  (setq org-priority-faces '((?A . error)
			     (?B . warning)
			     (?C . success)))

  ;; need repeat task and properties
  (setq org-log-done nil)
  ;; (setq org-log-into-drawer t)
  (setq org-log-repeat nil)

  (setq-default org-agenda-span 'day)
  ;;(add-hook org-capture-mode-hook 'evil-mode)

  (setq-default org-agenda-custom-commands
		'(("i" "重要且紧急的事" ;; 不显示没有加org-todo-keywords以及keyword是DONE的任务
		   ((tags-todo "+PRIORITY=\"A\"")))
		  ;; ...other commands here
		  ))

  (setq org-agenda-sorting-strategy
	'((agenda time-up category-up tag-up priority-down)
	  (todo   category-up priority-down)
	  (tags   category-up priority-down)
	  (search category-up)))

  ;; 设置不参与继承的标签
  (setq org-tags-exclude-from-inheritance '("LONGTERM"))

  	      
  
  ;; 使 org-mode 中的 timestamp 格式为英文
  (setq system-time-locale "C")
  
  ;; Org LaTeX
  ;; 使用 XeLaTeX 程序进行编译转换
  (setq-default org-latex-compiler "xelatex")
  (setq-default org-latex-pdf-process '("xelatex %f"))
  (add-to-list 'org-latex-default-packages-alist '("" "ctex" t ("xelatex")))

  (setq-default org-latex-prefer-user-labels t)
  
  ;; To speed up startup, don't put to init section
  (setq org-modules nil)     ;; Faster loading
  (setq org-startup-numerated t)

  (setq org-image-actual-width nil)
  (setq-default org-startup-with-inline-images t)

  ;; 单独设置org标题字体大小，https://emacs-china.org/t/org/12869
  ;; 设置org标题1-8级的字体大小和颜色，颜色摘抄自monokai
  ;; 希望org-mode标题的字体大小和正文一致，设成1.0， 如果希望标题字体大一点可以设成1.2
  ;; org-mode正文height为140
  (custom-set-faces
   '(org-level-1 ((t (:inherit outline-1 :height 190))))
   '(org-level-2 ((t (:inherit outline-2 :height 160))))
   '(org-level-3 ((t (:inherit outline-3 :height 150))))
   '(org-level-4 ((t (:inherit outline-4 :height 150))))
   ) ;; end custom-set-faces

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (C . t)
     (java . t)
     (js . t)
     (ruby . t)
     (ditaa . t)
     (python . t)
     (shell . t)
     (latex . t)
     (plantuml . t)
     (R . t)))
  
  ;; 标题下的列表就可以像标题一样折叠了
  (setq org-cycle-include-plain-lists 'integrate)

  ;; org latex公式预览
  ;; https://emacs-china.org/t/org/19465
  (add-to-list 'org-preview-latex-process-alist
	       '(dvipng :programs
			("latex" "dvipng")
			:description "dvi > png"
			:message "you need to install the programs: latex and dvipng."
			:image-input-type "dvi"
			:image-output-type "png"
			:image-size-adjust (1.4 . 1.2)
			:latex-compiler ("latex -interaction nonstopmode -output-directory %o %f")
			:image-converter ("dvipng -D %D -T tight -o %O %f")))
  ;; 公式基线对齐：https://emacs-china.org/t/org-latex-preview/22288/2
  (defun my-org-latex-preview-advice (beg end &rest _args)
    (let* ((ov (car (overlays-in beg end)))
           (img (cdr (overlay-get ov 'display)))
           (new-img (plist-put img :ascent 100)))
      (overlay-put ov 'display (cons 'image new-img))))
  (advice-add 'org--make-preview-overlay
              :after #'my-org-latex-preview-advice)
  
  ) ; use-package org ends here

(use-package hi-lock
  :ensure nil
  :init
  (global-hi-lock-mode 1)
  (setq hi-lock-file-patterns-policy #'(lambda (dummy) t))
  :config
  (add-hook 'org-mode-hook 'org-bold-highlight)
  )

(use-package org-superstar
  :ensure t
  :if (and (display-graphic-p) (char-displayable-p ?◉))
  :hook (org-mode . org-superstar-mode)
  :config
  (setq org-superstar-headline-bullets-list '("▼")) ; no bullets
  (setq org-ellipsis " ▾")
  )

;; https://github.com/casouri/valign
;; 表格对齐
(use-package valign
  :ensure t
  :defer t
  :hook (org-mode . valign-mode)
  :config (setq valign-fancy-bar t))

;; (use-package org-contrib
;;   :pin nongnu
;;   :config
;;   ;; 对于需要重复完成的任务很有帮助
;;   (require 'org-checklist)
;;   )


;;（造轮子）定义了一个函数可以循环org-mode的emphasis-markers的可见性。
;; emphasis-markers就是org-mode轻语言的标记符号，比如说*、-等。
;; (defun org-cycling-emphasis-markers()
;;   (interactive)
;;   (if org-hide-emphasis-markers
;;     (setq org-hide-emphasis-markers nil)
;;     (setq org-hide-emphasis-markers t))
;;   (revert-buffer nil t nil))
;; (global-set-key (kbd "C-c c") 'org-cycling-emphasis-markers)

;; 但是有个更好的插件可以解决我这个需求：org-appear，以上就属于“造轮子”了
;; Github：https://github.com/awth13/org-appear
;; emacs-china：https://emacs-china.org/t/org-mode/16826
(use-package org-appear
  :ensure t
  :defer t
  :hook (org-mode . org-appear-mode)
  :config
  ;;使用evil-mode后，可以用以下代码来实现只在编辑模式下激活org-appear-mode
  ;;⚠️得先执行(setq org-hide-emphasis-markers t)，否则org-appear-autoemphasis会失效
  (setq org-hide-emphasis-markers t)
  (setq org-appear-autoemphasis t)
  (setq org-appear-autolinks t)
  (setq org-appear-trigger 'manual)
  (add-hook 'org-mode-hook (lambda ()
                             (add-hook 'evil-insert-state-entry-hook
				       'org-appear-manual-start
				       nil
				       t)
                             (add-hook 'evil-insert-state-exit-hook
				       'org-appear-manual-stop
				       nil
				       t)))) ; use-package org-appear

(use-package org-fragtog
  :ensure t
  :defer t
  :hook (org-mode . org-fragtog-mode)
  ;; (org-roam-mode . org-fragtog-mode)
  )

(use-package org-download
  :ensure t
  :defer t
  :hook
  (org-mode . org-download-enable)
  ;; (org-roam-mode . org-download-enable)
  :config
  (setq-default org-download-heading-lvl 4)
  ;; (setq-default org-download-image-dir "./images")
  (setq-default org-download-image-dir "./images")
  
  ;; (defun dummy-org-download-annotate-function (link)
  ;; "")
  ;; (setq org-download-annotate-function
  ;; 'dummy-org-download-annotate-function)
  ;; (setq org-download-screenshot-method "imagemagick/convert -a -f %s")
  )

(use-package zotxt
  :ensure t
  :after org org-roam
  :defer t
  :hook
  (org . org-zotxt-mode)
  (org-roam-mode . org-zotxt-mode))

(provide 'init-org)
;;; init-org.el ends here
