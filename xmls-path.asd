; Copyright (C) 2006 by Rüdiger Sonderfeld <ruediger@c-plusplus.de>
;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-

; Special Thanks to Edward Marco Baringer for his help on #lisp on FreeNode
; about setting up a testing environment and his unit test framework FiveAM

(eval-when (:compile-toplevel :load-toplevel :execute)
  (unless (find-package :xmls-path-system)
    (defpackage :xmls-path-system
      (:documentation "ASDF System package for XMLS-PATH")
      (:use :common-lisp :asdf))))

(in-package :xmls-path-system)

(defsystem xmls-path
  :name "xmls-path"
  :version "0.01"
  :maintainer "Rüdiger Sonderfeld <ruediger@c-plusplus.de>"
  :author "Rüdiger Sonderfeld <ruediger@c-plusplus.de>"
  :licence ""
  :description "XMLS-PATH - lisp style xpath-derivate"
  :long-description "XMLS-PATH - lisp style xpath-derivate"
  :serial t
  :components ((:file "package")
	       (:file "xmls-path")))

(defsystem xmls-path-test
  :components ((:module :unit-tests
		:components ((:file "unit-test-suite")
			     (:file "match-test"))))
  :depends-on (:xmls-path :FiveAM))

(defmethod asdf:perform :after ((op asdf:test-op)
			 (system (eql (asdf:find-system :xmls-path))))
  (asdf:oos 'asdf:load-op :xmls-path-test)
  (funcall (intern (string :run!) (string :it.bese.FiveAM)) :xmls-path))

(defmethod asdf:operation-done-p ((op asdf:test-op)
				  (c asdf:component))
  (declare (ignore op c))
  nil)
