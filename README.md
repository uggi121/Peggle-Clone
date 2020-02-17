# CS3217 Problem Set 3

**Name:** Sudharshan Madhavan

**Matric No:** A0191675U

## Tips
1. CS3217's docs is at https://cs3217.netlify.com. Do visit the docs often, as
   it contains all things relevant to CS3217.
2. A Swiftlint configuration file is provided for you. It is recommended for you
   to use Swiftlint and follow this configuration. We opted in all rules and
   then slowly removed some rules we found unwieldy; as such, if you discover
   any rule that you think should be added/removed, do notify the teaching staff
   and we will consider changing it!

   In addition, keep in mind that, ultimately, this tool is only a guideline;
   some exceptions may be made as long as code quality is not compromised.
3. Do not burn out. Have fun!

## Gameplay Notes

### Level Design

When the UI loads, the user can select the peg buttons and tap to place pegs wherever desired. Pegs cannot be placed at the 
top-center of the screen from where the ball will be launched.

### Ball Launch

Once the pegs have been placed, the user should press the **start** button to start the game. After pressing start, the player can tap anywhere on the screen to launch balls. Do note that the current rudimentary design doesn't allow level design - placing of pegs - after the start button has been pressed.

The direction of the ball's initial velocity is from the top-center of the screen to the point on the screen tapped by the user. The maximum launch velocity is capped at a value maintained in `PhysicsConstants.swift`. At a given point in time, only one ball can be active in the game. Subsequent balls can be launched after the previous ball exits the stage. A ball exits the stage by hitting the bottom of the screen.

### Peg Removal

Once the ball exits the stage, the highlighted pegs will fade out. Once a peg starts fading out, it is considered removed. Subsequent balls can thus pass through fading pegs, but will not pass through presently highlighted pegs.

## Dev Guide

The application adheres to the MVC architecture conventionally used in iOS applications. The variant of MVC used is described in the diagram below.

![MVC](https://ahex.co/wp-content/uploads/2018/08/0H9Vj.png)

## Tests
If you decide to write how you are going to do your tests instead of writing
actual tests, please write in this section. If you decide to write all of your
tests in code, please delete this section.

## Written Answers

### Design Tradeoffs
> When you are designing your system, you will inevitably run into several
> possible implementations, in which you need to choose one among all. Please
> write at least 2 such scenarios and explain the trade-offs in the choices you
> are making. Afterwards, explain what choices you choose to implement and why.
>
> For example (might not happen to you -- this is just hypothetical!), when
> implementing a certain touch gesture, you might decide to use the method
> `foo` instead of `bar`. Explain what are the advantages and disadvantages of
> using `foo` and `bar`, and why you decided to go with `foo`.

Your answer here
