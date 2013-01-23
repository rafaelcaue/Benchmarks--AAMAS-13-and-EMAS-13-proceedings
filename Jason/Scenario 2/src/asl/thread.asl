!init.

+!init : .my_name(M) & .delete("thread", M, NS) & .term2string(N,NS) &
         Y = N mod 500 + 1 &
	 .concat("thread",Y,X) <- +next(X);
		if (.my_name(thread500)) { 
			for ( .range(I,1,50)) {
			        .concat("thread",math.round(I*(500/50)),Z);
				.send(Z,achieve,token(I,500000));
			}
		}.

+!token(T,0) <- .send(counter,tell,finished(T)).

+!token(T,N) : next(X) <- .send(X, achieve, token(T,N-1)).
