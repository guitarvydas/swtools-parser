(in-package :empty)

(cl:defun write-qualified (val strm)
  (cl:let ((cl:*package* "empty"))
      (cl:write val :stream strm)))
