count(1).

+finished(T) : count(50) <- .stopMAS.

@pc[atomic]
+finished(T) : count(X) <- -+count(X+1).
