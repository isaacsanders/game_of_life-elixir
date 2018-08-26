Definitions.

Eof = ![.\r\n]*
Tag = [\$ob]
Int = [0-9]+
Life = B3/S23
Whitespace = [,\r\s\n\t]
Comment = #[CcNOPRr][^\n\r]*[\n\r]+
UnknownGarbage = CB\s[1,]+

Rules.

{Tag}        : {token, {tag, TokenLine, list_to_atom(TokenChars)}}.
=            : {token, {'=', TokenLine}}.
{Eof}        : {end_token, {eof, TokenLine}}.
{Int}        : {token, {int, TokenLine, list_to_integer(TokenChars)}}.
{Life}       : {token, {value, TokenLine, TokenChars}}.
y|x|rule     : {token, {header, TokenLine, list_to_atom(TokenChars)}}.
{Whitespace}     : skip_token.
{Comment}        : skip_token.
{UnknownGarbage} : skip_token.

Erlang code.
