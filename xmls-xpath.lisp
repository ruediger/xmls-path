(defpackage :xmls-xpath
  (:use :common-lisp :split-sequence)
  (:export "RESOLVE" "INSERT" "CREATE"))

(in-package :xmls-xpath)

(defun match (xmls xpath)
  (let ((nodes (split-sequence #\/ xpath :remove-empty-subseqs t)))
    ))

(defun create-nodes (lst &optional (value ""))
  "creates xmls-dom from xpath list representation

   input:  (a b c) <-- a/b/c
   output: (a (b (c)))

   the element is set to the value of `value'."
  (if lst
      (let ((parameter '(()))
	    (node '()))
	(if (and (> (length lst) 1)
		 (eq (aref (second lst) 0) #\@))
	    (setf parameter (list (list (list (subseq (second lst) 1) value))))
	    (setf node (list (create-nodes (rest lst) value))))
	(assert (not (string= (first lst) "")))
	(append (list (first lst)) parameter node))
      value))

(defun create (xpath &optional (value ""))
  ""
  (let ((nodes (split-sequence #\/ xpath :remove-empty-subseqs t)))
    (create-nodes nodes value)))

(defun insert (xmls xpath)
  )
