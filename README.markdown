# KVOWithBlocks

A category on NSObject that allows you observe a keypath passing in a block to
execute when the keypath changes instead of using a callback method.

This works on iOS and OS X.

Why? Blocks are funky. They let you define an action at the same time as you are
setting up a observation. In most cases this leads to clearer code than using a
callback.

## Dependencies

+ ARC. This is written to be dropped into a ARC project, there are no macros to
gracefully handle using it in MRC or GC apps
+ Since it needs ARC, it needs OS X 10.7 and iOS 4.

## Usage

Quite simple, there are only three methods provided by the category

### jcsAddObserverForKeyPath:options:queue:block:

This is the main method for registering for an observer. It takes a keyPath and
options as is usual for registering KVO observations, but additionally it takes
an NSOperationQueue and a block. The block is run on the queue when a change is
obseverved to the key path. If the queue is nil, then the block is run on the
calling thread.

The block has no return value and is passed in the change dictionary for the
observation.  It is typedefed as:

```objc
typedef void (^jcsObservationBlock)(NSDictionary *change);
```

When registering for observation, an opaque object reference is returned, which
is used to unregister for the observation.

**Example**

```objc
// Assume you have an iVar: id _observer to hold the opaque reference
NSOperationQueue *queue = [NSOperationQueue new];
_observer =
[self jcsAddObserverForKeyPath:@"self.stringProperty" options:NSKeyValueObservingOptionNew queue:queue block:^(NSDictionary *change) {
    NSLog(@"New string value %@", [change objectForKey:NSKeyValueChangeNewKey]);
}];
```

### jcsAddObserverForKeyPath:withBlock:

This is a convenience method that runs the provided block on the calling
queue. The options are `NSKeyValueObservingOptionNew` so that the change
dictionary has a key of `NSKeyValueChangeNewKey`.

When registering for this observation, an opaque object reference in returned,
which is used to unregister for the observation.

**Example**

```objc
// Assume you have an iVar: id _observer to hold the opaque reference
_observer =
[self jcsAddObserverForKeyPath:@"self.stringProperty" withBlock:^(NSDictionary *change) {
    NSLog(@"New string value %@", [change objectForKey:NSKeyValueChangeNewKey]);
}];
```
### jcsRemoveObserver:

This is used to remove the observation object using the opaque reference
returned when registering. At the very least this should be done in the
`dealloc` method. It is safe to attempt to unregister an observer that has
already been unregistered.

**Example**

```objc
// Assuming an iVar: id _observer
- (void)dealloc {
    [self jcsRemoveObserver:_observer];
}
```

## Examples

The development branch (the branch structure is described below) contains an
Xcode Workspace with two example projects that show simple observations for
blocking and non-blocking observers.

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

    git submodule add -b development https://github.com/Abizern/KVOWithBlocks.git

There are Unit Tests for the category in each of the OS X and iOS projects, but
these are shared between the two projects.

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
