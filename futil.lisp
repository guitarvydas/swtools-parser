(in-package :swtools-parser)

;; from https://rosettacode.org/wiki/Read_entire_file#Common_Lisp

(cl:defun file2string (path)
  (cl:with-open-file (stream path)
    (cl:let ((data (cl:make-string (cl:file-length stream))))
      (cl:read-sequence data stream)
      data)))

