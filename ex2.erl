-module(ex2).

-export([start/0, store/2, stop/0]).

-export([init/0, handle_msg/2]).

%%% API

start() ->
    ex2behaviour:start(?MODULE).

store(Key, Value) ->
    ex2behaviour:send(ex2, {store, {Key, Value}}).

stop() ->
    ex2behaviour:send(ex2, stop).

%%% Internal Functions

init() ->
    register(ex2, self()),
    {ok, []}.

handle_msg({store, {Key, _Value} = Data}, State) ->
    io:format("storing ~p~n", [Key]),
    {ok, [Data|State]};
handle_msg(stop, State) ->
    io:format("stopping process ~p with state ~p~n", [self(), State]),
    {stop, State}.
