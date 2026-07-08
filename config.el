;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setenv "LSP_USE_PLISTS" "true")

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:

;; (setq doom-font (font-spec :family "MonoLisa Variable" :size 12 :weight 'semi-light))
(setq doom-font (font-spec :family "Monaspace Neon" :size 12))
(setq doom-symbol-font (font-spec :family "Symbols Nerd Font Mono"))

(after! ligature
  (ligature-set-ligatures 'prog-mode
                          '("---" "'''" "\"\"\"" "..." "..<" "..=" "{|" "[|" ".?" "::" ":::" "::="
                            ":=" ":>" ":<" ";;" "!!" "!!." "!!!" "?." "?:" "??" "?=" "**" "***"
                            "*>" "*/" "--" "-=" "*=" "+=" "%=" "#:" "#!" "#?" "#=" "/*" "///" "//"
                            "/**" "$(" ">&" "<&" "&&" "|}" "|]" "$>" ".." ".=" "++" "+++" "+>"
                            "=:=" "=!=" ">:" ">>" ">(" ">>>" "<(" "<:" "<*" "<*>" "<$" "<$>" "<+"
                            "<+>" "<>" "<<" "<<<" "^=" "%%"
                            "<!---" "--->" "|||>" "<!--" "<|||" "<==>" ">>>=" "-->" "->>" "-<<"
                            "!==" "#_(" "##" "###" "####" "/==" "||>" "||=" "|->" "&=" "&^=" "&^"
                            "===" "==>" "=>>" "=<<" "=/=" ">->" ">=>" ">>-" ">>=" "<--" "<->"
                            "<-<" "<||" "<|>" "<==" "<=>" "<=<" "<<-" "<<=" "<~>" "<~~" "~~>"
                            ">&-" "<&-" "&>>" "&>" "->" "-<" "-~" "!=" "#_" "/>" "/=" "|=" "|>"
                            "==" "=>" ">-" "<-" "<|" "<~" "</" "</>" "~-" "~@" "~=" "~>" "~~"
                            "<=" ">="))
  (global-ligature-mode t))

;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one-light)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; (use-package demap
;;   :ensure t
;;   :config
;;   (add-hook 'window-setup-hook #'demap-toggle))

