grammar UIL;

unit
    : module  end_module
    | (value|procedure)+
    ;


module
    : MODULE (STRING | IDENTIFIER) (objects|module_opts+|include+)* statements
    ;

module_opts
    : IDENTIFIER '=' (IDENTIFIER|STRING)
    ;

include
    : INCLUDE IDENTIFIER STRING (';')?
    ;


end_module
    : END MODULE ';'
    ;

statements
    : (value|list|identifier|object|procedure)+
    ;

makro_call_va
	: IDENTIFIER '(' makro_argv (',' makro_argv)* ')' 
    | IDENTIFIER '(' IDENTIFIER ',' color_modifier ')'	
	;

makro_argv
	: color_modifier|IDENTIFIER|STRING|INTEGER|FLOAT|expr|makro_argv_prop|string_expr|makro_call_va
	;
	
makro_argv_prop
	: color_modifier? (makro_call_va|IDENTIFIER) '=' (STRING|IDENTIFIER)
	;	

expr: ex_add ex_value
    | ex_value ex_mult expr
    | ex_value ex_add expr
    | ex_value
    ;
ex_value: IDENTIFIER
     | INTEGER
     | FLOAT
     | '(' expr ')'
     ;
ex_add: '+' | '-';
ex_mult: '*' | '/';


string_expr
	: IDENTIFIER|STRING|cstring_call
	| (IDENTIFIER|STRING|cstring_call) ('&' string_expr)+	
	;
	
cstring_call
	: 'compound_string' '(' makro_argv (',' makro_argv)* ')' 
	;

// identifier
identifier
    : UIL_IDENTIFIER (IDENTIFIER ';')+
    ;

// procedure
procedure
    : PROCEDURE  (IDENTIFIER '(' IDENTIFIER?')' ';')+
    ;

// objects
objects
    : OBJECTS '=' '{' decl_object* '}'
    ;

decl_object
    : IDENTIFIER '=' IDENTIFIER ';'
    ;

// value
value
    : VALUE (IDENTIFIER ':' EXPORTED? value_def  ';')+
    ;

value_def
    : (IDENTIFIER|STRING|INTEGER|FLOAT)
    | expr
	| makro_call_va
	| string_expr
    ;


color_modifier
	: BACKGROUND | FOREGROUND
	;


// list
list
    : LIST list_stmt+
    ;

list_stmt
    : IDENTIFIER ':' callbacks
    | IDENTIFIER ':' procedures
    | IDENTIFIER ':' arguments
    ;


// object
object
    : OBJECT object_stmt+
    ;

object_stmt
    : IDENTIFIER ':' IDENTIFIER controls_modifier? '{' (controls|arguments|callbacks)* '}' ';'
    ;

// controls
controls
    : CONTROLS '{' (controls_c|controls_n)+ '}' ';'
    ;

controls_c
    : controls_modifier? IDENTIFIER controls_modifier? IDENTIFIER ';'
    | IDENTIFIER controls_modifier? '{' (controls|arguments|callbacks)* '}' ';'
    ;

controls_modifier
	: (GADGET|UNMANAGED)+
	;


controls_n
    : object_stmt
    ;

// arguments
arguments
    : ARGUMENTS '{' (arguments_k ';')* '}' ';'
    ;

arguments_k
	: IDENTIFIER '=' arguments_c
	| ARGUMENTS IDENTIFIER
	;

arguments_c
	: arguments_a
	| makro_call_va
	| string_expr
	;

arguments_a
    : (STRING|INTEGER|IDENTIFIER)+
    ;


arguments_fa
    : IDENTIFIER '=' (STRING|INTEGER|IDENTIFIER)
    ;

//callbacks
callbacks
    : CALLBACKS ('{' (callbacks_def)* '}' | IDENTIFIER) ';'
    ;

callbacks_def
    : IDENTIFIER ('(' IDENTIFIER ')')? '=' PROCEDURE callbacks_inline_prpc ';'
    | CALLBACKS IDENTIFIER  ';'
    | IDENTIFIER '=' procedures
    ;

callbacks_inline_prpc
	:  IDENTIFIER '(' IDENTIFIER? (STRING|INTEGER|IDENTIFIER)? ')'
	;

//procedures
procedures
	: PROCEDURES (IDENTIFIER | '{' procedures_def+ '}' ) ';'
	;

procedures_def
	: IDENTIFIER '(' IDENTIFIER? ')' ';'
	| PROCEDURES IDENTIFIER ';'
	;

//予約語
//STRING_TABLE: S T R I N G '_' T A B L E;
//TRANSLATION_TABLE: T R A N S L A T I O N '_' T A B L E;
//COMPOUND_STRING: C O M P O U N D '_' S T R I N G;
//COMPOUND_STRING_TABLE: C O M P O U N D '_' S T R I N G '_' T A B L E;
//ASCIZ_STRING_TABLE: A S C I Z '_' S T R I N G '_' T A B L E;

