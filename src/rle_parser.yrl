Nonterminals runs run numbered_run single_run headers headerish file file_prime.
Terminals header '=' int value tag eof.
Rootsymbol file.
Right 100 '='.

file -> headers file_prime    : build_state('$2').
headers -> headerish headers  : ['$1' | '$2'].
headers -> headerish : ['$1'].
headerish -> header '=' int   : {get_name('$1'), '$3'}.
headerish -> header '=' value : {get_name('$1'), '$3'}.
file_prime -> runs eof        : '$1'.

runs -> run runs        : ['$1' | '$2'].
runs -> run             : ['$1'].
run -> numbered_run     : '$1'.
run -> single_run       : '$1'.
numbered_run -> int tag : {run, get_length('$1'), get_type('$2')}.
single_run -> tag       : {run, 1, get_type('$1')}.

Erlang code.

get_type({tag, _, b}) ->
  dead;
get_type({tag, _, o}) ->
  alive;
get_type({tag, _, '$'}) ->
  end_of_line.

get_length({int, _, RunLength}) ->
  RunLength.

get_name({header, _, Name}) ->
  Name.

build_state(Runs) ->
  build_state(Runs, 0, 0, []).
build_state([{run, 0, _} | Tail], Column, Row, State) ->
  build_state(Tail, Column, Row, State);
build_state([{run, Count, alive} | Tail], Column, Row, State) ->
  build_state(
    [{run, Count - 1, alive} | Tail],
    Column + 1,
    Row,
    [{Column + 1, Row}| State]
  );
build_state([{run, Count, dead} | Tail], Column, Row, State) ->
  build_state(
    Tail,
    Column + Count,
    Row,
    State
  );
build_state([{run, Count, end_of_line} | Tail], Column, Row, State) ->
  build_state(
    Tail,
    0,
    Row + Count,
    State
  );
build_state([], Column, Row, State) ->
  lists:reverse(State).
