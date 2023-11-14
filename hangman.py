import string
import random
from words import words

def get_valid_word(words):
    word = random.choice(words)
    while '-' in word or ' ' in word:
        word = random.choice(words)
    
    return word.upper()
        
def hangman():
    word = get_valid_word(words)
    word_letter=set(word)
    alphabet=set(string.ascii_uppercase)
    used_letter=set()
    lives=6
    
    while len(word_letter)>0 and lives>0:
        print('Lives left:',lives,',''Used letters:',' '.join(used_letter))
        
        word_list = (letter if letter in used_letter else '-' for letter in word)
        print('Current Word : ',' '.join(word_list))
        
        user_letter=input('Guess a letter: ').upper()
        if user_letter in alphabet - used_letter:
            used_letter.add(user_letter)
            if user_letter in word_letter:
                word_letter.remove(user_letter)
            else:
                lives = lives -1
                print ('Letter not in word')
            
        elif user_letter in used_letter:
            print ('You have guessed this letter')
            
        else:
            print ('Invalid Character')
            
    if lives == 0:
        print ('You Died! The Word was',word)
    else:
        print ('Yay! You got it right!',word)
        
hangman()
