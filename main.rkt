#lang at-exp codespells

(require hierarchy/mod-info)

#;
(define-classic-rune (test-cube)
  #:background "blue"
  #:foreground (square 40 'solid 'blue)
  (spawn-mod-blueprint pak-folder mod-name "TestCube"))
#;
(define-classic-rune (test-sphere)
  #:background "blue"
  #:foreground (circle 20 'solid 'blue)
  (spawn-mod-blueprint pak-folder mod-name "TestSphere"))
#;
(define-classic-rune (test-particles)
  #:background "blue"
  #:foreground (circle 20 'solid 'blue)
  (spawn-mod-blueprint pak-folder mod-name "TestParticles"))


(define (circle-stem)
  (above (circle 10 'solid 'cyan)
         (rectangle 4 10 'solid 'blue)))

(define (parentify-rune-image)
  (above
   (circle-stem)
   (rectangle 40 4 'solid 'blue)
   (flip-vertical (beside
                   (circle-stem)
                   (square 16 'solid 'transparent)
                   (circle-stem)))))

;Note for docs: In unreal parenting two physics objects doesn't join them together,
;  For that, you need a PhysicalConstraintActor.  That's beyond scope for this function.
;  See forces Mod.
(define-classic-rune (parentify parent . children)
  #:background "blue"
  #:foreground (parentify-rune-image)

  @unreal-js{
   (function(){
    var p = @(parent)
    var cs = [@(string-join
                (map (lambda (c)
                       (unreal-js-fragment-content
                        (at [0 0 0] (if (procedure? c)
                                       (c)
                                       c))))
                     children)
                ",")]

    cs.map((c)=>c.AttachActorToActor(p))
    
    return p
   })()
 })

(define-classic-rune-lang my-mod-lang #:eval-from main.rkt
  (parentify
   ;test-cube
   ;test-sphere
   ;test-particles
   ))


(module+ main
  (codespells-workspace ;TODO: Change this to your local workspace if different
   (build-path (current-directory) ".." ".."))

  (require codespells-server/unreal-client)
  #;(thread (thunk*
           (sleep 10)
           (unreal-eval-js
            (at [0 200 0] (parentify test-cube
                                     test-particles test-particles test-particles test-particles)))))
  
  (once-upon-a-time
   #:world (demo-world)
   #:aether (demo-aether
             #:lang (my-mod-lang #:with-paren-runes? #t))))
