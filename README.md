Introduction 

	This program is a simple parser generator written in ocaml. Given a grammar in the style of (Nonterminal symbol, List Rules), where Rules are tuples of the form (Nonterminal symbol, List Symbols) my program will generate a function that is a parser. When this parser is given a program to parse, it produces a derivation for that program, or an error indication if the program contains a syntax error and cannot be parsed.


Definitions

alternative list
A list of right hand sides. It corresponds to all of a grammar's rules for a given nonterminal symbol. By convention, an empty alternative list [] is treated as if it were a singleton list [[]] containing the empty symbol string.

production function
A function whose argument is a nonterminal value. It returns a grammar's alternative list for that nonterminal.

grammar
A pair, consisting of a start symbol and a production function. The start symbol is a nonterminal value.

derivation
a list of rules used to derive a phrase from a nonterminal. For example, the OCaml representation of the example derivation shown above is as follows:
 [Expr, [N Term; N Binop; N Expr];
  Term, [N Num];
  Num, [T "3"];
  Binop, [T "+"];
  Expr, [N Term];
  Term, [N Num];
  Num, [T "4"]]

fragment
a list of terminal symbols, e.g., ["3"; "+"; "4"; "xyzzy"].

acceptor
a curried function with two arguments: a derivation d and a fragment frag. If the fragment is not acceptable, it returns None; otherwise it returns Some x for some value x.

matcher
a curried function with two arguments: an acceptor accept and a fragment frag. A matcher matches a prefix p of frag such that accept (when passed a derivation and the corresponding suffix) accepts the corresponding suffix (i.e., the suffix of frag that remains after p is removed). If there is such a match, the matcher returns whatever accept returns; otherwise it returns None.


Theoretical background

A derivation is a rule list that describes how to derive a phrase from a nonterminal symbol. For example, suppose we have the following grammar with start symbol Expr:

Expr → Term Binop Expr
Expr → Term
Term → Num
Term → Lvalue
Term → Incrop Lvalue
Term → Lvalue Incrop
Term → "(" Expr ")"
Lvalue → $ Expr
Incrop → "++"
Incrop → "−−"
Binop → "+"
Binop → "−"
Num → "0"
Num → "1"
Num → "2"
Num → "3"
Num → "4"
Num → "5"
Num → "6"
Num → "7"
Num → "8"
Num → "9"

Then here is a derivation for the phrase "3" "+" "4" from the nonterminal Expr. After each rule is applied, the resulting list of terminals and nonterminals is given.

rule	after rule is applied
(at start)	Expr
Expr → Term Binop Expr	Term Binop Expr
Term → Num	Num Binop Expr
Num → "3"	"3" Binop Expr
Binop → "+"	"3" "+" Expr
Expr → Term	"3" "+" Term
Term → Num	"3" "+" Num
Num → "4"	"3" "+" "4"

In a leftmost derivation, the leftmost nonterminal is always the one that is expanded next. The above example is a leftmost derivation.


simple-parse-generator

A function that generates a parser given a grammar. When this parser is given some string, it returns a derivation of that string using the grammar or an error if the string cannot be parsed.
