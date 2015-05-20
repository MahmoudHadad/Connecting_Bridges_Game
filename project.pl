connecting_bridges(N,Map, Soln):-
Size is N * N,
initializeSolution(Size, Solution ),

from2DTO1D(Map, NewMap),

getNumbers(NewMap, NumbersToColor),

connect_(NewMap, NumbersToColor, N, Solution, NewSolution),

from1DTo2D(NewSolution, Soln, N),
printSolution(Soln, N).


printGetNumbers(Map, []).
printGetNumbers(Map, [H|T]):-
nth1(X,Map,H),
write(X),nl, printGetNumbers(Map, T).
/* ---------------------------------------------------------
_connect(Map, NumbersToColor, Solution, NewSolution). 
To connect numbers to each other
*/

connect_(Map, [], N, Solution, Solution):-
write('reached all colored'),nl, printSolution(Solution,N) ,
allColored(Solution),write('Passed all colored'),nl.

connect_(Map, [Target|T], N, Solution, NewSolution):-
nth1(StartPosition, Map,Target ),!,
color(Target, StartPosition, N, Map, Solution, Solution2),
connect_(Map, T, N, Solution2, NewSolution).


/*Color color(Target, StartPosition, Map, Solution, Solution2),*/
color(Target, StartPosition,N, Map, Solution, FinalSolution):-
moves(Target, StartPosition, StartPosition,N, Map,'_',Solution, FinalSolution,'First').

/*----------------------------------------------------------------------------------------------*/
moves(Target, StartPosition, StartPosition,N, Map,LastMove,Solution, FinalSolution,'NotFirst'):- !,write('fail'),write(Solution),fail.
	
moves(Target, StartPosition, CurPosition, N, Map,LastMove, Solution, FinalSolution,_):- 
	CurPosition > N, 
	LastMove \== 'D',
	write(CurPosition),
	write(' U '),
	moveUp(Target, CurPosition, NewPositition, N, Map, Solution, Solution2, ReachTarget),
	nextMove(Target, StartPosition, NewPositition, N, Map,'U', Solution2, FinalSolution,'NotFirst',ReachTarget ).
	
	
moves(Target, StartPosition, CurPosition,N, Map,LastMove, Solution, FinalSolution,_):- 
	CurPosition + N =< N* N, 
	LastMove \== 'U',
	write(CurPosition),
	write(' D '),
	moveDown(Target, CurPosition, NewPositition, N, Map, Solution, Solution2, ReachTarget),
	nextMove(Target, StartPosition, NewPositition, N, Map,'D', Solution2, FinalSolution,'NotFirst', ReachTarget).
	
moves(Target, StartPosition, CurPosition,N, Map,LastMove, Solution, FinalSolution,_):- 
	CurPosition mod N =\= 0,
	LastMove \== 'L',
	write(CurPosition),
	write(' R '),
	moveRight(Target, CurPosition, NewPositition, N, Map, Solution, Solution2, ReachTarget),
	nextMove(Target, StartPosition, NewPositition, N, Map,'R', Solution2, FinalSolution,'NotFirst', ReachTarget).

moves(Target, StartPosition, CurPosition,N, Map,LastMove,Solution, FinalSolution,_):- 
	CurPosition mod N =\= 1,
	LastMove \== 'R',
	write(CurPosition),
	write(' L '),
	moveLeft(Target, CurPosition, NewPositition,N, Map, Solution, Solution2, ReachTarget),
	nextMove(Target, StartPosition, NewPositition, N, Map,'L', Solution2, FinalSolution,'NotFirst', ReachTarget).



moveUp(Target, CurPosition, NewPositition, N, Map, Solution, Solution2, 'true'):-
	NewPositition is CurPosition - N,
	nth1(NewPositition , Map , target ),
	change(Solution , CurPosition - 1, 'U' , Solution3),
	change(Solution3 , NewPositition - 1, 'X' , Solution2),!.
 
moveUp(Target, CurPosition, NewPositition, N, Map, Solution, Solution2, 'false'):-
	NewPositition is CurPosition - N,
	nth1(NewPositition , Solution , '_'  ),
	nth1(NewPositition , Map , 0  ),
	
	change(Solution , CurPosition - 1 , 'U' , Solution2).


moveDown(Target, CurPosition, NewPositition, N, Map, Solution, Solution2, 'true'):-
	NewPositition is CurPosition + N,
	nth1(NewPositition , Map , Target ),
	change(Solution , CurPosition - 1, 'D' , Solution3),
	change(Solution3 , NewPositition - 1, 'X' , Solution2),!.

