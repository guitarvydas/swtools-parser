;; @create-swtools-parser creates the file swtools-parser.lisp (or the given string name) using PEG and ESRAP
;; from the grammar in parser.peg

(cl:in-package :swtools-parser)

(cl:defun @create-swtools-parser (cl:&key (peg-input-filename nil) (output-lisp-filename nil))
  (cl:unless peg-input-filename
    (cl:error "no PEG filename specified"))
  (cl:unless output-lisp-filename
    (cl:error "no output filename specified"))
  (cl:let ((peg-str (swtools-parser:file2string peg-input-filename)))
    (cl:let ((parser-code (esrap:parse 'peg-grammar:peg-grammar peg-str)))
      (cl:with-open-file (outf output-lisp-filename :direction :output :if-exists :supersede)
	(empty:write-qualified parser-code outf)
	'ok))))

