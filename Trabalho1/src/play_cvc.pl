/* PLAY MODE cvc/

/* Play the game in Player vs Player mode */
play_cvc(Player, Board) :-
	write('CPU'), write(Player), nl,
	sleep(1),
	random_position_from(Player, Board, InitialColumn, InitialLine, JumpMoves, AdjoinMoves, CenterMoves),
	random_position_to(Player, Board, FinalColumn, FinalLine, JumpMoves, AdjoinMoves, CenterMoves, Move),
	
	Other is ((Player mod 2) + 1),
	move(Board, NewBoard, InitialColumn, InitialLine, FinalColumn, FinalLine),

	% Adjoining move -> player plays again
	((Move=='adjoin') ->
		(print_board(10, NewBoard), nl,
		(member2d(Other, NewBoard) ->
			(member2d(Player, NewBoard) ->
				play_cvc(Player, NewBoard);
				(write('CPU'), write(Other), write(' won!'), nl));
			(write('CPU'), write(Player), write(' won!'), nl)));
	
	% Centering move -> player passes the turn
	((Move=='center') ->
		(print_board(10, NewBoard), nl,
		(member2d(Other, NewBoard) ->
			(member2d(Player, NewBoard) ->
				play_cvc(Other, NewBoard);
				(write('CPU'), write(Other), write(' won!'), nl));
			(write('CPU'), write(Player), write(' won!'), nl)));
	
	% Jumping move -> player passes the turn if the selected piece can't jump again
	((Move=='jump') ->
		(DeltaLine is FinalLine-InitialLine,
		DeltaColumn is FinalColumn-InitialColumn,
		JumpLine is FinalLine+DeltaLine,
		JumpColumn is FinalColumn+DeltaColumn,
		move(NewBoard, JumpBoard, FinalColumn, FinalLine, JumpColumn, JumpLine),
		print_board(10, JumpBoard), nl,
		(member2d(Other, JumpBoard) ->
			(member2d(Player, JumpBoard) ->			
				(get_jump_positions(Player, JumpBoard, JumpColumn, JumpLine, DoubleJumpMoves),
				((DoubleJumpMoves == []) ->
					play_cvc(Other, JumpBoard);
					play_cvc_jump(Player, JumpBoard, JumpColumn, JumpLine, DoubleJumpMoves)));
				(write('CPU'), write(Other), write(' won!'), nl));
			(write('CPU'), write(Player), write(' won!'), nl)))))).


play_cvc_jump(Player, Board, InitialColumn, InitialLine, JumpMoves) :-
	write('CPU'), write(Player), nl,
	random_position_to(Player, Board, FinalColumn, FinalLine, JumpMoves, [], [], Move),
	Other is ((Player mod 2) + 1),
	move(Board, NewBoard, InitialColumn, InitialLine, FinalColumn, FinalLine),
	DeltaLine is FinalLine-InitialLine,
	DeltaColumn is FinalColumn-InitialColumn,
	JumpLine is FinalLine+DeltaLine,
	JumpColumn is FinalColumn+DeltaColumn,
	move(NewBoard, JumpBoard, FinalColumn, FinalLine, JumpColumn, JumpLine),
	print_board(10, JumpBoard), nl,
	(member2d(Other, JumpBoard) ->
		(member2d(Player, JumpBoard) ->		
				(get_jump_positions(Player, JumpBoard, JumpColumn, JumpLine, DoubleJumpMoves),
				((DoubleJumpMoves == []) ->
					play_cvc(Other, JumpBoard);
					play_cvc_jump(Player, JumpBoard, JumpColumn, JumpLine, DoubleJumpMoves)));
				(write('CPU'), write(Other), write(' won!'), nl));
		(write('CPU'), write(Player), write(' won!'), nl)).
