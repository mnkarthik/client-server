-module(process_app).

-behaviour(application).

-export([start/2, stop/1]).

% start
start(_StartType, _StartArgs) ->
    process_sup:start().

% stop
stop(_State) ->
    _State.
