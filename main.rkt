#lang at-exp codespells

(require hierarchy/mod-info)

(provide rotation
         rotation-towards-player
         scale
         xyz-vector
         xy-vector)

(define (xyz-vector x y z)
  @unreal-js{
 (function(){
  return {X: @(~a x), Y: @(~a y), Z: @(~a z)}
  })
})

(define (xy-vector x y)
  @unreal-js{
 (function(){
  return {X: @(~a x), Y: @(~a y)}
  })
})

(define-classic-rune (scale vect obj)
  #:background "blue"
  #:foreground (circle 20 'solid 'cyan)
  (thunk
   @unreal-js{
 (function(){
  var a = @(if (procedure? obj)
               (obj)
               obj);
  a.SetActorScale3D(@vect(a));
  return a;
  })()
 }))

(define (rotation roll pitch yaw)
  @unreal-js{
 (function(){
  return {Roll: @(~a roll), Pitch: @(~a pitch), Yaw: @(~a yaw)}
  })
 })

(define (rotation-towards-player)
  @unreal-js{
 (function(a){   
  var p = GWorld.GetAllActorsOfClass(Root.ResolveClass('Avatar')).OutActors[0];
  let a_location = a.GetActorLocation();
  let p_location = p.GetActorLocation();
  let rot = KismetMathLibrary.FindLookAtRotation(a_location, p_location);

  return {Roll:0, Pitch:0, Yaw:rot.Yaw};
  })
 })

(define-classic-rune (turn rotation obj)
  #:background "blue"
  #:foreground (circle 20 'solid 'purple)
  (thunk
   @unreal-js{
 (function(){
  var a = @(if (procedure? obj)
               (obj)
               obj);
  a.SetActorRotation(@rotation(a));
  return a;
  })()
 }))

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

  ;TODO: This should probably return a thunk too.  Like spawner and trigger...
  @unreal-js{
   (function(){
    var p = @(if (procedure? parent)
                 (parent)
                 parent)
  var cs = [@(string-join
              (map (lambda (c)
                     (unreal-js-fragment-content
                      (at [0 0 0] (if (procedure? c)
                                      (c)
                                      c ;NOTE: If not a procedure, it will have the x/y/z of the top level (at []...)
                                      ;The one wrapping it in this function won't have any effect
                                      ;Should all runes return functions to unreal fragments?
                                      ;Except maybe asset runes -- because the are usually used w/o parens anyway
                                      ))))
                   children)
              ",")]

    cs.map((c)=>c.AttachActorToActor(p))
    
    return p
   })()
 })

(define-classic-rune-lang my-mod-lang #:eval-from main.rkt
  (parentify
   turn
   ;test-cube
   ;test-sphere
   ;test-particles
   ))


(module+ main
  (codespells-workspace ;TODO: Change this to your local workspace if different
   (build-path (current-directory) ".." ".."))

  (once-upon-a-time
   #:world (arena-world)
   #:aether (demo-aether
             #:lang (my-mod-lang #:with-paren-runes? #t))))
