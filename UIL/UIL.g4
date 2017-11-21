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
    : 'include' IDENTIFIER STRING (';')?
    ;
    

end_module
    : 'end' 'module' ';'
    ;

statements
    : (value|list|identifier|object|procedure)+
    ;

// identifier
identifier
    : 'identifier' (IDENTIFIER ';')+
    ;

// procedure
procedure
    : 'procedure'  (IDENTIFIER '(' (IDENTIFIER|value_type)?')' ';')+
    ;

// objects
objects
    : 'objects' '=' '{' decl_object* '}'
    ;

decl_object
    : IDENTIFIER '=' IDENTIFIER ';'
    ;

// value
value
    : 'value' (IDENTIFIER ':' 'exported'? value_def ('&' value_def)* ';')+
    ;

value_def
    : (IDENTIFIER|STRING|INTEGER|FLOAT)
    | value_exp+ 
    | (value_type|IDENTIFIER) '(' value_argv ')' 
    | (value_type|IDENTIFIER) '(' (value_argv ',')+ value_argv ')' 
    | (value_type|IDENTIFIER) '(' STRING ',' (value_modifier|IDENTIFIER) ')' 
    | (value_type|IDENTIFIER) '(' IDENTIFIER ',' (value_type|value_modifier) ')' 
    ;

value_argv
	: IDENTIFIER|STRING|INTEGER|FLOAT|value_exp|value_sign|string_exp|makro_exp
	;

value_exp
	: IDENTIFIER ('+'|'-'|'*'|'/') IDENTIFIER?
	;
	
makro_exp
	: IDENTIFIER '(' (IDENTIFIER|STRING) ')'
	| IDENTIFIER '(' (IDENTIFIER|STRING) ')' '=' value_argv
	;	
	
string_exp
	: (IDENTIFIER|STRING) '&' (IDENTIFIER|STRING)
	;	
	

value_sign
	: value_modifier? IDENTIFIER '=' (STRING|IDENTIFIER)
	;
	
value_modifier
	: 'background' | 'foreground'
	;
	
value_type
	:'string_table'
	|'procedures'
	|'translation_table'
	|'compound_string'
	|'compound_string_table'
	|'integer_table'
	|'asciz_string_table'
	|'font_table'
	|'keysym'
	;

// list
list
    : 'list' list_stmt+
    ;

list_stmt
    : IDENTIFIER ':' callbacks
    | IDENTIFIER ':' procedures
    | IDENTIFIER ':' arguments
    ;


// object
object
    : 'object' object_stmt+
    ;

object_stmt
    : IDENTIFIER ':' IDENTIFIER controls_modifier? '{' (controls|arguments|callbacks)* '}' ';'
    ;

controls
    : 'controls' '{' (controls_c|controls_n)+ '}' ';'
    ;

controls_c
    : 'unmanaged'? IDENTIFIER controls_modifier? IDENTIFIER ';'
    | IDENTIFIER controls_inner_modifier? '{' (controls|arguments|callbacks)* '}' ';'
    ;
    
controls_modifier
	: 'gadget'
	;
	
controls_inner_modifier
	: ('gadget'|'unmanaged')+
	;	
    
controls_n
    : object_stmt
    ;

arguments
    : 'arguments' '{' (arguments_k ';')* '}' ';'
    ;
    
arguments_k
	: IDENTIFIER '=' arguments_c
	| 'arguments' IDENTIFIER
	;
    
arguments_c
	:  (arguments_a|arguments_f)
	|  (arguments_a|arguments_f) '&' (arguments_c)+
	;    

arguments_a
    : (STRING|INTEGER|IDENTIFIER)+ 
    ;

arguments_f
    : IDENTIFIER '('  (',' arguments_gf)* ')'
    | value_type '(' arguments_gf (',' arguments_gf)* ')'
    ;
    
arguments_gf
	: (STRING|INTEGER|IDENTIFIER)
	| arguments_fa
	| (STRING|INTEGER|IDENTIFIER) '&' arguments_gf
	;

arguments_fa
    : IDENTIFIER '=' (STRING|INTEGER|IDENTIFIER)
    ;

callbacks
    : 'callbacks' ('{' callbacks_def* '}' | IDENTIFIER) ';'
    ;
    
callbacks_def
    : IDENTIFIER ('(' IDENTIFIER ')')? '=' 'procedure' IDENTIFIER '(' IDENTIFIER? (STRING|INTEGER|IDENTIFIER)? ')' ';'
    | 'callbacks' IDENTIFIER ';'
    | IDENTIFIER '=' procedures
    | IDENTIFIER '=' 'procedures' IDENTIFIER ';'
    ;

procedures
	: 'procedures' '{' procedures_def+ '}' ';'
	;
	
procedures_def
	: IDENTIFIER '(' ')' ';'
	| IDENTIFIER '(' IDENTIFIER ')' ';'
	| 'procedures' IDENTIFIER ';'
	;	

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