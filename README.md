(ql:quickload :swtools-parser)
(swtools-parser:@create-swtools-parser 
	  :peg-input-filename "swtools-parser.peg" 
	  :output-lisp-filename "swtools-parser.lisp")
