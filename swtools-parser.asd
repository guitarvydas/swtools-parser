(asdf:defsystem "swtools-parser"
  :serial t
  :depends-on (#:esrap)
  :components ((:file "package")
	       (:file "futil")
               (:file "peg")
	       (:file "write-qualified")
               (:file "create-swtools-parser")))
