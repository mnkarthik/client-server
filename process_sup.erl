-module(process_sup).

-behaviour(supervisor).

-export([init/1, start/0]).

% start
start() ->
    io:format("Node of supervisor : ~p", [node()]),
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

sup_flags() ->
    {one_for_one, 5, 10}.

child_spec() ->
    [client_process(), server_process()].

client_process() ->
    {client_process,
     {client_process, start_link, []},
     permanent,
     5000,
     worker,
     [client_process]}.

server_process() ->
    {server_process,
     {server_process, start_link, []},
     permanent,
     5000,
     worker,
     [server_process]}.

% init
init([]) ->
    {ok, {sup_flags(), child_spec()}}.
