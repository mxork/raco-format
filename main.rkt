#lang racket/base

(require framework
         racket/class
         racket/port)

(provide indent-source)

(define (indent-source (the-port (current-input-port)))
  (define the-input (port->string the-port))
  (define the-text (new racket:text%))
  (send the-text insert the-input 0)
  (send the-text tabify-all)
  (void (write-string (send the-text get-text))))

(define (find-in-directory d)
  (for/list ([p (in-directory d)]
             #:when (and (file-exists? p) (regexp-match #px".*.rkt$" p)))
    p))

(module+ main
  (require racket/vector racket/set racket/list threading)
  (define target-paths (current-command-line-arguments))
  (cond
    [(vector-empty? target-paths) (indent-source)]
    [else
     (define target-files
       (~> (for/list ([p target-paths])
             (cond
               [(file-exists? p) p]
               [(directory-exists? p) (find-in-directory p)]
               [else (eprintf "~a: does not exist, skipping.\n" p) #f]))
           flatten
           (filter (lambda (v) v) _)
           list->set
           set->list
           (sort _ path<?)))

     (for ([target-file target-files])
       (eprintf "~a\n" target-file)
       (define output
         (with-input-from-file target-file
           (lambda () (with-output-to-string indent-source))))
       (with-output-to-file target-file
                            (lambda () (write-string output))
                            #:exists 'truncate/replace))]))
