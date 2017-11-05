;;;; CLisp Cheat Sheet, Emilien Fugier, Universite de Technologie de Compiegne, 2017
;;;; Sources:
;;;; https://www.tutorialspoint.com/lisp/index.htm
;;;; https://www.youtube.com/watch?v=ymSq4wHrqyU
;;;; http://www.ai.sri.com/pkarp/loop.html
;;;; http://gigamonkeys.com/book/



;;;; --------COMMENTS--------


;;; Regular comments:

;;;; Program description
;;; Normal comment
;; Indented comment
; Inline comment

#||
Mutiligne comment
||#

#|| About the Atoms :
2 types of atoms:
	- numbers (which value is the number itself)
	- a symbol:
		- 't' (true) 'nil' (void / false)
		- any variable dinamically defined and modified by the user
		- any text precedeed by a quote '
	
	
||#


#||Abouts lists :
(+ (- 1 2) 5)
Evrey list ends with nil and elements are in virtual cells delimited by spaces.
In CLisp, everything is a list !

How a list is evaluated:
1)The first element is considered a function and is not evaluated
2)The subsquent elements are evaluated (UNLESS they have the quote: " ' ", These are treated as symbols)
3)The first element is applied to all the subsequent ones

(+ (- 1 2) 5) -> (+ -1 5) -> 4
||#



;;;; --------BASIC PRIMITIVES--------


(setq *print-case* :capitalize)  ; :upcase :downcase (*print-case* is set to upcase by default)

(format t "Hello, world !~%") ; ~% = \n in C

(format t "Color ~A, number1 ~D, number2 ~5,'0D, hex ~X, float ~5,2F, unsigned value ~D.~%" "red" 123456 89 255 3.14 250)
;;; prints: Color red, number1 123456, number2 00089, hex FF, float  3.14, unsigned value 250.
;;; C equivalent: printf("Color %s, number1 %d, number2 %05d, hex %x, float %5.2f, unsigned value %u.\n", "red", 123456, 89, 255, 3.14, 250);

