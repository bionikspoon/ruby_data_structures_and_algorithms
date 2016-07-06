# Projects: Basic Data Structures and Algorithms
<!-- *Estimated Time: 6-10 hours* -->

From [The Odin Project][odin-link]

[![Build Status][travis-badge]][travis-link]
[![Coverage Status][coveralls-badge]][coveralls-link]



## Project 1: Searching Binary Trees

### Your Task

You'll build a simple binary tree data structure from some arbitrary input and also the "crawler" function that will locate data inside of it.

1. Build a class `Node`.  It should have a `value` that it stores and also links to its parent and children (if they exist).  Build getters and setters for it (e.g. parent node, child node(s)). 
2. Write a method `build_tree` which takes an array of data (e.g. [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]) and turns it into a binary tree full of `Node` objects appropriately placed.  Start by assuming the array you get is sorted.
3. Now refactor your `build_tree` to handle data that isn't presorted and cannot be easily sorted prior to building the tree.  You'll need to figure out how to add a node for each of the possible cases (e.g. if it's a leaf versus in the middle somewhere).
3. Write a simple script that runs `build_tree` so you can test it out.
5. Build a method `breadth_first_search` which takes a target value and returns the node at which it is located using the breadth first search technique.  **Tip:** You will want to use an array acting as a queue to keep track of all the child nodes that you have yet to search and to add new ones to the list (as you saw in the [video](http://www.youtube.com/watch?v=zLZhSSXAwxI)).  If the target node value is not located, return `nil`.
4. Build a method `depth_first_search` which returns the node at which the target value is located using the depth first search technique.  Use an array acting as a *stack* to do this.
5. Next, build a new method `dfs_rec` which runs a depth first search as before but this time, instead of using a stack, make this method recursive.
6. Tips:
    
    1. You can think of the `dfs_rec` method as a little robot that crawls down the tree, checking if a node is the correct node and spawning other little robots to keep searching the tree.  No robot is allowed to turn on, though, until all the robots to its left have finished their task.
    2. The method will need to take in both the target value and the current node to compare against.

### Solution

- Code: [lib/binary_tree.rb](lib/binary_tree.rb)
- Tests: [spec/lib/binary_tree_spec.rb](spec/lib/binary_tree_spec.rb)

## Project 2: Knight's Travails

A knight in chess can move to any square on the standard 8x8 chess board from any other square on the board, given enough turns (don't believe it?  See [this animation](http://upload.wikimedia.org/wikipedia/commons/c/ca/Knights-Tour-Animation.gif)).  Its basic move is two steps forward and one step to the side.  It can face any direction.

All the possible places you can end up after one move look like this:

![KnightsMoves](http://0.tqn.com/d/chess/1/0/6/-/-/-/KnightMoves.gif)

### Your Task

Your task is to build a function `knight_moves` that shows the simplest possible way to get from one square to another by outputting all squares the knight will stop on along the way.

You can think of the board as having 2-dimensional coordinates.  Your function would therefore look like:

  * `knight_moves([0,0],[1,2]) == [[0,0],[1,2]]`
  * `knight_moves([0,0],[3,3]) == [[0,0],[1,2],[3,3]]` 
  * `knight_moves([3,3],[0,0]) == [[3,3],[1,2],[0,0]]`

1. Put together a script that creates a game board and a knight.
2. Treat all possible moves the knight could make as children in a tree.  Don't allow any moves to go off the board.
2. Decide which search algorithm is best to use for this case.  Hint: one of them could be a potentially infinite series.
3. Use the chosen search algorithm to find the shortest path between the starting square (or node) and the ending square.  Output what that full path looks like, e.g.:

    ```language-bash
        > knight_moves([3,3],[4,3])
        You made it in 3 moves!  Here's your path:
        [3,3]
        [4,5]
        [2,4]
        [4,3]
    ```
    
### Solution

- Code: [lib/knight_moves.rb](lib/knight_moves.rb)
- Tests: [spec/lib/knight_moves_spec.rb](spec/lib/knight_moves_spec.rb)

## Instructions

### Install

```sh
$ bundle install
```

### Test Once

```sh
$ bundle exec rake spec
```

### Test Watch

```sh
$ bundle exec guard
```

[odin-link]:http://www.theodinproject.com/ruby-programming/data-structures-and-algorithms

[travis-badge]:https://travis-ci.org/bionikspoon/ruby_data_structures_and_algorithms.svg?branch=master
[travis-link]:https://travis-ci.org/bionikspoon/ruby_data_structures_and_algorithms

[coveralls-badge]:https://coveralls.io/repos/github/bionikspoon/ruby_data_structures_and_algorithms/badge.svg?branch=master
[coveralls-link]:https://coveralls.io/github/bionikspoon/ruby_data_structures_and_algorithms?branch=master