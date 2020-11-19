#lang at-exp racket

(require codespells/lore
         (only-in codespells append-rune-langs
                             require-mod))

(require-mod hierarchy)
(require-mod fire-particles)
(require-mod ice-particles)
(require-mod rocks)

(define-rune-collection-lore 
  #:name "Translocation and Unification"
  #:description 
  @md{
 The @b{Translocation and Unification} Rune Collection was crafted by the @b{1st Arch Mage} of the @b{Low Stacks Academy}.
 For many years, these runes have been taught to students at the Academy in their first year.
}
  #:rune-lores
  (list
    (rune-lore
      #:name "Unite"
      #:rune (parentify-rune)
      #:description @md{This rune creates a parent-child relationship between whatever is spawned by subsequent runes in the spell expression.
      The first becomes the parent of the rest.
      @(rune-code-example
         (append-rune-langs
           #:name #f 
           (hierarchy:my-mod-lang)
           (ice-particles:my-mod-lang)
           (fire-particles:my-mod-lang #:with-paren-runes? #t))
         (parentify 
           ice-aura
           fire-beam
           )
         hierarchy-demo-1.mp4)
      
      You can unite more than 2 runes! Try 3 or more.

      @(rune-code-example
         (append-rune-langs
           #:name #f 
           (rocks:my-mod-lang)
           (ice-particles:my-mod-lang)
           (hierarchy:my-mod-lang)
           (fire-particles:my-mod-lang #:with-paren-runes? #t))
         (parentify 
           forest-rock
           flames
           ice-ball
           )
         hierarchy-demo-2.mp4)}
  ))
  #:preview-image preview.png)
