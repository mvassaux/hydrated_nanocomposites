#!/usr/bin/env racket
#lang racket

(require math/statistics)

(define material-lst (cons "Graphene" "Epoxy"))
(define wt-lst (list 0 1 2 3 4 5))
(define rep-lst (list 1 1 1 1 10 10))
(define num-reps 10)


(define e-rep-lst (list 1 1 1 1 10 10))

(define (read-properties p-path)

  (displayln p-path)

  )


(read-properties "Epoxy/wt-00.0/Modulus/0/rep-0/p_properties.txt")
