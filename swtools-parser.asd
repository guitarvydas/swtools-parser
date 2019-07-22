(asdf:defsystem "swtools-parser"
  :serial t
  :depends-on (#:esrap)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) 
                                         (safety 3)
                                         (speed 0)))
                    (funcall next))
  :components ((:file "package")
	       (:file "futil")
               (:file "peg")
	       (:file "write-qualified")
               (:file "create-swtools-parser")))
