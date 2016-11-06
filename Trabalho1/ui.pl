/*========================================================================================================================================*/

/* PLAY */
cage :-
	load_libraries,
	write('***** WELCOME TO CAGE *****'), nl,
	main_menu.


/* MAIN MENU */
main_menu :- 
	write('1. Play Human Vs. Human'), nl,
	write('2. Play Human Vs. Computer'), nl,
	write('3. Play Computer Vs. Computer'), nl,
	write('4. Exit'), nl, nl,
	write('What do you want to do? '),
	get_code(Option), skip_line,
	O is Option-49,
	play_mode(O).


play_mode(0) :-
	play(1, [[2,1,2,1,2,1,2,1,2,1],
		  	 [1,2,1,2,1,2,1,2,1,2],
		 	 [2,1,2,1,2,1,2,1,2,1],
		 	 [1,2,1,2,1,2,1,2,1,2],
		 	 [2,1,2,1,2,1,2,1,2,1],
		 	 [1,2,1,2,1,2,1,2,1,2],
		 	 [2,1,2,1,2,1,2,1,2,1],
		 	 [1,2,1,2,1,2,1,2,1,2],
		 	 [2,1,2,1,2,1,2,1,2,1],
		 	 [1,2,1,2,1,2,1,2,1,2]]).



/* First argument -> player */
play(1, Board) :-
	print_board(10, Board),
	nl,
	write('Player1'),
	nl,
	write('From '),
	get_code(InitialColumn),
	get_code(InitialLine),
	skip_line,
	write('To   '),
	get_code(FinalColumn),
	get_code(FinalLine),
	skip_line,
	IC is InitialColumn-65,
	FC is FinalColumn-65,
	IL is InitialLine-49,
	FL is FinalLine-49,
	move(Board, NewBoard, IC, IL, FC, FL),
	play(2, NewBoard).

play(2, Board) :-
	print_board(10, Board),
	nl,
	write('Player2'),
	nl,
	write('From '),
	get_code(InitialColumn),
	get_code(InitialLine),
	skip_line,
	write('To   '),
	get_code(FinalColumn),
	get_code(FinalLine),
	skip_line,
	IC is InitialColumn-65,
	FC is FinalColumn-65,
	IL is InitialLine-49,
	FL is FinalLine-49,
	move(Board, NewBoard, IC, IL, FC, FL),
	play(1, NewBoard).

/*========================================================================================================================================*/

/* MOVE PIECE */

/* Move piece */
move(Board, NewBoard, InitialColumn, InitialLine, FinalColumn, FinalLine) :-
	nth0(InitialLine, Board, NewLine1), /* get the line of the piece */
	nth0(InitialColumn, NewLine1, Piece), /* get the piece id to be moved */
	change_board_position(Board, NewBoardTemp, 0, InitialColumn, InitialLine, 0),
	change_board_position(NewBoardTemp, NewBoard, 0, FinalColumn, FinalLine, Piece).


/* Changes the position ColumnNr, LineNr of a 2d list to Piece */
change_board_position([], [], Count, ColumnNr, LineNr, Piece).

change_board_position([Line|Board], [Line|NewBoard], Count, ColumnNr, LineNr, Piece) :-
	Count \= LineNr,
	NextCount is Count+1,
	change_board_position(Board, NewBoard, NextCount, ColumnNr, LineNr, Piece).

change_board_position([Line|Board], NewBoard, Count, ColumnNr, LineNr, Piece) :- 
	change_line_position(Line, NewLine, 0, ColumnNr, Piece),
	NextCount is Count+1,
	change_board_position([NewLine|Board], NewBoard, NextCount, ColumnNr, LineNr, Piece).


/* Changes the position ColumnNr of a list to Piece */
change_line_position([], [], Count, ColumnNr, Piece).

change_line_position([Position|Line], [Position|NewLine], Count, ColumnNr, Piece) :-
	Count \= ColumnNr,
	NextCount is Count+1,
	change_line_position(Line, NewLine, NextCount, ColumnNr, Piece).

