(in-package :xmls-path-test)

(def-suite :match-test :in :xmls-path)

(in-suite :match-test)

(test match-namespace
  "test namespace matching"
  (is (match '(("a" . "b")) '(("a" . "b") NIL NIL)))
  (is (match '("a") '(("a" . "b") NIL NIL)))
  (is (not (match '(("a" . "c")) '(("a" . "b") NIL NIL))))
  (is (not (match '("a") '(("b" . "b") NIL NIL)))))

(test match-any
  "test :any flag"
  (is (match '(:any) '(("hallo" . "foo") NIL NIL)))
  (is (match '(:any (:any)) '("a" NIL ("b" NIL NIL))))
  (is (not (match '(:any (:any)) '("b" NIL NIL)))))

(test match-any-repeat
  "test :any-repeat flag"
  (is (match '(:any-repeat) '("a" NIL ("b" NIL ("c" NIL NIL) ("d" NIL NIL)))))
  (is (match '(:any-repeat ("c")) '("a" NIL ("b" NIL ("c" NIL NIL)
					     ("d" NIL NIL)))))
  (is (match '("a" (:any-repeat ("b"))) '("a" NIL ("c" NIL NIL) ("d" NIL ("e" NIL ("b" NIL)))))))

(test match-attribute
  "test attribute-matching"
  (is (match '("b" ("a" :attribute)) '("b" (("k" "l") ("a" "c")) NIL)))
  (is (match '(:any ("a" :attribute)) '("b" (("k" "l") ("a" "c")) NIL)))
  (is (match '(:any-repeat ("a" :attribute))
	     '("b" NIL ("a" NIL ("c" (("a" "1")) NIL))))))
