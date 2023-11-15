import math
import random

class player:
    def __init__ (self,letter):
        # letter is 'x' or 'o'
        self.letter = letter
        
    # we want all player to get their next move given a game
    def get_move (self,game):
        pass
    
class RandomComputerPlayer(player):
    def __init__(self,letter):
        super().__init__(letter)
        
    def get_move (self,game):
        # get a random valid spot for the next move
        square = random.choice(game.available_moves())
        return square
    
class HumanPlayer(player):
    def __init__(self,letter):
        super().__init__(letter)
    
    def get_move (self,game):
        valid_square = False
        val = None
        while not valid_square:
            square = input(self.letter + '\'s turn. Input move (0-8):')
            # check if input value is valid by trying to cast it to an integer. if it's not then return invalid
            # if the spot is not available, also return invalid
            try:
                val = int(square)
                if val not in game.available_moves():
                    raise ValueError
                valid_square = True #if these are successful, then yay!
            except ValueError:
                print ('invalid square, Try Again!')
                
        return val

class GeniusComputerPlayer(player):
    def __init__(self,letter):
        super().__init__(letter)
        
    def get_move(self,game):
        if len(game.available_moves()) == 9:
            square = random.choice(game.available_moves()) #randomly choose one
        else:
            #get the square based off minimax algorithm
            square = self.minimax(game,self.letter)['position']
        return square
    
    def minimax(self,state,player):
        max_player = self.letter #yourself!
        other_player = 'O' if player == 'X' else 'X'
        
        #first, check if the previous move is a winner
        #this is the base case
        if state.current_winner == other_player:
            #we should return position AND score, because we need to keep track of the score for minimax to work
            return {'position' : None,
                    'score' : 1 * (state.num_empty_square()+1) if other_player == max_player else -1 * (state.num_empty_square()+1)
                    
        elif not state.num_empty_square() : #no empty square
            return {'position':None, 'score':0}
                    
        if player == max_player:
            best = {'position':None, 'score': -math.inf} #each score should maximize (be larger)
        else:
            best = {'position':None, 'score': math.inf} #each score should minimize
                    
        for possible_move in state.available_moves():
            # step1: make a move, try that spot
            state.make_move(possible_move,player)
                    
            # step2: recurse using minimax to stimulate a game after making that move
            sim_score = self.minimax(state,other_player) #alternate player
                    
            # step3: undo the move
            state.board[possible_move] = ' '
            state.current_winner = None
            sim_score['position'] = possible_move #otherwise this will get messed up from the resursion part
                    
            # step4: update the dictionaries if necessary
            if player == max_player: #maximize the max player
                if sim_score['score'] > best['score']:
                    best = sim_score
                    
            else: #minimize the other player
                if sim_score['score'] < best['score']:
                    best = sim_score
                    
          return best
                    