moveDown(Target, CurPosition, NewPositition, N, Map, Solution, Solution2,'false'):-
	NewPositition is CurPosition + N, 
	nth1(NewPositition , Solution , '_'  ), 
	nth1(NewPositition , Map , 0  ), 
	change(Solution , CurPosition - 1, 'D' , Solution2).


moveLeft(Target, CurPosition, NewPositition, N, Map, Solution, Solution2, 'true'):-
	NewPositition is CurPosition - 1,
	nth1(NewPositition , Map , Target ), 
	change(Solution , CurPosition - 1, 'L' , Solution3),
	change(Solution3 , NewPositition - 1, 'X' , Solution2),!.

moveLeft(Target, CurPosition, NewPositition, N, Map, Solution, Solution2, 'false'):-
	NewPositition is CurPosition - 1,
	nth1(NewPositition , Solution , '_'  ),
	nth1(NewPositition , Map , 0  ),
	change(Solution , CurPosition - 1, 'L' , Solution2).

 
moveRight(Target, CurPosition, NewPositition, N, Map, Solution, Solution2, 'true'):-
	NewPositition is CurPosition + 1,
	nth1(NewPositition , Map , Target ), 
	change(Solution , CurPosition - 1, 'R' , Solution3),
	change(Solution3 , NewPositition - 1, 'X' , Solution2),!.
 
moveRight(Target, CurPosition, NewPositition, N, Map, Solution, Solution2, 'false'):- 
	NewPositition is CurPosition + 1,
	nth1(NewPositition , Solution , '_' ),
	nth1(NewPositition , Map , 0  ),
	
	change(Solution , CurPosition - 1, 'R' , Solution2).
	
nextMove(_, _, _, N, _,_, FinalSolution, FinalSolution,_,'true' ):-!.
	
nextMove(Target, StartPosition, CurPosition, N, Map,LastMove, Solution2, FinalSolution,Turn,_ ):- 
	moves(Target, StartPosition, CurPosition, N, Map,LastMove, Solution2, FinalSolution,Turn).

change([] , Index , NewValue , []). 

change([H|T] , Index , NewValue , [H|NewArray] ):-
	Index > 0 , 
	change(T , Index-1 , NewValue , NewArray),!.

change([H|T] , Index , NewValue , [NewValue|T] ):-
	Index =:= 0 .	

printSolution(Solution1D , N):-
	convertTo2D(Solution1D , N , [] , Solution2D),
	show(Solution2D).

show([]).
show([H|T] ):-
	nl,write(H),nl,show(T).
	


/*Initialize solution list with _*/
initializeSolution(Size, Solution ):- initialize(Size, [], Solution).

initialize(Size, List, List):- Size<1,!.
initialize(Size, List, ['_'|NewList]):- Size1 is Size-1, initialize(Size1, List, NewList).


/* get numbers we want to connect between them */
getNumbers([],[]).
getNumbers([H|T] , [H|NewList]):-  
	getNumbers(T,NewList),
	\+ member(H,NewList ),
	H =\= 0.
	
getNumbers([H|T] , NewList):-   
	getNumbers(T,NewList).  
/* to check if all the map is connected*/
allColored([]).
allColored([H|T]):-
	check(H),!,fail.
allColored([H|T]):-
	allColored(T).
	
check('_').
/*----------------------------------------*/	
from2DTO1D(Map, NewMap):-convert2D(Map, [], NewMap).

convert2D([], List,List).
convert2D([H|T], List,NewList):-
enqueueElement(H, List, NList), convert2D(T, NList,NewList),!.

enqueueElement(E,[], E).
enqueueElement(E,[H|T], [H|NewList]):-enqueueElement(E, T, NewList).
/* -----------------------------------------------------------*/
enqueueList(E,[], [E]).
enqueueList(E,[H|T], [H|NewList]):-enqueueList(E, T, NewList).

deleteNElements(List, 0, List).
deleteNElements([H|T], N, ModifiedList):-
	N1 is N-1, 
	deleteNElements(T, N1, ModifiedList).

getNElements(List, 0, []).
getNElements([H|T], N, [H|Result]):-
	N1 is N-1,
	getNElements(T, N1, Result).
/* -----------------------------------------------------------*/
from1DTo2D(List1D, Result2D, N):-
convertTo2D(List1D, N, [], Result2D).

convertTo2D([], N, TwoD,TwoD):-!.

convertTo2D(List, N, TwoD, NewTwoD):-
	getNElements(List, N, Result),
	deleteNElements(List, N, ModifiedList),
	enqueueList(Result, TwoD, New2DList), 
convertTo2D(ModifiedList, N, New2DList, NewTwoD),!.	
/* -----------------------------------------------------------*/