change_line_position([Position|Line], [Piece|NewLine], Count, ColumnNr, Piece) :-
	NextCount is Count+1,
	change_line_position(Line, NewLine, NextCount, ColumnNr, Piece).
/*========================================================================================================================================*/

/* PRINT BOARD */
/* Print board */
/* parameters: Size - of list; Board - list that represents the board */
print_board(Size, Board) :-
	nl, 
	print_letters(Size,Size),
	print_top_lines(Size),
	print_squares(1,Size,Board),
	print_bottom_lines(Size).


/* Print letters on top of the board */
print_letters(Size, Size) :- 
	Size > 0,
	write('    '),
	print_letter(Size, Size).

print_letter(1, Size) :-
	write(' '),
	C is 65+Size-1,
	put_code(C),
	write(' '),
	nl.

print_letter(Line, Size) :-
	write(' '),
	C is 65+Size-Line,
	put_code(C),
	write(' '),
	Nextline is Line-1,
	print_letter(Nextline,Size).


/* Print the top line of the board */
print_top_lines(Column) :-
	Column > 0,
	write('    '),
	lt_corner,
	print_top_line(Column).

print_top_line(1) :-
	horiz,
	horiz,
	rt_corner,
	nl.

print_top_line(Column) :-
	horiz,
	horiz,
	top_con,
	Nextcolumn is Column-1,
	print_top_line(Nextcolumn).


/* Print the bottom line line of the board */
print_bottom_lines(Column) :-
	Column > 0,
	write('    '),
	lb_corner,
	print_bottom_line(Column).

print_bottom_line(1) :-
	horiz,
	horiz,
	rb_corner,
	nl.

print_bottom_line(Column) :-
	horiz,
	horiz,
	bottom_con,
	Nextcolumn is Column-1,
	print_bottom_line(Nextcolumn).


/* Print the middle of the board */
print_squares(Currentline, Size, []).

print_squares(1, Size, [Line|Board]) :-
	print_pieces(1, Size, Line),
	print_squares(2, Size, Board).

print_squares(Currentline, Size, [Line|Board]) :-
	print_middle_lines(Size),
	print_pieces(Currentline, Size, Line),
	Nextline is Currentline+1,
	print_squares(Nextline, Size, Board).


/* Print the horizontal lines and connectors of the board */
print_middle_lines(Size) :- 
	Size > 0,
	write('    '),
	left_con,
	print_middle_line(Size).

print_middle_line(1) :- 
	horiz,
	horiz,
	right_con,
	nl.

print_middle_line(Size) :- 
	horiz,
	horiz,
	middle,
	Nextsize is Size-1,
	print_middle_line(Nextsize).


/* Print the pieces and the vertical lines */
print_pieces(Currline, Nrline, Line) :-
	Currline >=10,
	write(' '),
	write(Currline),
	write(' '),
	print_piece(Line),
	vert,
	nl.

print_pieces(Currline, Nrline, Line) :-
	Currline <10,
	write('  '),
	write(Currline),
	write(' '),
	print_piece(Line),
	vert,
	nl.

print_piece([]).

print_piece([0|Line]) :-
	vert,
	write('  '),
	print_piece(Line).

print_piece([1|Line]) :-
	vert,
	black_circle,
	write(' '),
	print_piece(Line).

print_piece([2|Line]) :-
	vert,
	white_circle,
	write(' '),
	print_piece(Line).


/* Characteres */

lt_corner :- put_code(9484).
rt_corner :- put_code(9488).
lb_corner :- put_code(9492).
rb_corner :- put_code(9496).
horiz :- put_code(9472).
vert :- put_code(9474).
top_con :- put_code(9516).
bottom_con :- put_code(9524).
left_con :- put_code(9500).
right_con :- put_code(9508).
middle :- put_code(9532).

black_circle :- put_code(11044).
white_circle :- put_code(11093).%put_code(9711).


/*========================================================================================================================================*/

/* LIBRARIES */

load_libraries :- use_module(library(lists)).












