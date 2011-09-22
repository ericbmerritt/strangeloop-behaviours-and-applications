-module(ex1).

-export([start/0, store/2, stop/0]).

%%% API

start() ->
    spawn(fun() -> init() end).

store(Key, Value) ->
    ex1 ! {store, {Key, Value}}.

stop() ->
    ex1 ! stop.

%%% Internal Functions

init() ->
    register(ex1, self()),
    io:format("process starting~n"),
    loop([]).

loop(State) ->
    receive
	{store, {Key, _Value} = Data} ->
	    io:format("storing ~p~n", [Key]),
	    loop([Data|State]);
	stop ->
	    io:format("stopping process ~p with state ~p~n", [self(), State]),
	    ok;
	BadMsg ->
	    io:format("bad message ~p~n", [BadMsg]),
	    exit(BadMsg)
    end.
	    
