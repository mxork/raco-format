#lang info

(define collection "raco-format")
(define deps '("base" "threading-lib" "gui-lib"))
(define pkg-desc "Format racket source files")
(define version "0.1")
(define pkg-authors '(mxork))

(define raco-commands
  '(("format" (submod raco-format main) "format racket source files" #f)))
