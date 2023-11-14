import random

def play():
    user = input('Choose your move! Sciccors(s), Paper(p), or Rock(r): ')
    computer = random.choice(['r','p','s'])

    if user == computer:
        print (f"it's a tie, your opponent chose {computer}!")
    
    elif is_win == True:
        print (f"Yay! you win! your opponent chose {computer}!")
        
    elif is_win != True:
        print (f"Oops! you lose! your opponent chose {computer}!")
        
    
def is_win(user,computer):
    if (user=='r' and computer=='s') or (user=='p' and computer=='r') or (user=='s' and computer=='p'):
        return True
    
play()
