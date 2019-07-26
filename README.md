Goal: To create a PEG parser which will minimally parse the Software Tools in Pascal code (don't need to parse Pascal in general, just the SWTP code).  The code in this directory uses a hand-edited "peg.lisp" to compile "swtools-parser.peg" into CL code.


Goal: To show that closures can take the place of O/S processes (without the baggage of MMUs, etc.).  It should be possible to build pipelines of Software Tools in CL using lambdas.


sub-goal: Hand-edit "peg.lisp" until it compiles and runs (correctly) under SBCL.  DONE.  Now, to see if the generated file swtools-parser.lisp (from swtools-parser.peg) can handle the SWTP code...

sub-goal: To demonstrate the parameter lists and (RETURN ...) were a bad idea and can be subsumed by SEND().


The SWTP book is here: http://seriouscomputerist.atariverse.com/media/pdf/book/Software%20Tools%20in%20Pascal.pdf

See sibling directory ../swt2cl for final crack at this goal.  

The code ../swt2cl/src.p is here: https://www.cs.princeton.edu/~bwk/btl.mirror/pascaltools.txt . N.B. the code contains a copyright notice - Need to check if the code can be distributed and will not be pushed to github until it is known that distribution is OK. Currently, I strip away the first two (non-Pascal) "-h-" files and use the rest of the archive as "src.p" (starting with "-h- UCBPRIMS/close.p 315").  This file is obviously an archive of a bunch of .p files.  I haven't decided whether to split the files out first, or, to treat the whole archive as src.p, which is parsed by the parser.  It is easy enough to write a parsing rule that understands the headers (see the rule FILE_CUT in swtools-parser.peg), or, it is probably just as easy to write a sed script which will split the files and drop them into their corresponding directories.  At the moment, I can't decide which will be more productive (aka easy), so I am trying to parse the complete archive (less the first two files) and hope that the answer "will come to me".  The point of the exercise is to produce a working parser, which, after development, will be used once (for each traget language).  After we can parse the archive (or the separate files), we will augment each parsing rule to produce CL for every Pascal concept.  If we still have some steam left, we will do the same but for JavaScript.  And so on.

To use the code in this directory:

(ql:quickload :swtools-parser)
(swtools-parser:@create-swtools-parser 
	  :peg-input-filename (asdf:system-relative-pathname :swtools-parser "swtools-parser.peg")
	  :output-lisp-filename (asdf:system-relative-pathname :swtools-parser "swtools-parser.lisp"))

The quickload load everything needed to build a parser.  The second call (@create-swtools-parser) actually creates the parser and pours it into "swtools-parser.lisp".