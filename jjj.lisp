;; experiments with packages vs. WRITE

(ql:quickload :esrap)

(defpackage :empty)

(in-package :empty)

(cl:defun write-qualified (val)
  (cl:write val))

(cl:defun test ()
  (cl:let ((cl:*print-escape* cl:t))
    (write-qualified 'esrap:+)
    (cl:terpri)
    (write-qualified 'cl:+)
    (cl:terpri)
    (write-qualified '(cl:progn cl:nil))
    (cl:values)))

(empty::test)
