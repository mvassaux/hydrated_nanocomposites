#!/usr/bin/env racket
#lang racket

(require math/statistics)

(define material-lst (cons "Graphene" "Epoxy"))
(define wt-lst (list 0 1 2 3 4 5))
(define tfinal-lst (list 300 300 300 300 300 300))
(define num-reps 10)

(define (density-read rep-path)
  (string->number (list-ref (string-split (last (file->lines rep-path))) 5)))

(define (density-gather material wt tfinal num-reps)
  (map
   (lambda (temp)
     (map (lambda (rep)
            (density-read (format "~a/wt-0~a.0/Serial/~a/~a/NPT-averages.txt" material wt rep temp)))
          (range 0 num-reps)))
   (inclusive-range 700 tfinal -10)))

(define (reps-stats material wt tfinal num-reps)
  (let ([density-lst (density-gather material wt tfinal num-reps)])
    (list (map mean density-lst) (map stddev density-lst))))

(define (write-stats material wt tfinal num-reps)

  (displayln (format "~a ~a" material wt))

  (define stats-lst (reps-stats material wt tfinal num-reps))

  (define out (open-output-file (format "Output/~a-~a-density.txt" material wt) #:exists 'replace))

  (display (format "Temp,Mean,SD\n") out)

  (define temp-range (inclusive-range 700 tfinal -10))
  (define mean-lst (car stats-lst))
  (define stddev-lst (second stats-lst))

  (for ([i (range (length temp-range))])
    (display
     (format "~a,~a,~a\n" (list-ref temp-range i) (list-ref mean-lst i) (list-ref stddev-lst i))
     out))

  (close-output-port out))

(map (lambda (wt tfinal) (write-stats "Graphene" wt tfinal num-reps)) wt-lst tfinal-lst)
(map (lambda (wt tfinal) (write-stats "Epoxy" wt tfinal num-reps)) wt-lst tfinal-lst)
