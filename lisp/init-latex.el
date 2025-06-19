;;; init-latex.el --- Initialize latex configurations. -*- lexical-binding: t -*-

;;; Commentary:
;;
;; Latex configurations.
;;

;;; Code:

(unless (package-installed-p 'auctex)
  (package-install 'auctex))

(require 'tex)


;; (add-to-list 'TeX-view-program-list '("eaf" eaf-pdf-synctex-forward-view))
;; (add-to-list 'TeX-view-program-selection '(output-pdf "eaf"))

(setq TeX-view-program-selection '((output-pdf "PDF Viewer")))


(setq TeX-PDF-mode t)

(setq TeX-view-program-list
      '(("PDF Viewer" "/Applications/Skim.app/Contents/SharedSupport/displayline -b -g %n %o %b")))

(eval-after-load 'tex
  '(progn
     (assq-delete-all 'output-pdf TeX-view-program-selection)
     (add-to-list 'TeX-view-program-selection '(output-pdf "PDF Viewer"))
     ))

(add-hook 'LaTeX-mode-hook
          #'(lambda ()
              (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex --synctex=1%(mode)%' %t" TeX-run-TeX nil t))
              (setq TeX-command-extra-options "-file-line-error -shell-escape")
              (setq TeX-command-default "xetex")
              (setq TeX-save-query  nil ) ;; 不需要保存即可编译
              ))

(custom-set-variables
 '(TeX-source-correlate-method 'synctex)
 '(TeX-source-correlate-mode t)
 '(TeX-source-correlate-start-server t))

(use-package cdlatex
  ;;:load-path (lambda () (expand-file-name "cdlatex" dragonli-emacs-tools-file-path))
  ;;"~/.emacs.d/tools/cdlatex"
  :ensure t
  :defer t
  :init
  ;; (add-hook 'org-mode-hook #'turn-on-org-cdlatex)
  ;; (add-hook 'org-mode-hook #'turn-on-cdlatex)
  ;; (add-hook 'LaTeX-mode-hook #'turn-on-cdlatex)   ; with AUCTeX LaTeX mode
  ;; (add-hook 'latex-mode-hook #'turn-on-cdlatex)   ; with Emacs latex mode
  ;; (add-hook 'tex-mode-hook 'turn-on-cdlatex)   ; with Emacs latex mode
  :config
  (define-key cdlatex-mode-map (kbd "TAB") nil)
  (define-key cdlatex-mode-map (kbd "C-<tab>") 'cdlatex-tab)
  )
(provide 'init-latex)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-latex.el ends here
