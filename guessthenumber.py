import random

def guess(x) :
    random_number = random.randint(1,x) 
    guess = 0
    while guess != random_number:
        guess = int(input(f'Guess a number between 1 and {x}:'))
        if guess > random_number:
            print ("Better luck next time, too high")
        elif guess < random_number:
            print ("Better luck next time, too low")
    
    print ("Congratulations! you got the right number!")  
    
guess(20)