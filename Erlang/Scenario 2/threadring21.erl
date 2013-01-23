-module(threadring21).
-export([main/0, roundtrip/3, counter/1]).

start(Token) ->
	S = spawn(threadring21, counter, [1]),
   {A,H} = lists:mapfoldl(
      fun(Id, Pid) -> Y = spawn(threadring21, roundtrip, [Id, Pid, S]), {Y,Y} end, 
      self(), 
      lists:seq(500, 2, -1)),
   B = lists:append(A,[self()]),
   loop(B,Token),
   roundtrip(1, H, S).

loop(B,Token) -> loop(B,Token,1).
	
loop(B,Token,50) -> J = erlang:round(50*(500/50)),
	  	   lists:nth(J,B) ! Token;
   
loop(B,Token,X) ->
    K = erlang:round(X*(500/50)),
	lists:nth(K,B) ! Token,
	loop(B,Token,X+1).

counter(Sum) ->
    receive
        1 when Sum < 50 -> counter(Sum+1);
		_ -> erlang:halt()
    end.
	
roundtrip(Id, Pid, S) ->
   receive
      1 ->
	  S ! 1,
	  roundtrip(Id, Pid, S);
      Token ->
         Pid ! Token - 1,
         roundtrip(Id, Pid, S)
   end.
   
main() ->
   Token = 500000,
   start(Token).
