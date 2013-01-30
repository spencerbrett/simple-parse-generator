type ('nonterminal, 'terminal) symbol = 
	| N of 'nonterminal
	| T of 'terminal

let rec construct_rules (sym, rules) = 
	(match rules with
	| h::t -> 
		(match h with
		| (lhs, rhs) -> if lhs = sym 
					then rhs::construct_rules (sym,t)
				else
					 (construct_rules (sym, t)))
	| [] -> [])

let convert_grammar (start, rules) = 
	(start, 
		fun sym -> (construct_rules (sym, rules)));
