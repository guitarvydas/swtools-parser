Goal: To create a PEG parser which will minimally parse the Software Tools in Pascal code (don't need to parse Pascal in general, just the SWTP code).  The code in this directory uses a hand-edited "peg.lisp" to compile "swtools-parser.peg" into CL code.


Goal: To show that closures can take the place of O/S processes (without the baggage of MMUs, etc.).  It should be possible to build pipelines of Software Tools in CL using lambdas.


sub-goal: Hand-edit "peg.lisp" until it compiles and runs (correctly) under SBCL.  Current problem: "(VALUES)" is "nothing" and SBCL errors out on "not a list".  The point of using (VALUES) is to reduce the amount of noise inside the parser builder.  The esrap rules that return (VALUES) are things like whitespace.  Can I get SBCL to understand (VALUES) as being valid, or do I need to change peg.lisp to return NIL?


sub-goal: To demonstrate the parameter lists and (RETURN ...) were a bad idea and can be subsumed by SEND().


The SWTP book is here: http://seriouscomputerist.atariverse.com/media/pdf/book/Software%20Tools%20in%20Pascal.pdf

See sibling directory ../swt2cl for final crack at this goal.  

The code ../swt2cl/src.p is here: https://www.cs.princeton.edu/~bwk/btl.mirror/pascaltools.txt . N.B. the code contains a copyright notice - Need to check if the code can be distributed and will not be pushed to github until it is known that distribution is OK. 

To use the code in this directory:

(ql:quickload :swtools-parser)
(swtools-parser:@create-swtools-parser 
	  :peg-input-filename "swtools-parser.peg" 
	  :output-lisp-filename "swtools-parser.lisp")

The quickload load everything needed to build a parser.  The second call (@create-swtools-parser) actually creates the parser and pours it into "swtools-parser.lisp".