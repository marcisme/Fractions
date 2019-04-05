# Fractions

This program performs basic mathematical operations on fractions.

## Commands

You can build the program with:

``` bash
swift build
```

You can run the tests with:

``` bash
swift test
```

You can run the program with:

``` bash
swift run
```

You can generate an Xcode project with:

``` bash
swift package generate-xcodeproj
```

## Limitations

* Fractions are stored as a numerator/denominator pair, which also includes any
  whole number values. Because if this the total of both the whole number and
  numerator that are entered cannot exceed the max platform integer value. An
  initial effort was made to store the numerator and whole number separately to
  increase this limit, but that significantly increased the complexity of all
  calculations.
* The various `allTests` properties do not include all tests. All tests will
  still run on macOS, but they will not on Linux.
