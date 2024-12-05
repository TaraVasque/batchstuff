@echo off
title Expanded Final Fantasy-Like RPG in Batch

:: Initialize Player Stats
setlocal enabledelayedexpansion
set player_hp=50
set player_mp=20
set player_attack=10
set player_defense=5
set player_level=1
set player_experience=0
set player_gold=0
set player_name=Hero
set player_items=3

:: Party Members Initialization
set party_size=2
set party_member_1=Hero
set party_hp_1=50
set party_mp_1=20
set party_attack_1=10
set party_defense_1=5
set party_level_1=1
set party_experience_1=0

set party_member_2=Mage
set party_hp_2=30
set party_mp_2=30
set party_attack_2=5
set party_defense_2=3
set party_level_2=1
set party_experience_2=0

:: Check for saved game
if exist save.txt (
    call :loadGame
)

:: Main Menu
:mainMenu
cls
echo ============================
echo   Welcome to the RPG Game!
echo ============================
echo.
echo  Name:    !player_name!
echo  Level:   !player_level!     HP: !player_hp!   MP: !player_mp!
echo  EXP:     !player_experience!     Gold: !player_gold!
echo  Items:   !player_items!
echo ============================
echo 1. Explore the World
echo 2. View Party Status
echo 3. View Inventory
echo 4. Save Game
echo 5. Exit
echo ============================
set /p choice="Choose an option: "

if "!choice!"=="1" goto explore
if "!choice!"=="2" goto partyStatus
if "!choice!"=="3" goto inventory
if "!choice!"=="4" goto saveGame
if "!choice!"=="5" exit
goto mainMenu

:: Party Status
:partyStatus
cls
echo ============================
echo       Party Status
echo ============================
echo.
echo 1. !party_member_1! - HP: !party_hp_1!   MP: !party_mp_1!   Attack: !party_attack_1!   Defense: !party_defense_1!
echo 2. !party_member_2! - HP: !party_hp_2!   MP: !party_mp_2!   Attack: !party_attack_2!   Defense: !party_defense_2!
echo ============================
pause
goto mainMenu

:: Inventory (Items)
:inventory
cls
echo ============================
echo          Inventory
echo ============================
echo.
echo  Potions: !player_items!
echo ============================
pause
goto mainMenu

:: Explore (Random Battles, Map with Areas)
:explore
cls
echo ============================
echo You are walking through the world...
echo ============================
echo.
echo 1. Explore Forest (Low-Level Enemies)
echo 2. Explore Cave (Medium-Level Enemies)
echo 3. Explore Volcano (High-Level Enemies)
echo 4. Accept a Quest
echo ============================
set /p area_choice="Choose an area to explore or quest to accept: "

if "!area_choice!"=="1" goto forest
if "!area_choice!"=="2" goto cave
if "!area_choice!"=="3" goto volcano
if "!area_choice!"=="4" goto quest
goto mainMenu

:: Forest (Low-Level Enemies)
:forest
cls
echo ============================
echo You are in a peaceful forest.
echo A wild Goblin appears!
echo ============================
call :randomBattle 20 5 1 5 5 10
goto mainMenu

:: Cave (Medium-Level Enemies)
:cave
cls
echo ============================
echo You enter a dark cave. The enemies here are stronger.
echo A wild Troll appears!
echo ============================
call :randomBattle 40 10 2 8 15 20
goto mainMenu

:: Volcano (High-Level Enemies)
:volcano
cls
echo ============================
echo You are in a dangerous volcano.
echo A wild Dragon appears!
echo ============================
call :randomBattle 100 20 5 20 50 100
goto mainMenu

:: Quest
:quest
cls
echo ============================
echo You accepted a quest: "Defeat 3 Goblins in the Forest"
echo Quest accepted! Return to the forest to start fighting Goblins.
echo ============================
pause
goto mainMenu

:: Random Battle (Turn-based)
:randomBattle
set /a enemy_hp=%1
set /a enemy_attack=%2
set /a enemy_defense=%3
set /a enemy_experience=%4
set /a enemy_gold=%5
set /a num_party_members=%6

echo ============================
echo A wild enemy appears!
echo Enemy HP: !enemy_hp!
echo Enemy Attack: !enemy_attack!
echo ============================
pause
:combat
cls
echo ============================
echo Your HP: !player_hp!   Enemy HP: !enemy_hp!
echo ============================
echo 1. Attack with !party_member_1!
echo 2. Attack with !party_member_2!
echo 3. Use Item (Potions)
echo ============================
set /p combat_choice="Choose an action: "

