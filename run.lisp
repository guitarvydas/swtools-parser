(defun run ()
  (swtools-parser:@create-swtools-parser 
   :peg-input-filename (asdf:system-relative-pathname :swtools-parser "swtools-parser.peg")
   :output-lisp-filename (asdf:system-relative-pathname :swtools-parser "swtools-parser.lisp")))
