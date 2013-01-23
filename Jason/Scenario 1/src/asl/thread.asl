!init.

+!init : .my_name(M) & .delete("thread", M, NS) & .term2string(N,NS) &
         Y = N mod 500 + 1 &
	 .concat("thread",Y,X) <- +next(X); 
		                  if (.my_name(thread500)) { .send(thread1,achieve,token(500000)) }.

+!token(0) <- .stopMAS.

+!token(N) : next(X) <- .send(X, achieve, token(N-1)).
