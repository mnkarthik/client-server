-module(process_util).

-export([send_message/3]).

send_message(_, _, 0) ->
    ok;
send_message(Node, {M, F, A}, Count) ->
    case Node of
        node1@myhost ->
            case net_adm:ping(node2@myhost) of
                pong ->
                    rpc:call(node2@myhost, M, F, A);
                pang ->
                    apply(M, F, A)
            end;
        node2@myhost ->
            case net_adm:ping(node1@myhost) of
                pong ->
                    rpc:call(node1@myhost, M, F, A);
                pang ->
                    apply(M, F, A)
            end
    end,
    send_message(Node, {M, F, A}, Count - 1).