;;; ~{expr~} applies epxr to each item of a liste
(format t "(~{~a~^, ~})~%" '("Hey" "I" "Just" "Met" "You"))  ; The clean way to format lists for humans
;;; prints: (Hey, I, Just, Met, You)


(format t "What's your name ? ")

(defvar *name* (read)) ; *global_variable* (convention) read input from console
;;; defvar only works the first time, once the varaible is declared, use setq instead
;;; everything can be used in a variable name _ - * except spaces coz they serparate elements in a list


(defun f (param1 param2) "Optionnal commentary"
	(+ param1 param2)
)
;;; (defun function_name "optionnal docstring" (param_list) (function_body1) (f_body2))
(f 1 2)  ; 3 ; (no parenthesis for the arguments)

(defun hello-you (yourname)
	(format t "Hello, ~A !~%" yourname)
)

;;; (setq a 12) <=> (set 'a 12) <=> (set (quote a) 12), the quote means "do not evaluate a")

(hello-you *name*)

(eq 1 2)
(eq *name* 'Grudulain)  ; T
(eq *name* "Grudulain")  ; NIL



;;; eq = equality check for symbols, pointer equality; equal for the rest (strings, numbers, lists...); equalp not to care about case, float/int...
;;; equal is a more polyvalent test, when in doubt use this


(cons 'batman '(superman wonderwoman)) ; (batman superman wonderwoman)
;;; cons, inserts the element in the list (in first position)

(list 'batman 'superman 'wonderwoman)

(car '(batman superman wonderwoman)) ; batman ; gives the head of the list

(cdr '(batman superman wonderwoman)) ; (superman wonderwoman)  ; gives the tail of the list (which a list)

(cadr '(batman superman wonderwoman)) ; superman ; d => tail a => head ==> superman /!\ Evals rihgt to left

(caddr '(batman superman wonderwoman)) ; wonderwoman /!\ c*r : * represents 4 elements MAXIMUM

(append '(a b) '(c d) '(e)) ; (a b c d e)  ; merges lists

(member 'b '(a b c d)) ; (b c d)  ; member checks if an element is part of a list, returns the list from the first occurence (NIL if not found)

(assoc 'b '((a b c) (b c d) (e f g))); (b c d) returns the first list which first item is b

(length '(a b c d)) ; 4

;;; These are all constructive function which makes copies of their parameters to build the results

;;; Destructive functions such as nconc modify the arguments:
(setq *l1* '(a b))
(append *l1* '(c d)) ; (a b c d)
*l1* ; (a b)
(nconc *l1* '(c d)) ; (a b c d)
*l1* ; (a b c d)

(setq a 1)
(setq b 'a)
(setq c 'b)

c ; b
(eval c)  ; a ; eval the parameter and return the result (/!\depth of 1)
(eval b)  ; 1


(if (> a 2)
	1  ; if true
	0)  ; if false
;;; /!\ Only 1 clause for each case
	
(when t 0 1 3)  ; when = if without else, executes 1 then 2 then 3 ... 

(cond  ; multiple cases
	((< 1 2)
		(format t "1 < 2~%"))
	((> 1 2)
		(format "1 > 2~%"))
)


(progn 1 2 3)  ; executes 1 then 2 then 3 ... 
	
(or nil nil nil)  ; nil
(and t t nil)  ; nil
(not nil)  ; t
;;; returns nil if it's false and "something else" if it's true
(and t (setq s 3)) ; 3 
;;; stops the evaluation asap:
(and t nil (setq s 5)) ; nil 
s ; 3

(listp '(a b c)) ; t ; checks if it's a list
(atom 'a)  ; t ; checks if it's an atom


;;; lambda function:
((lambda (a) (list a a a)) 'a)  ; (a a a)


;;; mapcar:
(mapcar (lambda (a) (+ 1 a)) '(1 2 3)) ; (2 3 4)  ; returns a list made of the first parameter (a function) applied to each item of the second


;;; let: local varaibles (cease to exist after the "let" block)
(let ((var1-name 3) (var2-name 2))  ; careful: variable declaration is a list itself, don't forget the brackets ( )
	(+ var1-name var2-name)
	(* var1-name var2-name)
)



;;;; --------LOOPS--------


;;; dolist:
(dolist (i '(1 2 3)) (print i) (print (+ i 1)))  ; i takes the values of each element of the list (<=> for i in L in python)

(loop for i in '(1 2 3) do (print i) (print (+ i 1)))  ; same


;;; from & while
(loop for i from 1  ; start at 1 and is incremented by 1 at each iteration
	while (< i 10)
	do (print i)
)

;;; until & collect:
(loop for i in '(a b c d 0 1 2 3)  ; (a b c d)
	until (numberp i)  ; until provides a stop condition ; while also works
	do (format t "hey i'm running")
	collect (list i "lettre")  ; builds a list with all the values taken by i /!\ not a "do"
)

;;; return
(loop for i in '(a b c d 0 1 2 3)  ; 0
	do
	(when (numberp i) (return i))  ; returns bearks the loop and returns the value
)

;;; several variables can loop through the components of a complex list
(loop for (a b) in '((x 1) (y 2) (z 3))  ; ((1 x) (2 y) (3 z))
      collect (list b a) 
)


;;; parrallel processing: goes through both lists at the same time
(loop for x in '(a b c)  ; ((a 1) (b 2) (c 3))	
      for y in '(1 2 3)
      collect (list x y) 
)

;;; can be use to have a counter while iterating:
(loop for x in '(a b c) ; print a, b, c
      for y from 1
	  
      when (> y 1)
      do (format t ", ")
	  
      do (format t "~A" x)
	  
	  when (= y 3)
	  do (format t "~%")
)

;;; break from a loop
(loop for i in '(1 2 3) do
      (print i)
      (when (eq i 2)
	    (print "The end")
	    (return-from nil "")
)



;;;; --------RECURSION--------


;; "Systematical" recursive function processing lists:

;; (defun function_name (param1 param2)
;;		(if condition_over_the_list(s)  ; typically if it's empty
;;			trivial_case
;;			let_head_tail
;;				process_the_head
;;				recursive_call_over_the_tail
;;		)
;;	)


;;; example:

(defun  print-squares(L)
	(if (not L) 
		nil
		(let ((head (car L)) (tail (cdr L)))  ; it's often both handier and more elegant to split the list in _head (first item) and _tail (list of the following items)
			(format t "~d " (* head head))
			(print-squares tail)
		)
	)
)

(print-squares '(0 1 2 3 4 5 6 7))



;;;; --------DOTTED PAIRS---------


;;; Lists made of only 2 elements
;;; the cdr of a dotted pair is its last element, not the list of the last element

(cdr '(1 2))  ; (2)
(cdr '(1 . 2))  ; 2 => dotted pair specifity

(cons 1 2)  ; => (1 . 2) creates a dotted list


(cons 1 (cons 2 (cons 3 4)))  ; (1 2 3 . 4) only the last pair is dotted

(cdr '(1 2 3 . 4))  ; (2 3 . 4)
(cddr '(1 2 3 . 4))  ; (3 . 4)
(cdddr '(1 2 3 . 4))  ; 4




;;;; --------INPUT/OUTPUT/FILES--------


;;; the interactor=t is always the default input/outpout parameter

;;; format:
;;; (format param "str")  ; _param is the output stream
(format t "hey~%")  ; "t" means the output stream is the interactor window
(setq b (format nil "hey~%"))  ; "nil" means the string is to be returned


;;; read:
;;; (read param)  ; _param is the input stream
(format t "~%Write something: ")
(setq a (read))  ; reads a lisp expression in a stream (interactor=t by default) and returns it
(format t "Write a whole line: ")
(setq b (read-line))  ; reads the whole line

;;; write:
;;; write _param
(write a)
(fresh-line)  ;  outputs a new line only if the stream sin't already at the start of a new line
(write-line b)



;;; opening a file:

;;; open:
;;; use format to write in a file and read / read-line to read it
(defparameter *output-stream* (open "test_file" :direction :output :element-type 'Character))  ; open an output stream towards the "test_file" file (in current directory)
(format *output-stream* "~A~%" '(1 2 3))  ; wirtes (1 2 3) in it
(format t "What do you want to write in your file ? ")
(format *output-stream* "~A~%" (read-line t))
(close *output-stream*)  ; closes the stream

;;; possible parameters: /!\ parameters work pairwise ! The first one is the default value.
;;; :direction + :input / :output / :io / :probe  ; Sets the stream direction
;;; :element-type + 'String-char / 'Character / 'Signed-byte / 'Bit ...  ; Sets the stream's basic transaction unit
;;; :if-exist + :error / :new-version / :rename / :rename-and-delete / :overwrite / :append / nil  ; Specifies the action to be taken if the fil already exists
;;; :if-does-not-exist + :error / :create / nil  ; Specifies the action to be taken if the fil doesn't exists

(defparameter *input-stream* (open "test_file" :direction :input :if-does-not-exist :error))  ; open an input stream towards the "test_file" file if it does not exist, raises an error
(format t "~a~%" (read-line *input-stream*))  ; reads (1 2 3)
(format t "\~a\~%" (read-line *input-stream*))  ; reads whatever you previously wrote in the file
(close *input-stream*)

;;; with-open-file: automaticaly closes the stream, much cleaner, contains a progn equivalent
(with-open-file (stream "test_file" :direction :input :if-does-not-exist :error)
	(format t "Hey, I'm a generic file reader !~%")
	(format t "Here's what you have in \"test_file\":~%")
	(loop for line = (read-line stream nil)  ; line will take the value of each line
		while line  ; stops whenever we reach the end of the file
			do (format t "~a~%" line)
	)
)
