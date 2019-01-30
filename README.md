# ILG (InteractiveLineGraph) 🤘📈
> I was tasked with building something akin to Robinhood's graph and while there are several thousand iOS chart frameworks I decided it would be more fun to roll my own and less tedious than modifying someone else's.
> I tried my best to keep it simple, while still allowing for enough customization for it to remain potentially useful for others.


![](example.gif)

## Disclaimer
I built this for work and while it meets my job's requirements, many areas haven't been fleshed out. I like to think that I'll get back to it but I am very good at putting things on my get-back-to-it shelf. 

Things to be aware of (or fix/add if you're feeling communal!):
 - Not sure where the grid is at, probably still works?
 - There was a gradient beneath the line at one point but it broke and I haven't bothered to fix it.
 - Line and dot animations leave something to be desired.

 
Things I do plan on working on:
 - GraphViewInteractionDelegate could be a more helpful.
 - Naming and other general housekeeping.
 - Testing!
 

## Requirements

- Swift 4.2
- iOS 10.0+

## Installation

#### CocoaPods ☕️
You can use [CocoaPods](http://cocoapods.org/) to install `ILG` by adding it to your `Podfile`:

```ruby
pod 'ILG'
```


## Usage

Don't forget to import `ILG`:

``` swift
import ILG
```

Create an instance of `InteractiveLineGraphView` and add it to your view hierarchy however you would like:
```swift
let graphView = InteractiveLineGraphView()
```

Then call `graphView.update(...)` and you're off to the races.


### Properties
There are a number of public properties you'll find in `InteractiveLineGraphView.swift`, most of them are self-explanatory but here are a few that may not be:

`lineMinY` and `lineMaxY` will force set the lower and upper y-axis limits, if nil then the `.min()` or `.max()` of your data will be used.

`interactionDetailCard` is the floating card. It's entirely optional. If you do use it be sure to keep a reference to your card so you can update it via the `GraphViewInteractionDelegate` callback (maybe in the future I'll have fancier protocols).

### Protocols
`GraphViewInteractionDelegate` will relay all interaction information back to you. And when I say "all" I mean it will just tell you when the highlighted index has changed. Spicing it up a little wouldn't be hard, and I would like to in the future but for now it is what it is.

## Meta(l!!! 🎸🎸🎸) 

Joey Nelson – [@jedmondn](https://twitter.com/jedmondn) – joeyedmondnelson@gmail.com

Distributed under the MIT license. See ``LICENSE`` for more information.
