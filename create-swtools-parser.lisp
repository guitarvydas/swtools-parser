;; @create-swtools-parser creates the file swtools-parser.lisp (or the given string name) using PEG and ESRAP
;; from the grammar in parser.peg

(defun @create-swtools-parser (&key (peg-input-filename nil) (output-lisp-filename nil))
  (unless peg-input-filename
    (error "no PEG filename specified"))
  (unless output-lisp-filename
    (error "no output filename specified"))
  (let ((peg-str (file-to-string peg-input-filename)))
    (let ((parser-code (esrap:parse 'peg-grammar::grammar peg-str)))
      (with-open-file (outf output-lisp-filename :direction :output :if-exists :supersede)
        (write parser-code :stream outf)
	'ok))))
