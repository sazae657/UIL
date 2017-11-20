grammar UIL;

unit
    : module  end_module
    | (value|procedure)+
    ;


module
    : 'module' (STRING | IDENTIFIER) (objects|module_opts+|include+)* statements
    ;

module_opts
    : IDENTIFIER '=' (IDENTIFIER|STRING)
    ;

include
    : 'include' IDENTIFIER STRING ';'
    ;

end_module
    : 'end' 'module' ';'
    ;

statements
    : (value|object|procedure)+
    ;

// procedure
procedure
    : 'procedure'  (IDENTIFIER '(' IDENTIFIER? ')' ';')+
    ;

// objects
objects
    : 'objects' '=' '{' decl_object+ '}'
    ;

decl_object
    : IDENTIFIER '=' IDENTIFIER ';'
    ;

// value
value
    : 'value' value_def+
    ;

value_def
    : IDENTIFIER ':' (IDENTIFIER|STRING|INTEGER) ';'
    | IDENTIFIER ':' IDENTIFIER '(' STRING ')' ';'
    | IDENTIFIER ':' IDENTIFIER '(' (STRING ',')* STRING ')' ';'
    | IDENTIFIER ':' IDENTIFIER '(' (value_sign ',')* value_sign ')' ';'
    | IDENTIFIER ':' IDENTIFIER '(' STRING ',' IDENTIFIER ')' ';'
    ;

value_sign
	: IDENTIFIER '=' STRING
	;

// object
object
    : 'object' object_stmt+
    ;

object_stmt
    : IDENTIFIER ':' IDENTIFIER IDENTIFIER? '{' (controls|arguments|callbacks)+ '}' ';'
    ;

controls
    : 'controls' '{' (controls_c|controls_n)+ '}' ';'
    ;

controls_c
    : IDENTIFIER  IDENTIFIER ';'
    ;
controls_n
    : object_stmt
    ;

arguments
    : 'arguments' '{' (arguments_a|arguments_f)+ '}' ';'
    ;

arguments_a
    : IDENTIFIER '=' (STRING|INTEGER|IDENTIFIER) ';'
    ;

arguments_f
    : IDENTIFIER '=' IDENTIFIER '(' (STRING|INTEGER|IDENTIFIER) ')' ';'
    ;

callbacks
    : 'callbacks' '{' callbacks_def+ '}' ';'
    ;

callbacks_def
    : IDENTIFIER '=' 'procedure' IDENTIFIER '(' (STRING|INTEGER|IDENTIFIER)? ')' ';'
    ;

INTEGER
   : DecimalIntegerLiteral
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
   : '"' DoubleStringCharacters? '"' | '\'' SingleStringCharacters? '\''
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

IDENTIFIER
   : LetterOrDigit LetterOrDigit*
   ;
fragment Letter
   : [a-zA-Z$_]
   ;
fragment LetterOrDigit
   : [a-zA-Z0-9$_]
   ;

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