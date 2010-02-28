;;; -*- Mode:Lisp; Syntax:ANSI-Common-Lisp; Coding:utf-8 -*-
(in-package :lla-unit-tests)
(in-readtable lla:v-syntax)

(deftestsuite adjustable-tests (lla-unit-tests)
  ()
  (:dynamic-variables 
   (*lift-equality-test* t))
  :equality-test #'x=)

(addtest (adjustable-tests)
  adjustable-numeric-vector
  (let ((v #v(1 2 3 4))
        (anv (make-anv :double 0 :default-expansion 0))
        (*lift-equality-test* #'x=))
    (add anv v)
    (ensure-same v anv)
    (ensure-same 4 (size anv))
    (adjust anv 2 t)
    (ensure-same 6 (size anv))
    (clear anv 3)
    (ensure-same anv #v(1))
    (shrink anv)
    (ensure-same 1 (size anv))
    (add anv #v(7 8 9))
    (add anv 11d0)
    (ensure-same anv #v(1 7 8 9 11))))

(addtest (adjustable-tests)
  row-adjustable-matrix
  (let ((m #2v(1 2 3 4))
        (a #v(5 6))
        (b #2v(7 8 9 10))
        (ram (make-ra-matrix :double 0 2))
        (*lift-equality-test* #'x=))
    (add ram m)
    (ensure-same ram m)
    (add ram b)
    (ensure-same ram (stack-vertically m b) :test #'x=)
    (clear ram (xdim b 1))
    (ensure-same ram m)
    (ensure-same (size ram) (+ (xdim m 1) (xdim b 1)))
    (shrink ram)
    (ensure-same ram m)
    (ensure-same (size ram) (xdim m 1))
    (add ram a)
    (ensure-same ram (stack-vertically m a))
    (ensure-same (size ram) (1+ (xdim m 1)))))


