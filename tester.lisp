;(cl:in-package :swtools-parser)

(cl:defun tester ()
  (cl:let ((peg-str "swToolsPrograms <- swToolsProgram+ EndOfFile"))
  ;(cl:let ((peg-str "swToolsPrograms <- swToolsProgram+"))
    (cl:let ((parser-code (esrap:parse 'peg-grammar:peg-grammar peg-str)))
      (format *standard-output* "result: ~S~%" parser-code)
      'ok)))

