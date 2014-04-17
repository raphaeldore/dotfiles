(setq package-enable-at-startup nil)
(package-initialize)
(load-theme 'solarized-dark t)

(require 'package)
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)

;;
;; ace jump mode major function
;; 
(add-to-list 'load-path "/home/raph/.emacs.d/elpa/ace-jump-mode-20140207.530/ace-jump-mode.el")
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
;; you can select the key you prefer to
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

;; 
;; enable a more powerful jump back function from ace jump mode
;;
(autoload
  'ace-jump-mode-pop-mark
  "ace-jump-mode"
  "Ace jump back:-)"
  t)
(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)

(add-to-list 'load-path "~/.emacs.d/vendor/emacs-powerline")
(require 'powerline)
(setq powerline-arrow-shape 'arrow)

(custom-set-faces
 '(mode-line ((t (:foreground "#030303" :background "#bdbdbd" :box nil))))
 '(mode-line-inactive ((t (:foreground "#f9f9f9" :background "#666666" :box nil)))))

(load-library "iso-transl")

;; C-x ^ did not want to work, so I did a quick fix. TEMPORARY: 
(define-key global-map (kbd "C-x <dead-circumflex>") 'enlarge-window)
