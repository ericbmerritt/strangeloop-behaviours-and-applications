-module(ex2behaviour).

-export([start/1, send/2]).
-export([init/2, behaviour_info/1]).

start(CallBack) ->
    proc_lib:start_link(?MODULE, init, [self(), CallBack]).

send(Pid, Msg) ->
    Pid ! {'$ex2behaviour', send, Msg}.


%%% Internal functions

init(Parent, CallBack) ->
    try
	{ok, State} = CallBack:init(),
	proc_lib:init_ack(Parent, {ok, self()}),
	loop(CallBack, State)
    catch
	_C:E ->
	    io:format("going down with ~p~n", [E]),
	    exit(E)
    end.

behaviour_info(callbacks) ->
    [{init, 0},
     {handle_msg, 2}];
behaviour_info(_) ->
    undefined.

loop(CallBack, State) ->
    receive
	{'$ex2behaviour', send, Msg} ->
	    case catch CallBack:handle_msg(Msg, State) of
		{ok, NewState} ->
		    loop(CallBack, NewState);
		{stop, NewState} ->
		    io:format("stopping process ~p with state ~p~n", [self(), NewState]),
		    ok;
		Error ->
		    io:format("application error ~p~n", [Error]),
		    exit(Error)
	    end;
	BadMsg ->
	    io:format("bad message ~p~n", [BadMsg]),
	    exit(BadMsg)
    end.




