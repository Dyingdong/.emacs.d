;;; init-org-super-agenda.el --- Initialize org-super-agenda configurations. -*- lexical-binding: t -*-

;;; Commentary:
;;
;; Org super agenda configurations.
;;

;;; Code:

;; (use-package org-gtd
;;   :ensure nil
;;   ) ;; use-package ends here

;; org-mode for GTD
;; todo dependencies
;;(setq alert-default-style 'notifications)


;; appt
;; (use-package appt
;;   :ensure nil
;;   :config
;;   ;; 每小时同步一次appt,并且现在就开始同步
;;   (run-at-time nil 120 'org-agenda-to-appt)
;;   ;; 更新agenda时，同步appt
;;   (add-hook 'org-finalize-agenda-hook 'org-agenda-to-appt)
;;   ;; 激活提醒
;;   (appt-activate 1)
;;   ;; 提前10分钟提醒
;;   (setq appt-message-warning-time 5)
;;   ;; 每5分钟提醒一次
;;   (setq appt-display-interval 5)
;;   ;; (appt-disp-window min-to-appt current-time appt-msg)
;;   )

;; org-super-agenda语法说明：https://it-boyer.github.io/post/%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0/org-super-agenda%E6%96%87%E6%A1%A3%E7%BF%BB%E8%AF%91/
(use-package org-super-agenda
  :ensure t
  :defer t
  :hook (org-agenda-mode . org-super-agenda-mode)
  :config
  (define-key org-super-agenda-header-map (kbd "<tab>") 'origami-toggle-node)
  (setq org-super-agenda-groups
	'(;; Each group has an implicit boolean OR operator between its selectors.
	  (:name "Today"  ; Optionally specify section name
		 :time-grid t  ; Items that appear on the time grid
		 :todo "TODAY")  ; Items that have this TODO keyword
	  (:auto-group t)
	  ;; After the last group, the agenda will display items that didn't
	  ;; match any of these groups, with the default order position of 99
	  ))
  )

(provide 'init-org-super-agenda)
;;; init-org-super-agenda.el ends here
