(in-package :xmls-path)

; Description
;
; (match '("node0" ("node1" ("node2")))
;        <node0><node1><node2/></node1></node0>) => t
;
; (match '(("node0" "http://foo.net") ("node1" nil))
;        <foo:node0 xmlns:foo="http://foo.net">
;        <bar:node1 xmlns:bar="http://bar.net" /></foo:node0>) => t
;
; (match '("node0" ("node1" :attribute))
;        <node0 node1="holla"/>) => t
;
; (match '(:any ("node0" ("node1"  ("node2"))))
;        <foo><node0><node1><node2/></node1></node0></foo>) => t
;
; (match '("node0" (:any ("node1"))) 
;
; (match '("node0" (:bind :text node0-text) ("node1" (:bind :attribute "foo" node1-foo))) <node0>bla<node1 foo="hallo"></node0>) => ((node0-text . "bla") (node1-foo . "hallo"))

; :any, :any-repeat
; :attribute, :bind, :text

(defun next-node (path)
  (case (length path)
    (3 (third path))
    (2 (second path))))
;; Optimize:
;; (cond ((null l) #|0|# ...) ((null (cdr l)) #|1|# ...) ((null (cddr l)) #|2|# ...) ((null (cdddr l)) #|3|# ...) (t ...))

(defun node-equal (path xmls)
  (or
   (and (consp (first xmls)) (consp (first path))
	(equal (first xmls) (first path)))
   (and (consp (first xmls)) (not (consp (first path)))
	(string= (car (first xmls)) (first path)))
   (and (not (consp (first xmls))) (string= (first path) (first xmls)))))

(defun match (path xmls &key (matches nil) (attr-matches nil) (any-repeat nil))
  "returns t if path is found in xmls"
  (unless matches
    (setq matches (list xmls)))
  (if path
      (case (car path)
	(:any
	 (unless (equal matches '(()))
	   (match (next-node path) xmls
		  :matches (loop for i in matches
			      with ret = nil
			      do (setq ret (append ret (cddr i)))
			      finally (return ret))
		  :attr-matches (loop for i in matches collect (second i)))))
	(:any-repeat (match (next-node path) xmls :matches matches
			    :attr-matches attr-matches
			    :any-repeat t))
	(otherwise
	 (format t "attrs ~A matches ~A~%" attr-matches matches)
	 (if (eq (second path) :attribute)
	     (let ((found (loop named outer
			     for i in attr-matches
			     do (loop for attr in i
				   when (eq (first attr) (first path))
				   do (return-from outer t)))))
	       (if (and (not found) any-repeat matches)
		 (match path xmls
			:any-repeat t
			:matches (loop for i in matches
				    with ret = nil
				    do (setq ret (append ret (cddr i)))
				    finally (return ret))
			:attr-matches (loop for i in matches
					 with ret = nil
					 do (setq ret (append ret (second i)))
					 finally (return ret)))
		 t))
	     (multiple-value-bind (attrs matched)
		 (loop for i in matches
		    when (node-equal path i)
		    collect (second i) into attrs and
		    collect (cddr i) into nodes
		    finally (return (values attrs nodes)))
	       (if matched
		   (match (next-node path) xmls :matches matched
			  :attr-matches attrs)
		   (when any-repeat
		     (match (next-node path) xmls :any-repeat t
			    :matches (loop for i in matches
					with ret = nil
					do (setq ret (append ret (cddr i)))
					finally (return ret))
			    :attr-matches (loop for i in matches
					     with ret = nil
					     do (setq ret (append ret
								  (second i)))
					     finally (return ret)))))))))
      t))

(defun insert ())
(defun create ())
