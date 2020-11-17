#lang racket

(provide mod-name pak-folder main.rkt)

(require racket/runtime-path)

(define
  mod-name
  "Hierarchy")

(define-runtime-path
  pak-folder
  "BuildUnreal/WindowsNoEditor/Hierarchy/Content/Paks/")

(define-runtime-path
  main.rkt
  "main.rkt")