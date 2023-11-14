import time
from player import player

class TicTaeToe:
    def __init__(self):
        self.board = [' ' for _ in range(9)] # we will use a single list to rep 3x3 board
        self.current_winner = None #to keep track if there is a current winner
        
    def print_board(self):
        #this is just getting the row
        for row in [self.board[i*3:(i+1)*3] for i in range(3)]:
            print('| ' + ' | '.join(row)+ ' |')
            
    @staticmethod
    def print_board_num():
        # 0 | 1 | 2 etc, tells us num that rep which board
        number_board = [[str(i) for i in range(j*3, (j+1)*3)] for j in range(3)]
        for row in number_board:
            print('| ' + ' | '.join(row)+ ' |')
            
    def available_moves(self):
        return [i for i, spot in enumerate(self.board) if spot == ' ']
        #moves = []
        #for (i,spot) in enumerate(self.board):
            # ['x','x','o'] --> [(0,'x'),(1,'x'),(2,'o')]
        #    if spot == ' ':
        #        moves.append(i)
        #    return moves
    def empty_squares(self):
        return ' ' in self.board
    
    def num_empty_squares(self):
        return len(available_moves())
        # return self.board.count(' ')
        
    def make_move(self, square, letter):
        #if valid move then make the move (assign square to letter)
        #then return true, else false
        if self.board[square] == ' ':
            self.board[square] = letter
            if self.winner(square,letter):
                self.current_winner = letter
            return True
        return False
    
    def winner(self,square,letter):
        #winner if 3 in a row anywhere. we have to check all possibilities
        #first let's check the row
        row_ind = square //3
        row = self.board[row_ind*3 : (row_ind +1) *3]
        if all([spot == letter for spot in row]):
            return True
        
        #check column
        col_ind = square % 3
        col = [self.board[col_ind+i*3] for i in range(3)]
        if all([spot == letter for spot in col]):
            return True
        
        #check diagonal
        # only moves possible to win a diagonal, are even number[0,2,4,6,8]
        if square % 2 == 0:
            diagonal1 = [self.board[i] for i in [0,4,8]]
            if all([spot == letter for spot in diagonal1]):
                return True
            diagonal2 = [self.board[i] for i in [2,4,6]]
            if all([spot == letter for spot in diagonal2]):
                return True
            
        #if all these check fail
        return False
        
    
def play(game, player_x, player_o, print_game=True):
    #return the winner of the game or none for a tie
    if print_game:
        game.print_board_num()
            
    letter = 'X' #starting letter
    #iterate while the game still have empty space
    #(we don't have to worry about the winner because we'll just return that which breaks the loop)
        
    while game.empty_squares():
        #get the move from appropriate player
        if letter == 'O':
            square = player_o.get_move(game)
            
        else:
            square = player_x.get_move(game)
            
        #let's define a function to make a move
        if game.make_move(square,letter):
            if print_game:
                print(letter + f' make a move to square {square}')
                game.print_board()
                print(' ') #just empty line
                
            if game.current_winner:
                if print_game:
                    print (letter + ' Wins!')
                return letter
                
            # after we make our move, we need to alternate letter
            letter = 'O' if letter == 'X' else 'X'
            #if letter == 'X':
            #    letter == 'O'
            #else:
            #    letter == 'X'
        
        #tiny break
        time.sleep(1)
            
    if print_game:
        print('it\'s a tie!')
if __name__ == '__main__':
    player_x = HumanPlayer('X')
    player_o = RandomComputerPlayer('O')
    t = TicTaeToe()
    play(t,player_x,player_o,print_game=True)
            
