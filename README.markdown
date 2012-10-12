# KVOWithBlocks

A category on NSObject that allows you observe a keypath passing in a block to
execute when the keypath changes instead of using a callback method.

Why? Blocks are funky. They let you define an action at the same time as you are
setting up a observation. In most cases this leads to clearer code than using a
callback.

## Usage

_Add something here_

## Branch structure for submodules

There are two branches to this repository, *master* and *development*, these
make it easier to use the same repository for developing as well as for sharing
the code as a Git submodule.

### The master branch

The master branch just contains the class category and this README file. It is
the one to use if you want to add it as a submodule to your project. This should
be treated as a readonly branch. *do not perform any development on this
branch*.

if you are using this as a submodule, keep up to date with the latest changes by

### The development branch

The development branch contains the category files as well as Xcode projects for
development and demonstration. This is the branch where development should be
performed, the changes push back to the master branch cleanly through the magic
of careful merging.

To add the development branch rather than master, simply use the -b flag when
cloning, as shown below.

    git submodule add -b production << URL for repository >>

### Artefacts

Sometimes, there may be artefacts left over when switching from master to
development. These are files that are ignored by Git and are easily cleaned up
by running

    git clean -dxf

## License (MIT)

Standard MIT licence.

I don't need attribution, it's only a small bit of code. Be inspired to write
your own block based replacements.

## Acknowledgments

Based on:
+ [KVO+Blocks](https://gist.github.com/153676) by Andy Matuschak
+ [DGKVOBlocks](https://github.com/dannygreg/DGKVOBlocks) by Danny Greg

I make no apologies for taking the bits I like from them.
