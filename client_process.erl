-module(client_process).

-behaviour(gen_server).

-export([init/1, start_link/0, stop/0]).
-export([ping/1]).
-export([handle_call/3, handle_cast/2, handle_info/2]).

% -define(VOWEL, [a, e, i, o, u]).
% -define(NUMBERS, [1, 2, 3, 4, 5]).

% start process
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
    gen_server:stop(client_process).

% init
init([]) ->
    {ok, []}.

% APIs
ping(Message) ->
    gen_server:cast(client_process, {ping, Message}).

% Callbacks
handle_call(_Message, _From, State) ->
    {reply, [], State}.

handle_cast({ping, {Letters, Numbers}}, State) ->
    server_process:pong({Letters, Numbers}),
    server_process:pong({Letters, Numbers}),
    {noreply, State};
handle_cast({ping, Map}, State) ->
    case process_info(self(), message_queue_len) of
        {message_queue_len, Length} when Length > 2000 ->
            ok;
        {message_queue_len, Length} when Length > 1000 ->
            server_process:pong(split_map(Map));
        _ ->
            server_process:pong(split_map(Map)),
            server_process:pong(split_map(Map))
    end,
    {noreply, State};
handle_cast(_Message, State) ->
    {noreply, State}.

handle_info(_Message, State) ->
    {noreply, State}.

% Internal functions

split_map(Map) ->
    Tuple = maps:to_list(Map),
    lists:unzip(Tuple).
