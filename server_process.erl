-module(server_process).

-behaviour(gen_server).

-export([init/1, start_link/0, stop/0]).
-export([pong/1]).
-export([handle_call/3, handle_cast/2, handle_info/2]).

% start process
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
    gen_server:stop(server_process).

% init
init([]) ->
    {ok, []}.

% APIs

pong(Message) ->
    gen_server:cast(server_process, {pong, Message}).

% callbacks

handle_call(_Message, _From, State) ->
    {reply, [], State}.

handle_cast({pong, {Vowels, Numbers}}, State) ->
    TupleList = lists:zip(Vowels, Numbers),
    Map = maps:from_list(TupleList),
    case process_info(self(), message_queue_len) of
        {message_queue_len, Length} when Length > 2000 ->
            ok;
        {message_queue_len, Length} when Length > 1000 ->
            client_process:ping(Map);
        _ ->
            client_process:ping(Map),
            client_process:ping(Map)
    end,
    {noreply, State};
handle_cast(_Message, State) ->
    {noreply, State}.

handle_info(_Message, State) ->
    {noreply, State}.
