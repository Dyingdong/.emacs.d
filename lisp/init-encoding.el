;;; init-encoding.el --- Encoding configurations. -*- lexical-binding: t -*-
;; 设置Emacs的编码

;;; Commentary:
;;
;; 借鉴：https://github.com/hick/emacs-chinese?tab=readme-ov-file
;;

;;; Code:

;; 设置编码
;; hick 个人的设置:
;; (set-default-coding-systems 'utf-8)

(set-charset-priority 'unicode)
(prefer-coding-system 'utf-8)
(setq system-time-locale "C")

;; https://github.com/hick/emacs-chinese
;; 解决中文路径问题
;; UTF-8 编码在 MS-Windows 环境下是 「二等公民」, 特别是与命令行工具进行交互作时, 如果设置了使用 UTF-8 编码会导致 Windows 自带程序输出乱码. Emacs的默认设置已经尝试对此类情况进行了处理, 下面的代码在默认设置的基础上设置 cmdproxy.exe 使用GBK编码, 进一步减少设置 UTF-8 编码的副作用:
(when (eq system-type 'windows-nt)
  (set-default 'process-coding-system-alist
	       '(("[pP][lL][iI][nN][kK]" gbk-dos . gbk-dos)
		 ("[cC][mM][dD][pP][rR][oO][xX][yY]" gbk-dos . gbk-dos))))

;; (set-file-name-coding-system 'cp936)
;; ;; (setq w32-unicode-filenames nil)
;; (setq default-file-name-coding-system 'gbk)

(provide 'init-encoding)
;;; init-encoding.el ends here
