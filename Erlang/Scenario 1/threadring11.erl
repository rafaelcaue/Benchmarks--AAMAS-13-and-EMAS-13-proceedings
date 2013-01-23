-module(threadring11).
-export([main/0, roundtrip/2]).

-define(RING, 500).
-define(N, 500000).

start(Token) ->
   H = lists:foldl(
      fun(Id, Pid) -> spawn(threadring11, roundtrip, [Id, Pid]) end, 
      self(), 
      lists:seq(?RING, 2, -1)),
   H ! Token,
   roundtrip(1, H).
   
roundtrip(Id, Pid) ->
   receive
      1 ->
         erlang:halt();
      Token ->
         Pid ! Token - 1,
         roundtrip(Id, Pid)
   end.

main() ->
   Token = ?N,
   start(Token).
