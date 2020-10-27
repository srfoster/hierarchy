#lang at-exp codespells

(define-classic-rune (test-cube)
  #:background "blue"
  #:foreground (square 40 'solid 'blue)
  (spawn-this-mod-blueprint "TestCube"))

(define-classic-rune (test-sphere)
  #:background "blue"
  #:foreground (circle 20 'solid 'blue)
  (spawn-this-mod-blueprint "TestSphere"))

(define-classic-rune (test-particles)
  #:background "blue"
  #:foreground (circle 20 'solid 'blue)
  (spawn-this-mod-blueprint "TestParticles"))




;Note for docs: In unreal parenting two physics objects doesn't join them together,
;  For that, you need a PhysicalConstraintActor.  That's beyond scope for this function.
;  See forces Mod.
(define-classic-rune (parentify parent . children)
  #:background "blue"
  #:foreground (above (circle 10 'solid 'blue)
                      (square 20 'solid 'blue))

  @unreal-js{
   (function(){
    var p = @(parent)
    var cs = [@(string-join
                (map (lambda (c)
                       (unreal-js-fragment-content
                        (at [0 0 0] (c))))
                     children)
                ",")]

    cs.map((c)=>c.AttachActorToActor(p))
    
    return p
   })()
 })

(define-classic-rune-lang my-mod-lang
  (parentify test-cube test-sphere test-particles))

(module+ main
  (codespells-workspace ;TODO: Change this to your local workspace if different
   (build-path (current-directory) ".." ".."))

  (require codespells-server/unreal-client)
  (thread (thunk*
           (sleep 10)
           (unreal-eval-js
            (at [0 200 0] (parentify test-cube
                                     test-particles test-particles test-particles test-particles)))))
  
  (once-upon-a-time
   #:world (demo-world)
   #:aether (demo-aether
             #:lang (my-mod-lang #:with-paren-runes? #t))))
