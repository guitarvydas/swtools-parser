(in-package :empty)

(cl:defun write-qualified (val strm)
  (cl:let ((cl:*package* (cl:find-package "EMPTY")))
      (cl:write val :stream strm)))
