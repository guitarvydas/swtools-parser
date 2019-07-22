(ql:quickload :esrap)

(defsystem swtools-parser (:optimize ((speed 0) (space 0) (safety 3) (debug 3)))
  :members (
            "package"
            "futil"
            "peg"
            "write-qualified"
            "create-swtools-parser"
            "run"
            )
  :rules ((:compile :all (:requires (:load :previous)))))
