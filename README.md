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

As in the case of PS2, this application can be decomposed into model, view and controller components.

The game also adapts the game-loop pattern to update the state of the game continuously. The crux of the game is the physics engine that simulates the motion of objects.

### Model

The model *component* consists of a physics engine and a game engine. The model is responsible for storing the state of the game and provides methods to change the state. This is done by adding pegs, launching balls and so on.

#### Physics Engine

The main class of the physics engine is `PhysicsWorld`. `PhysicsWorld` maintains a collection of objects that conform to the `PhysicsBody` protocol. This class exposes an API that allows users to add and remove physics bodies, apply and remove forces on them, simulate the motion of objects and resolve collisions between objects. `PhysicsWorld` is composed of `PhysicsCollisionSimulator` and `PhysicsKinematicsSimulator`, which expose methods to simulate collisions and kinematics respectively.

`PhysicsKinematicsSimulator` simulates object behaviour following classical mechanics. `PhysicsCollisionSimulator` performs velocity resolution, as well as positional corrections. Broad phase collision detection is done first, followed by narrow phase collision detection.

The struct `Vector` models a 2D vector and supports operations like vector addition, dot product, etc. This is used to represent vector quantities like velocity, position and acceleration.

#### Game Engine

The game engine is largely unchanged from PS2 and consists of a `GameBoard` class managed by the *class* model, which serves as a facade for the model on the whole. The game engine defines what pegs and balls are and facilitates the game simulation by calling methods exposed by the `PhysicsEngine`. The main class, `Model` is composed of a `GameBoard` and a `PhysicsWorld` object. The `GameBoard` stores information about the locations of the pegs, along with their state, i.e. whether they are highlighted are not. The simulations are done by the physics engine.

Pegs are modeled by the class `Peg` and represented in the physics engine as `PegPhysicsBody` objects. Balls are represented by the class `Ball`.

The game engine, through the class `Model`, exposes an API that allows addition and removal of pegs and balls, along with the simulation of the game world.

### View

The view is largely unchanged from PS2 and consists of a `UIGameView` class that presents the game board to the user. Pegs are visually represented by `UIPegImageView`, which subclasses `UIImageView`. `UIGameView` exposes methods to add and remove balls and pegs to the UI, highlight them and make them fade away. It displays the balls and pegs to the users by maintaining them as sub-views in the view hierarchy.

The helper class `UIPegFactory` helps create images of the pegs and balls of the correct size to be added to `UIGameView`.

### Controller 

The controller in this application is the class `ViewController`. Its role is to mediate interaction between the view and the model components. This includes calling appropriate action methods in response to events from the UI, translating information from presentation logic to domain logic and passing it to the model, receiving a response from the model and translating it to presentation logic to update the view. The controller thus ensures that the view and the model are in sync when the application is run.

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