;; bind s to avy
(remove-hook 'doom-first-input-hook #'evil-snipe-mode)
(map! :n "s" #'evil-avy-goto-char-timer)

;; Stop Doom from automatically continuing comments on a new line
(advice-remove 'newline-and-indent #'+default--newline-indent-and-continue-comments-a)
;; 1. When pressing RET in insert mode (Doom advises `newline-and-indent')
(setq +default-want-RET-continue-comments nil)
;; 2. When using evil's `o'/`O' to open a line from within a comment
(setq +evil-want-o/O-to-continue-comments nil)

;; expand selection based on tree sitter
(use-package! expreg
  :config
  (map! :v "v" #'expreg-expand
        :v "-" #'expreg-contract))

;; formatting elisp
(use-package! elisp-autofmt
  :hook (emacs-lisp-mode . elisp-autofmt-mode))

;; mason setup
(use-package! mason
  :config
  (mason-setup))

(mason-setup
  (dolist (pkg '("tidy" "stylelint" "typescript-language-server" "vtsls" "oxlint" "oxfmt" "prettier" "tailwindcss-language-server" "cspell" "cspell-lsp"))
    (unless (mason-installed-p pkg)
      (ignore-errors (mason-install pkg)))))

;; setup vtsls
(use-package! lsp-vtsls
  :after lsp-mode
  :config
  (setq lsp-eldoc-render-all t          ; show all LSP doc in the minibuffer
        lsp-vtsls-server-side-fuzzy-match t  ; offload fuzzy filtering to the server
        lsp-vtsls-entries-limit 10))    ; cap completion entries (see vtsls' own perf notes)

;; setup jtsx
(use-package jtsx
  :ensure t
  :mode (("\\.jsx\\'" . jtsx-jsx-mode)
         ("\\.tsx\\'" . jtsx-tsx-mode)
         ("\\.ts\\'" . jtsx-typescript-mode))
  :hook ((jtsx-jsx-mode . hs-minor-mode)
         (jtsx-tsx-mode . hs-minor-mode)
         (jtsx-typescript-mode . hs-minor-mode))
  :config
  (setq jtsx-enable-jsx-element-tags-auto-sync t)
  (defun jtsx-bind-keys-to-mode-map (mode-map)
    "Bind keys to MODE-MAP."
    (define-key mode-map (kbd "C-c C-j") 'jtsx-jump-jsx-element-tag-dwim)
    (define-key mode-map (kbd "C-c j o") 'jtsx-jump-jsx-opening-tag)
    (define-key mode-map (kbd "C-c j c") 'jtsx-jump-jsx-closing-tag)
    (define-key mode-map (kbd "C-c j r") 'jtsx-rename-jsx-element)
    (define-key mode-map (kbd "C-c <down>") 'jtsx-move-jsx-element-tag-forward)
    (define-key mode-map (kbd "C-c <up>") 'jtsx-move-jsx-element-tag-backward)
    (define-key mode-map (kbd "C-c C-<down>") 'jtsx-move-jsx-element-forward)
    (define-key mode-map (kbd "C-c C-<up>") 'jtsx-move-jsx-element-backward)
    (define-key mode-map (kbd "C-c C-S-<down>") 'jtsx-move-jsx-element-step-in-forward)
    (define-key mode-map (kbd "C-c C-S-<up>") 'jtsx-move-jsx-element-step-in-backward)
    (define-key mode-map (kbd "C-c j w") 'jtsx-wrap-in-jsx-element)
    (define-key mode-map (kbd "C-c j u") 'jtsx-unwrap-jsx)
    (define-key mode-map (kbd "C-c j d n") 'jtsx-delete-jsx-node)
    (define-key mode-map (kbd "C-c j d a") 'jtsx-delete-jsx-attribute)
    (define-key mode-map (kbd "C-c j t") 'jtsx-toggle-jsx-attributes-orientation)
    (define-key mode-map (kbd "C-c j h") 'jtsx-rearrange-jsx-attributes-horizontally)
    (define-key mode-map (kbd "C-c j v") 'jtsx-rearrange-jsx-attributes-vertically))

  (defun jtsx-bind-keys-to-jtsx-jsx-mode-map ()
    (jtsx-bind-keys-to-mode-map jtsx-jsx-mode-map))
  (defun jtsx-bind-keys-to-jtsx-tsx-mode-map ()
    (jtsx-bind-keys-to-mode-map jtsx-tsx-mode-map))

  (add-hook 'jtsx-jsx-mode-hook 'jtsx-bind-keys-to-jtsx-jsx-mode-map)
  (add-hook 'jtsx-tsx-mode-hook 'jtsx-bind-keys-to-jtsx-tsx-mode-map)
  ;; run lsp on jtsx files
  (add-hook 'jtsx-jsx-mode-hook #'lsp-deferred)
  (add-hook 'jtsx-tsx-mode-hook #'lsp-deferred)
  (add-hook 'jtsx-typescript-mode-hook #'lsp-deferred)
  )

(after! (lsp-mode jtsx)
  (add-to-list 'lsp-language-id-configuration
               (cons 'jtsx-jsx-mode (alist-get 'js-ts-mode lsp-language-id-configuration)))
  (add-to-list 'lsp-language-id-configuration
               (cons 'jtsx-tsx-mode (alist-get 'tsx-ts-mode lsp-language-id-configuration)))
  (add-to-list 'lsp-language-id-configuration
               (cons 'jtsx-typescript-mode (alist-get 'typescript-ts-mode lsp-language-id-configuration)))
  )

(map! :map (jtsx-jsx-mode-map jtsx-tsx-mode-map)
      :n "gcc" #'jtsx-comment-line
      :v "gc"  #'jtsx-comment-dwim)

(after! flycheck
  (dolist (mode '(jtsx-jsx-mode jtsx-tsx-mode jtsx-typescript-mode))
    (flycheck-add-mode 'javascript-oxlint mode)))

;; (after! flycheck
;;   (defvar +oxlint-config-names
;;     '(".oxlintrc.json" "oxlint.config.ts" "oxlint.config.js" "oxlint.config.mjs")
;;     "Filenames that count as an oxlint config being present.")
;;   (setf (flycheck-checker-get 'javascript-oxlint 'predicate)
;;         (lambda ()
;;           (and buffer-file-name
;;                (locate-dominating-file
;;                 default-directory
;;                 (lambda (dir)
;;                   (seq-some (lambda (f) (file-exists-p (expand-file-name f dir)))
;;                             +oxlint-config-names)))))))

(after! lsp-mode
  (defvar +oxlint-config-files
    '(".oxlintrc.json" "oxlint.json" "oxlint.config.ts"))

  (defun +oxlint-config-present-p ()
    "Non-nil if an oxlint config is found in or above the buffer's directory."
    (when buffer-file-name
      (locate-dominating-file
       buffer-file-name
       (lambda (dir)
         (seq-some (lambda (f) (file-exists-p (expand-file-name f dir)))
                   +oxlint-config-files)))))

  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection '("oxlint" "--lsp"))
    :major-modes '(js-mode js2-mode rjsx-mode js-jsx-mode
                   typescript-mode typescript-tsx-mode web-mode)
    :activation-fn (lambda (filename _mode) (+oxlint-config-present-p))
    :add-on? t          ; run alongside ts-ls/tsserver, don't replace it
    :priority -1
    :server-id 'oxlint-ls)))

;; disable lsp based formatting for js files
(setq-hook! '(typescript-ts-mode-hook tsx-ts-mode-hook typescript-mode-hook js-ts-mode-hook
              jtsx-jsx-mode-hook jtsx-tsx-mode-hook jtsx-typescript-mode-hook)
  +format-with-lsp nil)

(defun my/apheleia-choose-formatter ()
  "Dynamically choose between oxfmt and prettier for web and JS modes."
  (when (and (buffer-file-name)
             (not (file-remote-p (buffer-file-name)))
             ;; Only execute for JS, TS, React, or Vue modes
             (derived-mode-p 'js-mode 'js2-mode 'typescript-mode 'typescript-ts-mode 'rjsx-mode 'web-mode 'jtsx-jsx-mode 'jtsx-tsx-mode 'jtsx-typescript-mode)
             )
    (let* ((root (doom-project-root))
           ;; Define check paths for oxfmt config
           (oxfmt-cfg (or (locate-file ".oxfmtrc" (list root))
                          (locate-file ".oxfmtrc.json" (list root))
                          (locate-file ".oxfmtrc.jsonc" (list root))))
           ;; Define check paths for prettier config
           (prettier-cfg (or (locate-file ".prettierrc" (list root))
                             (locate-file ".prettierrc.json" (list root))
                             (locate-file ".prettierrc.js" (list root))
                             (locate-file ".prettierrc.mjs" (list root))
                             (locate-file "prettier.config.js" (list root)))))
      (cond
       ;; If oxfmt config exists, use oxfmt
       (oxfmt-cfg
        (setq-local apheleia-formatter 'oxfmt))
       ;; If prettier config exists (or no oxfmt config), use prettier
       (prettier-cfg
        (setq-local apheleia-formatter 'prettier))))))

;; activate formatter conditionally
(add-hook 'apheleia-mode-hook #'my/apheleia-choose-formatter)

;; eslint config for lsp-mode
(after! lsp-mode
  (setq lsp-eslint-auto-fix-on-save t))   ; run eslint --fix on save

(defun my/eslint-config-present-p (dir)
  (seq-some
   (lambda (file)
     (locate-dominating-file dir file))
   '("eslint.config.js"
     "eslint.config.cjs"
     "eslint.config.mjs"
     "eslint.config.ts"
     ".eslintrc"
     ".eslintrc.js"
     ".eslintrc.cjs"
     ".eslintrc.json"
     ".eslintrc.yaml"
     ".eslintrc.yml")))

(defun my/lsp-toggle-eslint-by-root-config ()
  "Disable eslint client if no configuration file exists in the project root."
  (when (lsp-workspace-root)
    (let* (
           ;; Check if at least one config file exists in the root directory
           (has-config (my/eslint-config-present-p (lsp-workspace-root))))
      (if has-config
          ;; Enable ESLint by removing it from the disabled list
          (setq-local lsp-disabled-clients (delete 'eslint lsp-disabled-clients))
        ;; Disable ESLint if no config file is found
        (add-to-list 'lsp-disabled-clients 'eslint)))))

;;   (defun +eslint-config-present-p ()
;;     "Non-nil if an ESLint config is found in or above the current buffer's directory."
;;     (when buffer-file-name
;;       (locate-dominating-file
;;        buffer-file-name
;;        (lambda (dir)
;;          (or (seq-some (lambda (f) (file-exists-p (expand-file-name f dir)))
;;                        +eslint-config-files)
;;              (let ((pkg (expand-file-name "package.json" dir)))
;;                (and (file-exists-p pkg)
;;                     (with-temp-buffer
;;                       (insert-file-contents pkg)
;;                       (ignore-errors
;;                         (plist-member
;;                          (json-parse-string (buffer-string) :object-type 'plist)
;;                          :eslintConfig))))))))))

;;   (defun +eslint-maybe-disable-h ()
;;     "Disable the eslint LSP client for this buffer if no config file is found."
;;     (unless (+eslint-config-present-p)
;;       (setq-local lsp-disabled-clients (cons 'eslint lsp-disabled-clients))))

;;   (add-hook! '(js-mode-hook js2-mode-hook rjsx-mode-hook typescript-mode-hook
;;                typescript-tsx-mode-hook web-mode-hook jtsx-jsx-mode-hook jtsx-tsx-mode-hook jtsx-typescript-mode-hook)
;;              #'+eslint-maybe-disable-h)
;;   )

;; disable eslint based on root config file
(use-package lsp-mode
  :hook (lsp-before-initialize . my/lsp-toggle-eslint-by-root-config))

(use-package projectile
  :hook (projectile-after-switch-project . my/lsp-toggle-eslint-by-root-config))

;; auto complete config
(after! lsp-mode
  (setq lsp-enable-text-document-color t))

(use-package! kind-icon
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(add-hook! (web-mode rjsx-mode css-mode jtsx-jsx-mode jtsx-tsx-mode jtsx-typescript-mode) #'rainbow-mode)

;; tailwindcss
(after! lsp-mode
  (setq lsp-tailwindcss-add-on-mode t))

(after! (corfu kind-icon)
  (defun +corfu-tailwind-color-margin (metadata)
    (let ((kind-fn (kind-icon-margin-formatter metadata)))
      (lambda (cand)
        (if-let* ((item (get-text-property 0 'lsp-completion-item cand))
                  (doc (and item (lsp:completion-item-documentation? item)))
                  (hex (cond ((stringp doc) doc)
                             (doc (ignore-errors (lsp:markup-content-value doc)))))
                  ((string-match-p "^#[0-9a-fA-F]\\{3,8\\}$" (string-trim hex))))
            (propertize "  " 'face (list :background (string-trim hex)))
          (funcall kind-fn cand)))))

  (add-to-list 'corfu-margin-formatters #'+corfu-tailwind-color-margin))

;; fuzzy suggestion filtering
(after! orderless
  (setq orderless-matching-styles
        '(orderless-flex          ; fuzzy subsequence matching, e.g. "abc" matches "aXbYc"
          orderless-regexp
          orderless-prefixes))
  ;; component separator so you can combine styles: "foo bar" matches both as separate fuzzy chunks
  (setq orderless-component-separator #'orderless-escapable-split-on-space))

;; claude
(use-package! claude-code-ide
  :bind ("C-c C-'" . claude-code-ide-menu) ; Set your favorite keybinding
  :config
  (claude-code-ide-emacs-tools-setup)) ; Optionally enable Emacs MCP tools

;; cspell
(after! lsp-mode
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection '("cspell-lsp" "--stdio"))
    :major-modes '(text-mode markdown-mode org-mode gfm-mode
                   prog-mode)   ; prog-mode covers most programming major modes
    :add-on? t                 ; run alongside your main LSP server, not instead of it
    :priority -1
    :server-id 'cspell-lsp)))

;; magit
(setq magit-process-popup-on-error t)

;; disable smartparens for jsx
(after! (:and smartparens jtsx )
  (sp-local-pair '(jtsx-jsx-mode jtsx-tsx-mode jtsx-typescript-mode)
                 "<" ">" :actions nil))
;; for html
(after! (:and smartparens web-mode)
  (sp-local-pair '(web-mode html-mode mhtml-mode nxml-mode)
                 "<" ">" :actions nil))
(after! web-mode
  (setq web-mode-enable-auto-closing t
        web-mode-enable-auto-pairing t
        web-mode-auto-close-style 2
        web-mode-enable-auto-quoting t))

;; lsp booster
(defun lsp-booster--advice-json-parse (old-fn &rest args)
  "Try to parse bytecode instead of json."
  (or
   (when (equal (following-char) ?#)
     (let ((bytecode (read (current-buffer))))
       (when (byte-code-function-p bytecode)
         (funcall bytecode))))
   (apply old-fn args)))
(advice-add (if (progn (require 'json)
                       (fboundp 'json-parse-buffer))
                'json-parse-buffer
              'json-read)
            :around
            #'lsp-booster--advice-json-parse)

(defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
  "Prepend emacs-lsp-booster command to lsp CMD."
  (let ((orig-result (funcall old-fn cmd test?)))
    (if (and (not test?)                             ;; for check lsp-server-present?
             (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
             lsp-use-plists
             (not (functionp 'json-rpc-connection))  ;; native json-rpc
             (executable-find "emacs-lsp-booster"))
        (progn
          (when-let ((command-from-exec-path (executable-find (car orig-result))))  ;; resolve command from exec-path (in case not found in $PATH)
            (setcar orig-result command-from-exec-path))
          (message "Using emacs-lsp-booster for %s!" orig-result)
          (cons "emacs-lsp-booster" orig-result))
      orig-result)))
(advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)
