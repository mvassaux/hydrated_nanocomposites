#lang racket

(define dry-all-mass 721241.66)
(define g-mass 72671.682)
(define epoxy-mass 648569.98)
(define 1-w-mass 18.01534)

(define (waterwt w-mass all-mass)
  (* (/ w-mass all-mass) 100))

(define (insert-w w-count target-wt sys-mass)
  (let ((w-mass (* w-count 1-w-mass)))
    (let ((wt (waterwt w-mass (+ sys-mass w-mass))))
      (if (> wt target-wt)
          (list w-count wt)
          (insert-w (+ w-count 1) target-wt sys-mass)))))


(let ((sys-mass epoxy-mass))
  (define wt-lst (map (lambda (target-wt) (insert-w 1 target-wt sys-mass)) (list 00.5 1 2 3 4 5)))
  (displayln "Epoxy")
  (displayln "w-count all-wt")
  (map displayln wt-lst))

(let ((sys-mass dry-all-mass))
  (define wt-lst (map (lambda (target-wt) (insert-w 1 target-wt sys-mass)) (list 00.5 1 2 3 4 5)))
  (displayln "Graphene")
  (displayln "w-count all-wt")
  (map displayln wt-lst))
