sed -e 's/^.ESRAP:DEFRULE PG:[[:upper:] ]*//' peg.lisp | sed -e 's/(//g' -e 's/)//g' | sed -e 's/@//g' -e 's/`//g' -e 's/,//g' -e "s/'//g" | tr ' ' '\n' | grep 'PG:' | grep -v CHARACTER | sort | uniq >uses
sed -e 's/^(ESRAP:DEFRULE //' peg.lisp | sed -e 's/ .*$//' | grep 'PG:' | grep -v GRAMMAR | sort >defs
wc uses defs
diff -q uses defs
