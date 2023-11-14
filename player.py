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
