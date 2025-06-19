;;; init-copilot.el --- Initialize GitHub Copilot configurations. -*- lexical-binding: t -*-

;;; Commentary:
;;
;; GitHub Copilot configurations.
;; 参考：https://cloud.tencent.com/developer/article/2347983
;;

;;; Code:
(require 'init-custom)

(use-package copilot
  :load-path (lambda () (expand-file-name "copilot" dragonli-emacs-tools-file-path))
  :ensure nil
  :hook
  (text-mode . copilot-mode)
  (prog-mode . copilot-mode)
  :config
  (defcustom copilot-log-max message-log-max
    "Max size of events buffer. 0 disables, nil means infinite."
    :group 'copilot
    :type 'integer
    )
  (setq copilot-indent-offset-warning-disable t) ;; 不打开这个会有警告，影响体验
  ;; complete by copilot first, then auto-complete
  (defun my-tab ()
    (interactive)
    (or (copilot-accept-completion)
	(ac-expand nil)))

  (with-eval-after-load 'auto-complete
    ;; disable inline preview
    (setq ac-disable-inline t)
    ;; show menu if have only one candidate
    (setq ac-candidate-menu-min 0))
  
  (define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
  (define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)
  ;; 由于 `lisp-indent-offset' 的默认值是 nil，在编辑 elisp 时每敲一个字
  ;; 符都会跳出一个 warning，将其默认值设置为 t 以永不显示这个 warning
  (setq-default copilot--indent-warning-printed-p t
		copilot-indent-offset-warning-disable t)

  ;; 文件超出 `copilot-max-char' 的时候不要弹出一个 warning 的 window
  (defun my-copilot-get-source-suppress-warning (original-function &rest args)
    "Advice to suppress display-warning in copilot--get-source."
    (cl-letf (((symbol-function 'display-warning) (lambda (&rest args) nil)))
      (apply original-function args)))
  (advice-add 'copilot--get-source :around #'my-copilot-get-source-suppress-warning)
  )

(provide 'init-copilot)
;;; init-copilot.el ends here
