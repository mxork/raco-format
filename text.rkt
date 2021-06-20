#lang racket/gui

(provide remove-whitespace%)

(require framework)

(define remove-whitespace%
  (class racket:text% (super-new)
    (define/public (remove-trailing-whitespace-all) (remove-trailing-whitespace-select 0 (send this last-position)))
    (define/private (remove-trailing-whitespace-select [start (send this get-start-position)]
                                                       [end (send this get-end-position)])
      (define first-para (send this position-paragraph start))
      (define end-para (send this position-paragraph end))
      (define tabifying-multiple-paras? (not (= first-para end-para)))
      (with-handlers ([exn:break?
                       (λ (x) #t)])
        (dynamic-wind
         (λ ()
           (when (< first-para end-para)
             (begin-busy-cursor))
           (send this begin-edit-sequence))
         (λ ()
           (let loop ([para first-para])
             (when (<= para end-para)
               (define start (send this paragraph-start-position para))
               (define end (send this paragraph-end-position para))
               (define skip-this-line?
                 (and tabifying-multiple-paras?
                      (for/and ([i (in-range start (+ end 1))])
                        (char-whitespace? (send this get-character i)))))
               (unless skip-this-line?
                 (remove-trailing-whitespace start))
               (parameterize-break #t (void))
               (loop (add1 para))))
           (when (and (>= (send this position-paragraph start) end-para)
                      (<= (send this skip-whitespace (send this get-start-position) 'backward #f)
                          (send this paragraph-start-position first-para)))
             (send this set-position
                   (let loop ([new-pos (send this get-start-position)])
                     (if (let ([next (send this get-character new-pos)])
                           (and (char-whitespace? next)
                                (not (char=? next #\newline))))
                         (loop (add1 new-pos))
                         new-pos)))))
         (λ ()
           (send this end-edit-sequence)
           (when (< first-para end-para)
             (end-busy-cursor))))))
    (define (remove-trailing-whitespace [pos (send this get-start-position)])
      (define line (send this position-line pos))
      (define line-start (send this line-start-position line))
      (define line-end (send this line-end-position line))
      (define (do-remove line)
        (define para (send this position-paragraph pos))
        (define end (send this paragraph-start-position para))
        (send this delete line-start line-end)
        (send this insert (string-trim line #px"\\s+" #:left? #f) end))
      (do-remove (send this get-text line-start line-end)))))