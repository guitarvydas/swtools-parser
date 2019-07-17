;; generated by paraphrase, uses esrap

(IN-PACKAGE :peg-grammar)

(ESRAP:DEFRULE PG:GRAMMAR (AND PG:SPACING (esrap:+ PG:DEFINITION) PG:SPACING PG:ENDOFFILE)
  (:DESTRUCTURE
   (SPC DEF SPC2 EOF)
   (DECLARE (IGNORE SPC EOF SPC2))
   `(PROGN ,@DEF)))

(ESRAP:DEFRULE PG:DEFINITION
               (AND PG:IDENTIFIER
                    PG:LEFTARROW
                    PG:EXPRESSION
                    PG:SPACING
                    (ESRAP:? PG:SEMANTICCODE))
  (:DESTRUCTURE
   (ID ARR E SPC CODE)
   (DECLARE (IGNORE ARR SPC))
   (IF (NULL CODE)
       `(ESRAP:DEFRULE ,(INTERN (STRING-UPCASE ID)) ,E)
     `(ESRAP:DEFRULE ,(INTERN (STRING-UPCASE ID)) ,E ,CODE))))

(ESRAP:DEFRULE PG:SEMANTICCODE (AND PG:OPENBRACE (esrap:+ PG:NOTBRACE) PG:CLOSEBRACE)
  (:DESTRUCTURE
   (LB CODE RB)
   (DECLARE (IGNORE LB RB))
   (READ-FROM-STRING (esrap:TEXT CODE))))

(ESRAP:DEFRULE PG:NOTBRACE (OR PG:UQLITERAL (AND (ESRAP:! "}") PG:CHARACTER))
  (:TEXT PG:T))

(ESRAP:DEFRULE PG:EXPRESSION (AND PG:PSEQUENCE (esrap:* PG:SLASHSEQUENCE))
  (:DESTRUCTURE (SEQ SEQS) (IF SEQS `(OR ,SEQ ,@SEQS) SEQ)))

(ESRAP:DEFRULE PG:SLASHSEQUENCE (AND PG:SLASH PG:PSEQUENCE)
  (:DESTRUCTURE (SL SEQ) (DECLARE (IGNORE SL)) SEQ))

