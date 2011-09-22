x-module(tr_app).

-behaviour(application).

-export([
     start/2,
     stop/1
     ]).

-define(DEFAULT_PORT, 8080).

start(_Type, _StartArgs) ->
    {ok, LSock} = gen_tcp:listen(?DEFAULT_PORT,
                                 [{reuseaddr, true}, {active, true}]),

    case tr_sup:start_link(LSock) of
	{ok, Pid} ->
	    tr_sup:start_child(),
	    {ok, Pid};
	Error ->
	    Error
    end.

stop(_State) ->
    ok.
