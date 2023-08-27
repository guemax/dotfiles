(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
	     '("gnu" . "https://elpa.gnu.org/packages/") t)

(package-install 'use-package)

(eval-when-compile
  (require 'use-package))

(use-package gruber-darker-theme
  :ensure t
  :config
  (load-theme 'gruber-darker t))
