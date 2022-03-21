function SetWindowDas()
%removed scaling eye signals, 21/03/2022 
%chris van der Togt

    global Par
    NumWins = size(Par.WIN, 2);
    WIN = Par.WIN;
      

    dassetwindow( NumWins, WIN(:), Par.Bsqr)
    %1st: number of control windows
    %2nd: Parameters of position, width and height
    %3rd: bool; square (1) or ellips (0) ; target areas are square or elliptic

