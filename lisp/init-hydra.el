;; init-hydra.el --- Initialize hydra configurations. -*- lexical-binding: t -*-

;;; Commentary:
;;
;; Nice looking hydras.
;; 借鉴自seagle0128的init-hydra.el
;; 自己将 hydra 和 pretty-hydra 包的引入放到 init-packages 中
;;

;;; Code:

(require 'init-custom)
(require 'init-funcs)

;; Emacs commands launcher
(with-no-warnings
  (pretty-hydra-define hydra-my-emacs-commands-launcher
    (:title (pretty-hydra-title "Emacs commands" 'fileicon "emacs" :face 'all-the-icons-purple :height 1.0 :v-adjust -0.15) :color teal :quit-key "q")
    ("Basic"
     (("t" emacs-init-time :color amaranch)
      ("c" eval-buffer)
      ("r" restart-emacs)
      ("e" save-buffers-kill-terminal)
      ("l" consult-goto-line)
      ("R" revert-buffer)
      ("F n" make-frame-command "make a new frame")
      ("F d" delete-frame)
      ("F f" toggle-frame-fullscreen "fullscreen")
      ("S" server-start)
      ("Q" server-shutdown)
      ("m" toggle-frame-maximized "maximized"))
     "Package & File"
     (("P i" package-install)
      ("P d" package-delete)
      ("P l" list-packages)
      ("f d" delete-file)
      ("f r" rename-file))
     "Shell & Avy"
     (("s h" consult-history)
      ("a c" avy-goto-char-timer)
      ("a l" avy-goto-line)
      ("a w" avy-goto-word-1)
      ("a h" avy-org-goto-heading-timer))
     )))
(global-set-key (kbd "s-1") 'hydra-my-emacs-commands-launcher/body)

;; Projectile commands launcher
(with-no-warnings
  (pretty-hydra-define hydra-my-project-command-launcher
    (:title (pretty-hydra-title "Project commands") :color teal :quit-key "q")
    ("Projectile"
     (("d" projectile-find-dir)
      ("F" project-find-file)
      ("f" projectile-find-file)
      ("t" projectile-find-tag)
      ("T" projectile-regenerate-tags) ;Regenerate the project’s [e|g]tags.
      ("R" projectile-recentf)
      ("s" projectile-switch-project))
     )))
(global-set-key (kbd "s-2") 'hydra-my-project-command-launcher/body)

;; Global toggles launcher
(with-no-warnings
  (pretty-hydra-define hydra-emacs-toggles
    (:title (pretty-hydra-title "Emacs toggles hydra" 'fileicon "emacs" :face 'all-the-icons-pink :height 1.0 :v-adjust -0.15)
	    :color amaranth :quit-key "q")
    ("Basic"
     (("n" (if (fboundp 'display-line-numbers-mode)
               (display-line-numbers-mode (if display-line-numbers-mode -1 1))
             (global-display-line-numbers-mode (if global-display-line-numbers-mode -1 1)))
       "line number"
       :toggle (or (bound-and-true-p display-line-numbers-mode) global-display-line-numbers-mode))
      ;;("a" global-aggressive-indent-mode "aggressive indent" :toggle t)
      ("b" display-battery-mode "battery" :toggle t)
      ("c" flyspell-mode "spell check" :toggle t)
      ("d" global-hungry-delete-mode "hungry delete" :toggle t)
      ("e" electric-pair-mode "electric pair" :toggle t)
      ("S" prettify-symbols-mode "pretty symbol" :toggle t)
      ("l" global-page-break-lines-mode "page break lines" :toggle t)
      ("i" display-time-mode "time" :toggle t)
      ("m" doom-modeline-mode "modern mode-line" :toggle t)
      ("C" column-number-mode :toggle t)
      ("s" size-indication-mode :toggle t)
      ("N" nyan-mode "nyan mode" :toggle t))
     "Package Archive"
     (("p m" (dragonli-set-package-archives 'melpa t)
       "melpa" :toggle (eq dragonli-package-archives 'melpa) :exit t)
      ("p c" (dragonli-set-package-archives 'emacs-cn t)
       "emacs-cn" :toggle (eq dragonli-package-archives 'emacs-cn) :exit t)
      ("p b" (dragonli-set-package-archives 'bfsu t)
       "bfsu" :toggle (eq dragonli-package-archives 'bfsu) :exit t)
      ("p n" (dragonli-set-package-archives 'netease t)
       "netease" :toggle (eq dragonli-package-archives 'netease) :exit t)
      ("p s" (dragonli-set-package-archives 'sjtu t)
       "sjtu" :toggle (eq dragonli-package-archives 'sjtu) :exit t)
      ("p t" (dragonli-set-package-archives 'tuna t)
       "tuna" :toggle (eq dragonli-package-archives 'tuna) :exit t)
      ("p u" (dragonli-set-package-archives 'ustc t)
       "ustc" :toggle (eq dragonli-package-archives 'ustc) :exit t)
      ("p T" (dragonli-test-package-archives t) "speed test" :exit t)))))
(global-set-key (kbd "s-3") 'hydra-emacs-toggles/body)

;; Refer to https://github.com/abo-abo/hydra/wiki/multiple-cursors
(with-no-warnings
  (pretty-hydra-define hydra-multiple-cursors
    (:color amaranth :quit-key "q")
    ("Multiple Cursors"
     (("l" mc/edit-lines :exit t)
      ("a" mc/mark-all-like-this :exit t)
      ("n" mc/mark-next-like-this)
      ("N" mc/skip-to-next-like-this)
      ("M-n" mc/unmark-next-like-this)
      ("p" mc/mark-previous-like-this)
      ("P" mc/skip-to-previous-like-this)
      ("M-p" mc/unmark-previous-like-this)
      ("|" mc/vertical-align)
      ("s" mc/mark-all-in-region-regexp :exit t)
      ("0" mc/insert-numbers :exit t)
      ("A" mc/insert-letters :exit t)
      ("<mouse-1>" mc/add-cursor-on-click)
      ;; Help with click recognition in this hydra
      ("<down-mouse-1>" ignore)
      ("<drag-mouse-1>" ignore)))))
(global-set-key (kbd "s-4") 'hydra-multiple-cursors/body)

;; Org mode commands launcher
(with-no-warnings
  (pretty-hydra-define hydra-my-org-launcher
    (:title (pretty-hydra-title "Org Commands" 'fileicon "org" :face 'all-the-icons-green :height 1.1 :v-adjust 0.0)
	    :color teal :quit-key "q")
    ("Basic"
     (("B" org-bars-mode "org bars" :toggle t :color amaranth)
      ;;("V" valign-mode "table optimization" :toggle t :color amaranch)
      ("N" org-num-mode :toggle t :color amaranch)
      ("z s" org-zotxt-mode :toggle t :color amaranch)
      ("z i" org-zotxt-insert-reference-link)
      ;;("i" org-indent-mode "org indent" :toggle t :color amaranth)
      ("f" org-fragtog-mode :toggle t :color amaranth)
      ("t" org-insert-structure-template "org template")
      ("b" org-mark-ring-goto)
      ("s t" org-set-tags-command)
      ("o c" open-init-org)
      
      ;; org agenda
      ;; ("c" org-capture)
      ;; ("R" org-refile)
      ;; ("s p" org-set-property)
      ;; ("C h" consult-org-heading)
      ;; ("C a" consult-org-agenda)

      ;; Org Image
      ("i t" org-toggle-inline-images "toggle images" :color amaranth)
      ("i d" org-display-inline-images)
      ("i D" org-download-delete)
      ("i p" org-download-clipboard)
      ("i r" org-download-rename-at-point) 
      )
     
     "Org Roam"
     (("r d" org-roam-dailies-goto-date "org roam dailies")
      ("r f" org-roam-node-find)
      ("r i" org-roam-node-insert)
      ("r a" org-roam-alias-add)
      ("r t" org-roam-tag-add)
      ("r u" org-roam-ui-open)
      ("r r" org-roam-refile)
      ("r b" org-mark-ring-goto :exit nil)
      ("o e" open-emacs-learning-note)
      ("o o" open-org-learning-note)
      ("o m" open-mac-learning-note)
      ("o d" open-org-roam-diary)
      ) 
     "LaTeX"
     (("l p" org-latex-preview :color amaranth)
      ("l m" cdlatex-math-symbol)
      ("l h" cdlatex-command-help)
      ("l e" cdlatex-environment))
     )))
(global-set-key (kbd "M-SPC") 'hydra-my-org-launcher/body)

(with-no-warnings
  (pretty-hydra-define hydra-undo-tree
    (:color amaranth :quit-key "q")
    ("Undo Tree"
     (("p" undo-tree-undo)
      ("n" undo-tree-redo)
      ("s" undo-tree-save-history)
      ("l" undo-tree-load-history)
      ("u" undo-tree-visualize "visualize" :exit t)))))
(global-set-key (kbd "C-x C-u") 'hydra-undo-tree/body)

(provide 'init-hydra)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-hydra.el ends here
