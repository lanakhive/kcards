# Klootzakken

A card game made in Lua and LÖVE framework. Requires love2d 0.9.2 to run.

## Gameplay

From the main menu, you can select Start Game, Options, and Quit. In options you can set your player name, and configure resolution and fullscreen. In Start Game, you can set the number of players and select an AI profile for each player before starting a game. Once in game on your turn, click on the cards in your hand to select them for play, then click in the middle of the pile to throw them in. If you want to pass, just click the pile without any cards selected. The player indicator on the left will point at the active player and show how many cards each player has left. When the game is over, the score screen will show the president and klootzak, and you can select if you want to start a new game or return to the main menu.

## How to Play

Klootzakken is an amazing card game that requires skill to win and also not to lose! Try to get rid of all your cards first and go out to become the president by throwing a higher numbered group of cards than the previous player. If you can't, you have to pass. A card group can have 1, 2, 3, or 4 of the same valued cards, and can only be beat by higher valued cards thrown in a group of the same number. Cards go up from Joker all the way to Ace. When nobody can beat your cards, or if the previous player went out, you can throw any group of any value cards you want. If your the last player with cards, you are the Klootzak!

## Custom AI

The game can load custom AIs written in Lua for the computer opponents. See [Custom AIs](customai.md) for more info.

## Command Line Game

The game can also be played in the terminal by running consolegame.lua using a Lua 5.1 interpreter. The LÖVE framework is not required in this case.