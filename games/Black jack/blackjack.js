const readline = require('readline');

// Setup command line interface
const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

// Card deck setup
const suits = ['♠', '♥', '♦', '♣'];
const ranks = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'];
const deck = [];

// Function to shuffle the deck
function shuffleDeck() {
    deck.length = 0;
    for (let suit of suits) {
        for (let rank of ranks) {
            deck.push({ rank, suit });
        }
    }

    // Shuffle using Fisher-Yates algorithm
    for (let i = deck.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [deck[i], deck[j]] = [deck[j], deck[i]];
    }
}

// Function to calculate hand total
function getHandTotal(hand) {
    let total = 0;
    let aces = 0;

    hand.forEach(card => {
        if (card.rank === 'J' || card.rank === 'Q' || card.rank === 'K') {
            total += 10;
        } else if (card.rank === 'A') {
            total += 11;
            aces++;
        } else {
            total += parseInt(card.rank);
        }
    });

    // Adjust for aces if total > 21
    while (total > 21 && aces > 0) {
        total -= 10;
        aces--;
    }

    return total;
}

// Function to create ASCII art for the card
function cardToASCII(card) {
    const rank = card.rank;
    const suit = card.suit;

    const topBottom = ' _____ ';
    const middle = `|${rank.padStart(2, ' ')} ${suit}|`;

    return [
        topBottom,
        middle,
        topBottom
    ].join('\n');
}

// Function to display the cards
function displayCards(hand, who) {
    let cardStr = '';
    hand.forEach(card => {
        cardStr += cardToASCII(card) + '\n';
    });

    console.log(`${who} cards:`);
    console.log(cardStr);
}

// Function to prompt for player actions
function promptPlayer(hand, dealerHand) {
    const playerTotal = getHandTotal(hand);
    displayCards(hand, 'Your');
    console.log(`Your total: ${playerTotal}`);

    if (playerTotal > 21) {
        console.log('You busted!');
        return 'bust';
    }

    rl.question('Do you want to (H)it or (S)tand? ', (answer) => {
        if (answer.toLowerCase() === 'h') {
            hand.push(deck.pop());
            promptPlayer(hand, dealerHand);
        } else {
            dealerTurn(hand, dealerHand);
        }
    });
}

// Dealer's turn (dealer draws until reaching 17 or more)
function dealerTurn(playerHand, dealerHand) {
    let dealerTotal = getHandTotal(dealerHand);
    displayCards(dealerHand, 'Dealer');
    console.log(`Dealer's total: ${dealerTotal}`);

    while (dealerTotal < 17) {
        dealerHand.push(deck.pop());
        dealerTotal = getHandTotal(dealerHand);
        displayCards(dealerHand, 'Dealer');
        console.log(`Dealer's total: ${dealerTotal}`);
    }

    determineWinner(playerHand, dealerHand);
}

// Determine winner
function determineWinner(playerHand, dealerHand) {
    const playerTotal = getHandTotal(playerHand);
    const dealerTotal = getHandTotal(dealerHand);

    if (playerTotal > 21) {
        console.log('You busted! Dealer wins.');
    } else if (dealerTotal > 21) {
        console.log('Dealer busted! You win!');
    } else if (playerTotal > dealerTotal) {
        console.log('You win!');
    } else if (playerTotal < dealerTotal) {
        console.log('Dealer wins!');
    } else {
        console.log('It\'s a tie!');
    }

    rl.close();
}

// Function to start the game
function startGame() {
    shuffleDeck();

    const playerHand = [deck.pop(), deck.pop()];
    const dealerHand = [deck.pop(), deck.pop()];

    displayCards(dealerHand, 'Dealer');
    console.log(`Dealer's total: ?`);

    promptPlayer(playerHand, dealerHand);
}

startGame();
