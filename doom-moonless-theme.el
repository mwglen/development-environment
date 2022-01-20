;;; doom-moonless-theme.el -*- lexical-binding: t; no-byte-compile: t; -*-
(require 'doom-themes)

(defgroup doom-moonless-theme nil
  "Options for the `doom-moonless' theme."
  :group 'doom-themes)

(defcustom doom-moonless-uniform-font-size nil
  "If non-nil, all faces use the basic font size."
  :group 'doom-moonless-theme
  :type 'boolean)

(defcustom doom-moonless-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line. Can be an integer to
determine the exact padding."
  :group 'doom-moonless-theme
  :type '(choice integer boolean))

(def-doom-theme doom-moonless
  "A theme based off of the Doom Tomorrow Night and Doom Meltbus Themes"

  ;; name        gui       256       16
  ((bg         '("black"   nil       nil          ))
   ;(bg-alt     '("#161719" nil       nil          ))
   (bg-alt     '("black"   nil       nil          ))
   (base0      '("#0d0d0d" "black"   "black"      ))
   (base1      '("#1b1b1b" "#1b1b1b"              ))
   (base2      '("#212122" "#1e1e1e"              ))
   (base3      '("#292b2b" "#292929" "brightblack"))
   (base4      '("#3f4040" "#3f3f3f" "brightblack"))
   (base5      '("#5c5e5e" "#525252" "brightblack"))
   (base6      '("#757878" "#6b6b6b" "brightblack"))
   (base7      '("#969896" "#979797" "brightblack"))
   (base8      '("#ffffff" "#ffffff" "white"      ))
   (fg         '("#d5d8d6" "#d5d5d5" "white"))
   (fg-alt     (doom-darken fg 0.4))

   (black      '("black"   "black"   "black"))
   (white      '("#ffffff" "#ffffff" "white"))
   (grey       '("#5a5b5a" "#5a5a5a" "brightblack"))
   (red        '("#cc6666" "#cc6666" "red"))
   (orange     '("#de935f" "#dd9955" "brightred"))
   (yellow     '("#f0c674" "#f0c674" "yellow"))
   (green      '("#b5bd68" "#b5bd68" "green"))
   (blue       '("#81a2be" "#88aabb" "brightblue"))
   (dark-blue  '("#41728e" "#41728e" "blue"))
   (teal       blue) ; FIXME replace with real teal
   (magenta    '("#c9b4cf" "#c9b4cf" "magenta"))
   (violet     '("#b294bb" "#b294bb" "brightmagenta"))
   (cyan       '("#8abeb7" "#8abeb7" "cyan"))
   (dark-cyan  (doom-darken cyan 0.4))

   ;; "universal syntax classes"; *mandatory*
   (highlight      blue)
   (vertical-bar   base0)
   (selection      (doom-darken blue 0.5))
   (builtin        blue)
   (comments       grey)
   (doc-comments   (doom-lighten grey 0.14))
   (constants      orange)
   (functions      blue)
   (keywords       violet)
   (methods        blue)
   (operators      fg)
   (type           yellow)
   (strings        green)
   (variables      red)
   (numbers        orange)
   (region         selection)
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    green)
   (vc-added       green)
   (vc-deleted     red)
   (vc-conflict    magenta)

   ;; custom categories
   (modeline-bg     `(,(doom-darken (car bg-alt) 0.3) ,@(cdr base3)))
   (modeline-bg-alt `(,(car bg) ,@(cdr base1)))
   (modeline-fg     base8)
   (modeline-fg-alt comments)
   (-modeline-pad
    (when doom-moonless-padded-modeline
      (if (integerp doom-moonless-padded-modeline)
          doom-moonless-padded-modeline
        4))))

  ;; --- faces ------------------------------
  (((line-number &override) :foreground base4)
   ((line-number-current-line &override) :foreground blue :bold bold)
   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-alt :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-alt)))

   ;;;; rainbow-delimiters
   (rainbow-delimiters-depth-1-face :foreground violet)
   (rainbow-delimiters-depth-2-face :foreground blue)
   (rainbow-delimiters-depth-3-face :foreground orange)
   (rainbow-delimiters-depth-4-face :foreground green)
   (rainbow-delimiters-depth-5-face :foreground magenta)
   (rainbow-delimiters-depth-6-face :foreground yellow)
   (rainbow-delimiters-depth-7-face :foreground teal)
   (rainbow-delimiters-depth-8-face :inherit 'rainbow-delimiters-depth-2-face)
   (rainbow-delimiters-depth-9-face :inherit 'rainbow-delimiters-depth-3-face)
   (rainbow-delimiters-base-face :inherit 'default)

   ;;;; doom-modeline
   (doom-modeline-buffer-path       :foreground violet :bold bold)
   (doom-modeline-buffer-major-mode :inherit 'doom-modeline-buffer-path)

   ;;;; org <built-in> <modes:org-mode>
   (org-document-title :height (if doom-moonless-uniform-font-size 1.0 1.7)
                       :weight 'bold :slant 'normal)
   (org-block :foreground fg
              :background (doom-darken grey 0.8)
              :weight 'normal
              :slant 'normal
              :underline nil
              :inverse-video nil)

    ;;;; outline
   (outline-1 :height (if doom-moonless-uniform-font-size 1.0 1.5)
              :foreground fg
              :background bg :weight 'bold)
   (outline-2 :height (if doom-moonless-uniform-font-size 1.0 1.4)
              :foreground (doom-darken fg 0.2)
              :background black :weight 'bold)
   (outline-3 :height (if doom-moonless-uniform-font-size 1.0 1.3)
              :foreground (doom-darken fg 0.3)
              :background bg :weight 'bold)
   (outline-4 :height (if doom-moonless-uniform-font-size 1.0 1.2)
              :foreground (doom-darken fg 0.4)
              :background bg :weight 'bold)
   (outline-5 :height (if doom-moonless-uniform-font-size 1.0 1.1)
              :background bg
              :weight (if doom-moonless-uniform-font-size 'normal 'bold))
   (outline-6 :height (if doom-moonless-uniform-font-size 1.0 1.0)
              :foreground (if doom-moonless-uniform-font-size (doom-darken fg 0.2))
              :background bg
              :weight (if doom-moonless-uniform-font-size 'normal 'bold))
   (outline-7 :height (if doom-moonless-uniform-font-size 1.0 1.0)
              :foreground (if doom-moonless-uniform-font-size (doom-darken fg 0.3))
              :background bg :weight 'normal)
   (outline-8 :height (if doom-moonless-uniform-font-size 1.0 1.0)
              :foreground (if doom-moonless-uniform-font-size (doom-darken fg 0.4))
              :background bg :foreground base5 :weight 'normal)
   ;;;; which-key
   (which-key-key-face :foreground base5)
   (which-key-group-description-face :foreground base5)
   (which-key-command-description-face :foreground fg :weight 'bold)
   (which-key-local-map-description-face :foreground fg)

   ;;;; treemacs
   (treemacs-git-conflict-face :foreground vc-conflict)
   (treemacs-git-modified-face :foreground vc-modified)

   ;;;; flyspell
   (flyspell-incorrect :background red :foreground white :weight 'bold)
   (flyspell-duplicate :background blue :foreground white :weight 'bold)
   ))
;;; doom-moonless-theme.el ends here
