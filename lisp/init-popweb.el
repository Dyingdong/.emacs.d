;;; init.tools.el --- Initialize special tools configurations.
;; -*- lexical-binding: t -*-

;;; Commentary:
;;
;; init-tools.el 放置一些需要从网上下载package并手动放到.emacs.d中的插件
;;

;;; Code:
(require 'init-custom)

(add-to-list 'load-path (expand-file-name "popweb" dragonli-emacs-tools-file-path))

;; Org-Roam ID link and footnote link previewer
(add-to-list 'load-path "~/.emacs.d/tools/popweb/extension/org-roam")
(require 'popweb-org-roam-link)

;; LaTeX preview functionality
(add-to-list 'load-path "~/.emacs.d/tools/popweb/extension/latex")
(require 'popweb-latex)
(add-hook 'latex-mode-hook #'popweb-latex-mode)

;; Chinese-English translation popup
(add-to-list 'load-path "~/.emacs.d/tools/popweb/extension/dict") ;
(require 'popweb-dict)

;; Anki note review popup
(add-to-list 'load-path "~/.emacs.d/tools/popweb/extension/anki-review")
(require 'popweb-anki-review)

;; (setq popweb-python-command "/opt/miniconda3/bin/python3")

(provide 'init-popweb)
;;; init-popweb.el ends here
