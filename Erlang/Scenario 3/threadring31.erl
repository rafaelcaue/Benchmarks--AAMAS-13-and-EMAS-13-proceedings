-module(threadring31).
-export([main/0, busy/2, roundtrip/3, counter/1]).

start(Token) ->
	S = spawn(threadring31, counter, [1]),
   {A,H} = lists:mapfoldl(
      fun(Id, Pid) -> Y = spawn(threadring31, roundtrip, [Id, Pid, S]), {Y,Y} end, 
      self(), 
      lists:seq(500, 2, -1)),
   B = lists:append(A,[self()]),
   loopT1(B,Token),
   loopT1(B,Token),
   loopT2(B,Token),
   roundtrip(1, H, S).

loopT1(B,Token) -> loopT1(B,Token,1).
	
loopT1(B,Token,500) -> lists:nth(500,B) ! {1,Token};
   
loopT1(B,Token,X) ->
	lists:nth(X,B) ! {1,Token},
	loopT1(B,Token,X+1).

loopT2(B,Token) -> loopT2(B,Token,1).
	
loopT2(B,Token,50) -> J = erlang:round(50*(500/50)),
	  	   lists:nth(J,B) ! {2,Token};
   
loopT2(B,Token,X) ->
    K = erlang:round(X*(500/50)),
	lists:nth(K,B) ! {2,Token},
	loopT2(B,Token,X+1).

counter(Sum) ->
    receive
        1 when Sum < 50 -> counter(Sum+1);
		_ -> erlang:halt()
    end.
	
roundtrip(Id, Pid, S) ->
   receive
      {2,1} ->
	  S ! 1,
	  roundtrip(Id, Pid, S);
      {2,Token} ->
         Pid ! {2,Token - 1},
         roundtrip(Id, Pid, S);
      {1,Token} ->
         Sub = spawn(threadring31, busy, [self(),Token]),
         Sub ! 1,
         roundtrip(Id, Pid, S);
      {1,Token,done} ->
         Pid ! {1,Token},
         roundtrip(Id, Pid, S)
   end.
   
busy(Id,Token) ->
   receive
      1 ->  loopB1(Id,Token), exit
   end.

loopB1(Id,Token) -> loopB1(Id,Token,1).
	
loopB1(Id,Token,1000) -> Id ! {1,Token,done};
   
loopB1(Id,Token,X) ->
	loopB1(Id,Token,X+1).

main() ->
   Token = 500,
   start(Token).
