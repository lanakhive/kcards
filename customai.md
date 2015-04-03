# Creating custom AI for Klootzakken

## Overview

Custom AIs can be created for Klootzakken using the lua language. The AI will be triggered during their turn to decide which of their cards should be played.

## Development

To start, copy the example.lua file to the ai folder in the game settings directory, or create a new lua file in the ai directory. The lua file must define several callback functions as part of a table. These functions will be called during the game execution. At the end of the file, this table should be returned to the game

## Card and Deck Format

Individual cards are stored as a lua table containing a key for num and suit. num is the numerical value of the card, starting at 1 for joker up to 14 for ace. The suit is a one character string of either "H", "D", "J", "S". See the following examples:

    fourOfDiamonds = {num = 4, suit = "D"}
    aceOfSpades = {num = 14, suit = "S"}

The suit is generally irrelevant in the game except for card counting, however it must be kept track of.

Aggregate groups of cards are stored in arrays (integer indexed tables), such as when traversing the hand or when returning a list of cards. These arrays can be modified using the table.insert and table.remove functions, or by addressing directly using an integer index.

## AI Callbacks

#### init() 

This function is used for ai initialization, should return a string containing the name of the AI to be shown in the ai chooser

#### name(index)

* index - index of the player in game

This function is used to select a player name for the ai, should return a string with the name

#### think(player, hand, lastplayer, lasthand, cardcount)

* player - index of the current player (this ai)
* hand - array containing the cards in the players hand
* lastplayer - index of the last player that didn't pass
* lasthand - array containing the cards that were last played together (empty array if player went out)
* cardcount - array containing the number of cards each player has in their hand

This function is used to decide which cards to play during the ai's turn, should return a table containing the cards

## AI Notes

The AI should specify which cards it wants to play in the returned table, or an empty table if the AI wants to pass. If the AI tries to play cards that are not in its hand, it will be interpreted as a pass. If the AI tries to pass when it is not able to (such as when the previous player went out), its lowest card will automatically be played.

