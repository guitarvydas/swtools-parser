;; from https://rosettacode.org/wiki/Read_entire_file#Common_Lisp

(defun file-to-string (path)
  (with-open-file (stream path)
    (let ((data (make-string (file-length stream))))
      (read-sequence data stream)
      data)))
