nbAg(500).
nbTokens1(1000).
nbTokens2(50).
turns(500).

!init.

+!init : nbAg(Ags) & nbTokens1(T1) & nbTokens2(T2) & turns(C) &  .my_name(M) & .delete("thread", M, NS) & .term2string(N,NS) &
         Y = N mod 500 + 1 &
	 .concat("thread",Y,X) <- +next(X);
		if (.my_name(thread500)) { 
			 CALC = (T1/Ags)-1;
			for ( .range(I,0,CALC)) {
				for ( .range(J,1,Ags)) {
					.concat("thread",J,Z);
					.send(Z,achieve,token(1,((I*Ags)+J),C));
				}
			}
			for ( .range(I,1,T2)) {
				.concat("thread",math.round(I*(Ags/T2)),Z);
				.send(Z,achieve,token(2,I,C));
			}			
			}.

+!token(2,T,0) <- .send(counter,tell,finished(T)).

+!token(2,T,N) : next(X)  <- .send(X,achieve,token(2,T,N-1)).
+!token(1,T,N) : next(X) <-  !busy(1000); .send(X,achieve,token(1,T,N)).

+!busy(0).
+!busy(N) <- !busy(N-1).
