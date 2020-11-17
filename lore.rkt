#lang at-exp racket

(require hierarchy
	 codespells/lore)

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
 The first becomes the parent of the rest.}
      ))
  #:preview-image (parentify-rune))