//INTEGER_TABLE: I N T E G E R '_' T A B L E;
//FONT_TABLE: F O N T '_' T A B L E;
//WIDE_CHARACTER: W I D E '_' C H A R A C T E R;
//KEYSYM: K E Y S Y M;

MODULE: M O D U L E;
END: E N D;
VALUE: V A L U E;
INCLUDE: I N C L U D E;
UIL_IDENTIFIER: I D E N T I F I E R;
PROCEDURE: P R O C E D U R E;
PROCEDURES: P R O C E D U R E S;

OBJECTS: O B J E C T S;
LIST: L I S T;
OBJECT: O B J E C T;
CONTROLS: C O N T R O L S;

ARGUMENTS: A R G U M E N T S;
CALLBACKS: C A L L B A C K S;

GADGET: G A D G E T;
UNMANAGED: U N M A N A G E D;

EXPORTED: E X P O R T E D;
BACKGROUND: B A C K G R O U N D;
FOREGROUND: F O R E G R O U N D;


INTEGER
   : ('+'|'-')? DecimalIntegerLiteral
   ;
fragment DecimalIntegerLiteral
   : DecimalNumeral
   ;
fragment DecimalNumeral
   : '0' | NonZeroDigit Digits?
   ;
fragment Digits
   : Digit Digit*
   ;
fragment Digit
   : '0' | NonZeroDigit
   ;
fragment NonZeroDigit
   : [1-9]
   ;


STRING
   : StringPrefix? ('"' DoubleStringCharacters? '"' | '\'' SingleStringCharacters? '\'')
   ;

fragment StringPrefix
	: '#'LetterOrDigit+
	;

fragment DoubleStringCharacters
   : DoubleStringCharacter +
   ;


fragment DoubleStringCharacter
   : ~ ["\\] | '\\' [btnfr"'\\]
   ;

fragment SingleStringCharacters
   : SingleStringCharacter +
   ;

fragment SingleStringCharacter
   : ~ ['\\] | '\\' [btnfr"'\\]
   ;


FLOAT
   : DecimalFloatingPointLiteral
   ;
fragment DecimalFloatingPointLiteral
   : Digits '.' Digits? ExponentPart? FloatTypeSuffix? | '.' Digits ExponentPart? FloatTypeSuffix? | Digits ExponentPart FloatTypeSuffix? | Digits FloatTypeSuffix
   ;
fragment ExponentPart
   : ExponentIndicator SignedInteger
   ;

fragment ExponentIndicator
   : [eE]
   ;
fragment SignedInteger
   : Sign? Digits
   ;
fragment Sign
   : [+-]
   ;
fragment FloatTypeSuffix
   : [fFdD]
   ;


IDENTIFIER
   : LetterOrDigit LetterOrDigit*
   ;
fragment Letter
   : [a-zA-Z$_]
   ;
fragment LetterOrDigit
   : [a-zA-Z0-9$_]
   ;


fragment A:'a';
fragment B:'b';
fragment C:'c';
fragment D:'d';
fragment E:'e';
fragment F:'f';
fragment G:'g';
fragment H:'h';
fragment I:'i';
fragment J:'j';
fragment K:'k';
fragment L:'l';
fragment M:'m';
fragment N:'n';
fragment O:'o';
fragment P:'p';
fragment Q:'q';
fragment R:'r';
fragment S:'s';
fragment T:'t';
fragment U:'u';
fragment V:'v';
fragment W:'w';
fragment X:'x';
fragment Y:'y';
fragment Z:'z';



/*
fragment A:('a'|'A');
fragment B:('b'|'B');
fragment C:('c'|'C');
fragment D:('d'|'D');
fragment E:('e'|'E');
fragment F:('f'|'F');
fragment G:('g'|'G');
fragment H:('h'|'H');
fragment I:('i'|'I');
fragment J:('j'|'J');
fragment K:('k'|'K');
fragment L:('l'|'L');
fragment M:('m'|'M');
fragment N:('n'|'N');
fragment O:('o'|'O');
fragment P:('p'|'P');
fragment Q:('q'|'Q');
fragment R:('r'|'R');
fragment S:('s'|'S');
fragment T:('t'|'T');
fragment U:('u'|'U');
fragment V:('v'|'V');
fragment W:('w'|'W');
fragment X:('x'|'X');
fragment Y:('y'|'Y');
fragment Z:('z'|'Z');
*/


WS
   : [ \t\r\n\u000C] + -> skip
   ;

EOL
   : [\r\n] + -> skip
   ;

COMMENT
   : '/*' .*? '*/' -> skip
   ;
LINE_COMMENT
   : '!' ~ [\r\n]* -> skip
   ;


