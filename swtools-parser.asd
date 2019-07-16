(asdf:defsystem "swtools-parser"
  :serial t
  :depends-on (#:esrap)
  :components ((:file "package")
	       (:file "futil")
               (:file "peg")
               (:file "create-swtools-parser")))