if "!combat_choice!"=="1" goto attack_1
if "!combat_choice!"=="2" goto attack_2
if "!combat_choice!"=="3" goto useItem
goto combat

:: Attack Logic for Party Member 1 (Hero)
:attack_1
cls
echo ============================
echo !party_member_1! attacks the enemy!
set /a damage=!party_attack_1! - !enemy_defense!
if !damage! leq 0 set damage=1
set /a enemy_hp-=damage
echo !party_member_1! dealt !damage! damage to the enemy.
pause
goto enemyTurn

:: Attack Logic for Party Member 2 (Mage)
:attack_2
cls
echo ============================
echo !party_member_2! attacks the enemy!
set /a damage=!party_attack_2! - !enemy_defense!
if !damage! leq 0 set damage=1
set /a enemy_hp-=damage
echo !party_member_2! dealt !damage! damage to the enemy.
pause
goto enemyTurn

:: Use Item
:useItem
cls
if !player_items! leq 0 (
    echo You have no potions to use!
    pause
    goto combat
)
set /a player_hp+=20
set /a player_items-=1
echo You used a potion and restored 20 HP.
pause
goto enemyTurn

:: Enemy Turn to Attack
:enemyTurn
cls
echo ============================
echo The enemy attacks!
set /a enemy_damage=!enemy_attack! - !player_defense!
if !enemy_damage! leq 0 set enemy_damage=1
set /a player_hp-=enemy_damage
echo The enemy dealt !enemy_damage! damage to you.
pause

:: Check if the Enemy is Defeated
if !enemy_hp! leq 0 (
    cls
    echo ============================
    echo You have defeated the enemy!
    set /a player_experience+=!enemy_experience!
    set /a player_gold+=!enemy_gold!
    echo You gained !enemy_experience! experience and !enemy_gold! gold!
    :: Level Up Check
    call :levelUp
    pause
    goto mainMenu
)

:: Check if the Player is Defeated
if !player_hp! leq 0 (
    cls
    echo ============================
    echo You have been defeated!
    echo ============================
    pause
    exit
)

goto combat

:: Level Up Logic
:levelUp
if !player_experience! geq 100 (
    set /a player_level+=1
    set /a player_hp+=10
    set /a player_attack+=2
    set /a player_defense+=1
    set /a player_experience=0
    echo ============================
    echo You leveled up! You are now level !player_level!.
    echo ============================
    pause
)

:: Save Game
:saveGame
cls
echo ============================
echo Saving game...
echo ============================
echo !player_hp! > save.txt
echo !player_mp! >> save.txt
echo !player_attack! >> save.txt
echo !player_defense! >> save.txt
echo !player_level! >> save.txt
echo !player_experience! >> save.txt
echo !player_gold! >> save.txt
echo !player_name! >> save.txt
echo !player_items! >> save.txt
echo !party_hp_1! >> save.txt
echo !party_mp_1! >> save.txt
echo !party_attack_1! >> save.txt
echo !party_defense_1! >> save.txt
echo !party_level_1! >> save.txt
echo !party_experience_1! >> save.txt
echo !party_hp_2! >> save.txt
echo !party_mp_2! >> save.txt
echo !party_attack_2! >> save.txt
echo !party_defense_2! >> save.txt
echo !party_level_2! >> save.txt
echo !party_experience_2! >> save.txt
echo ============================
echo Game saved successfully!
echo ============================
pause
goto mainMenu

:: Load Game
:loadGame
cls
echo ============================
echo Loading saved game...
echo ============================
set /p player_hp=<save.txt
set /p player_mp=<save.txt
set /p player_attack=<save.txt
set /p player_defense=<save.txt
set /p player_level=<save.txt
set /p player_experience=<save.txt
set /p player_gold=<save.txt
set /p player_name=<save.txt
set /p player_items=<save.txt
set /p party_hp_1=<save.txt
set /p party_mp_1=<save.txt
set /p party_attack_1=<save.txt
set /p party_defense_1=<save.txt
set /p party_level_1=<save.txt
set /p party_experience_1=<save.txt
set /p party_hp_2=<save.txt
set /p party_mp_2=<save.txt
set /p party_attack_2=<save.txt
set /p party_defense_2=<save.txt
set /p party_level_2=<save.txt
set /p party_experience_2=<save.txt
echo ============================
echo Game loaded successfully!
echo ============================
pause
goto mainMenu

