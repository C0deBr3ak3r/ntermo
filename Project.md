# Number Guessing Game

**Using RTL methodology**, the project must implement a game that creates,
pseudorandomly, three 3 bits number and store them internally without
showing on the LEDs (can have repetitions). After that, a process of number
guessing starts, as detailed in this specification.

One of the push buttons, KEY(0), must be used as an asynchronous reset
of **all** sequential elements in the project. The reset can be considered
as the start of the game (it's not necessary to use a switch to start,
therefore the controller FSM doesn't need to be cyclical).

Another push button, KEY(1), must be used as an "ENTER key", to inform to game
that a new guess is on the 9 switches, SW(0) to SW(8), and the game should
evaluate the try.

For each try, right after the "ENTER", the game should show in the first 7
segments displays (HEX0, HEX1, HEX2) the following code, accordingly with
the comparison between each of the three numbers of the try and the 3 drawn
numbers at the beginning, **for each position:**

**0)** if the respective number doesn't exists between the drawn numbers\
**1)** if the respective number does exists between the drawn numbers, but it's
**not** at the right position\
**2)** if the respective number exists and it's at the right position

Even with repetitions, the options are mutually exclusives.

## Controller FSM

### With WAIT SCORE

The "WAIT SCORE" state is probably useless, but a version without it wasn't
tested in a board

Legend:

- Red: logical operations
- Blue: variable outputs
- Bold: datapath inputs
- Italic: board interface inputs

![Controller FSM with WAIT SCORE](./controller-score.svg)

### Without WAIT SCORE

Legend:

- Red: logical operations
- Blue: variable outputs
- Bold: datapath inputs
- Italic: board interface inputs

![Controller FSM without WAIT SCORE](./controller-no-score.svg)

## Datapath

Legend:

- Green: controller FSM signals
- Pink: board interface signals
- Italic: output signals
- Purple: just a way to differentiate between the wires

<img src="./datapath.svg" alt="Datapath" width="auto" height="auto">