(ESRAP:DEFRULE PG:PSEQUENCE (esrap:* PG:PREFIX)
  (:DESTRUCTURE
   (&REST PREF)
   (IF PREF
       (IF (AND (CONSP PREF) (> (LENGTH PREF) 1))
           `(AND ,@PREF)
         (FIRST PREF))
     (VALUES))))

(ESRAP:DEFRULE PG:PREFIX (AND (ESRAP:? (OR PG:PAND PG:PNOT)) PG:SUFFIX)
  (:DESTRUCTURE (PREF SUFF) (IF PREF (LIST PREF SUFF) SUFF)))

(ESRAP:DEFRULE PG:SUFFIX (AND PG:PRIMARY (ESRAP:? (OR PG:QUESTION PG:STAR PG:PLUS)))
  (:DESTRUCTURE (PRIM SUFF) (IF SUFF (LIST SUFF PRIM) PRIM)))

(ESRAP:DEFRULE PG:PRIMARY (OR PG:P1 PG:P2 PG:LITERAL PG:PCLASS PG:DOT) (:LAMBDA (X) X))

(ESRAP:DEFRULE PG:P1 (AND PG:IDENTIFIER (ESRAP:! PG:LEFTARROW))
  (:FUNCTION FIRST))

(ESRAP:DEFRULE PG:P2 (AND PG:OPENPAREN PG:EXPRESSION PG:CLOSEPAREN)
  (:FUNCTION SECOND))

(ESRAP:DEFRULE PG:IDENTIFIER PG:STRINGIDENTIFIER
  (:LAMBDA (X) (INTERN (STRING-UPCASE ))))

(ESRAP:DEFRULE PG:STRINGIDENTIFIER (AND PG:IDENTSTART (esrap:* PG:IDENTCONT) PG:SPACING)
  (:TEXT PG:T))

(ESRAP:DEFRULE PG:IDENTSTART
               (ESRAP:CHARACTER-RANGES (#\a #\z) (#\A #\Z) #\_))

(ESRAP:DEFRULE PG:IDENTCONT
               (OR PG:IDENTSTART "-" (ESRAP:CHARACTER-RANGES (#\0 #\9))))

(ESRAP:DEFRULE PG:LITERAL
               (OR (AND (ESRAP:CHARACTER-RANGES #\')
                        (esrap:* PG:NOTSINGLE)
                        (ESRAP:CHARACTER-RANGES #\')
                        PG:SPACING)
                   (AND (ESRAP:CHARACTER-RANGES #\")
                        (esrap:* NOTDOUBLE)
                        (ESRAP:CHARACTER-RANGES #\")
                        PG:SPACING))
  (:DESTRUCTURE
   (Q1 STRING Q2 SPC)
   (DECLARE (IGNORE Q1 Q2 SPC))
   (TEXT STRING)))

(ESRAP:DEFRULE PG:UQLITERAL
               (AND (ESRAP:CHARACTER-RANGES #\")
                    (esrap:* NOTDOUBLE)
                    (ESRAP:CHARACTER-RANGES #\")
                    PG:SPACING)
  (:DESTRUCTURE
   (Q1 STRING Q2 SPC)
   (DECLARE (IGNORE SPC))
   `(,Q1 ,@STRING ,Q2)))

(ESRAP:DEFRULE PG:NOTSINGLE
               (AND (ESRAP:! (ESRAP:CHARACTER-RANGES #\')) PG:PCHAR)
  (:FUNCTION SECOND))

(ESRAP:DEFRULE PG:NOTDOUBLE
               (AND (ESRAP:! (ESRAP:CHARACTER-RANGES #\")) PG:PCHAR)
  (:FUNCTION SECOND))

(ESRAP:DEFRULE PG:PCLASS (AND "[" (esrap:* NOTRB) "]" PG:SPACING)
  (:DESTRUCTURE
   (LB RANGE RB SPC)
   (DECLARE (IGNORE LB RB SPC))
   (IF (AND (CONSP RANGE)
            (OR (NOT (= 2 (LENGTH RANGE)))
                (OR (CONSP (FIRST RANGE)) (CONSP (SECOND RANGE)))))
       `(CHARACTER-RANGES ,@RANGE)
     `(CHARACTER-RANGES ,RANGE))))

(ESRAP:DEFRULE PG:NOTRB (AND (ESRAP:! "]") PG:RANGE) (:FUNCTION SECOND))

(ESRAP:DEFRULE PG:RANGE (OR PG:CHARRANGE PG:SINGLECHAR))

(ESRAP:DEFRULE PG:CHARRANGE (AND PG:PCHAR "-" PG:PCHAR)
  (:DESTRUCTURE (C1 DASH C2) (DECLARE (IGNORE DASH)) (LIST C1 C2)))

(ESRAP:DEFRULE PG:SINGLECHAR PG:PCHAR (:LAMBDA (C) C))

(ESRAP:DEFRULE PG:PCHAR (OR PG:ESCCHAR PG:NUMCHAR1 PG:NUMCHAR2 PG:ANYCHAR))

(ESRAP:DEFRULE PG:ESCCHAR
               (AND "\\"
                    (OR "n"
                        "r"
                        "t"
                        (ESRAP:CHARACTER-RANGES #\')
                        "\""
                        "["
                        "]"
                        "\\"
                        "{"
                        "}"))
  (:DESTRUCTURE
   (SL CH)
   (DECLARE (IGNORE SL))
   (LET ((C (OR (AND (CHARACTERP CH) CH) (CHAR CH 0))))
     (CASE C
       (#\n #\Newline)
       (#\r #\Return)
       (#\t #\Tab)
       (OTHERWISE C)))))

(ESRAP:DEFRULE PG:NUMCHAR1
               (AND "\\"
                    (ESRAP:CHARACTER-RANGES (#\0 #\2))
                    (ESRAP:CHARACTER-RANGES (#\0 #\7))
                    (ESRAP:CHARACTER-RANGES (#\0 #\7)))
  (:DESTRUCTURE
   (SL N1 N2 N3)
   (DECLARE (IGNORE SL))
   (CODE-CHAR (PARSE-INTEGER (CONCATENATE 'STRING N1 N2 N3) :RADIX 8))))

(ESRAP:DEFRULE PG:NUMCHAR2
               (AND "\\"
                    (ESRAP:CHARACTER-RANGES (#\0 #\7))
                    (ESRAP:? (ESRAP:CHARACTER-RANGES (#\0 #\7))))
  (:DESTRUCTURE
   (SL N1 N2)
   (DECLARE (IGNORE SL))
   (CODE-CHAR (PARSE-INTEGER (CONCATENATE 'STRING N1 N2) :RADIX 8))))

(ESRAP:DEFRULE PG:ANYCHAR (AND (ESRAP:! "\\") PG:CHARACTER)
  (:DESTRUCTURE (SL C) (DECLARE (IGNORE SL)) C))

(ESRAP:DEFRULE PG:LEFTARROW (AND "<-" PG:SPACING)
  (:lambda (list) (DECLARE (ignore list)) (VALUES)))

(ESRAP:DEFRULE PG:SLASH (AND "/" PG:SPACING)
  (:lambda (list) (DECLARE (ignore list)) (VALUES)))

(ESRAP:DEFRULE PG:PAND (AND "&" PG:SPACING)
  (:lambda (list) (DECLARE (ignore list)) 'AND))

(ESRAP:DEFRULE PG:PNOT (AND "!" PG:SPACING)
  (:lambda (list) (DECLARE (ignore list)) 'esrap:!))

(ESRAP:DEFRULE PG:QUESTION (AND "?" PG:SPACING)
  (:lambda (list) (DECLARE (ignore list)) 'esrap:?))

(ESRAP:DEFRULE PG:STAR (AND "*" PG:SPACING)
  (:LAMBDA (LIST) (DECLARE (IGNORE LIST)) 'esrap:*))

(ESRAP:DEFRULE PG:PLUS (AND "+" PG:SPACING)
  (:LAMBDA (LIST) (DECLARE (IGNORE LIST)) 'esrap:+))

(ESRAP:DEFRULE PG:OPENPAREN (AND "(" PG:SPACING)
  (:LAMBDA (LIST) (DECLARE (IGNORE LIST)) (VALUES)))

(ESRAP:DEFRULE PG:CLOSEPAREN (AND ")" PG:SPACING)
  (:LAMBDA (LIST) (DECLARE (IGNORE LIST)) (VALUES)))

(ESRAP:DEFRULE PG:OPENBRACE (AND "{" PG:SPACING)
  (:LAMBDA (LIST) (DECLARE (IGNORE LIST)) (VALUES)))

(ESRAP:DEFRULE PG:CLOSEBRACE (AND "}" PG:SPACING)
  (:LAMBDA (LIST) (DECLARE (IGNORE LIST)) (VALUES)))

(ESRAP:DEFRULE PG:DOT (AND "." PG:SPACING)
  (:LAMBDA (LIST) (DECLARE (IGNORE LIST)) 'PG:CHARACTER))

(ESRAP:DEFRULE PG:PG:SPACING (esrap:* (OR PG:PSPACE PG:COMMENT))
  (:LAMBDA (LIST) (DECLARE (IGNORE LIST)) (VALUES)))

(ESRAP:DEFRULE PG:COMMENT
               (AND "#"
                    (esrap:* (AND (ESRAP:! PG:ENDOFLINE) PG:CHAR1))
                    (OR PG:ENDOFLINE PG:ENDOFFILE))
  (:LAMBDA (LIST) (DECLARE (IGNORE LIST)) (VALUES)))

(ESRAP:DEFRULE PG:CHAR1 PG:CHARACTER (:LAMBDA (C) C))

(ESRAP:DEFRULE PG:PSPACE (OR " " "	" PG:ENDOFLINE)
  (:LAMBDA (LIST) (DECLARE (IGNORE LIST)) (VALUES)))

(ESRAP:DEFRULE PG:ENDOFLINE
               (OR "
"
                   "
"
                   "")
  (:LAMBDA (LIST) (DECLARE (IGNORE LIST)) (VALUES)))

(ESRAP:DEFRULE PG:ENDOFFILE (ESRAP:! PG:CHARACTER)
  (:LAMBDA (LIST) (DECLARE (IGNORE LIST)) (VALUES)))
