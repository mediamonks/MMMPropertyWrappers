# MMMPropertyWrappers

[![Build](https://github.com/mediamonks/MMMPropertyWrappers/workflows/Build/badge.svg)](https://github.com/mediamonks/MMMPropertyWrappers/actions?query=workflow%3ABuild)
[![Test](https://github.com/mediamonks/MMMPropertyWrappers/workflows/Test/badge.svg)](https://github.com/mediamonks/MMMPropertyWrappers/actions?query=workflow%3ATest)

Small collection of property wrappers.

(This is a part of `MMMTemple` suite of iOS libraries we use at [MediaMonks](https://www.mediamonks.com/).)

## Installation

Podfile:

```
source 'https://github.com/mediamonks/MMMSpecs.git'
source 'https://github.com/CocoaPods/Specs.git'
...
pod 'MMMPropertyWrappers'
```

SPM:
```swift
.package(url: "https://github.com/mediamonks/MMMPropertyWrappers", .upToNextMajor(from: "0.1"))
```

## Usage

Simple examples for each property wrapper.

<details><summary>@Once</summary>
<p>
A wrapper that allows to set a value only once after setting the initial value. This comes in useful in instances where you want to freeze the value after configuring it.

For instance on configuration object, where you want to assign a default value, but give the user the ability to alter this value in a configuration callback.

```swift
class Config {
    @Once var myValue: Bool = false
    @Once var otherValue: Bool = false

    init(_ config: (Config) -> Void) {
        config(self)
    }
}

// At call site
let config = Config {
    $0.myValue = true
}
```

Now `config.myValue` is 'frozen', if you try setting it afterwards it will throw an `assertionFailure`. However, `config.otherValue` is still open, since the user decided not to alter that value, so it's wise to call `.freeze()` after your configuration block.

```swift
init(_ config: (Config) -> Void) {
    config(self)

    _myValue.freeze()
    _otherValue.freeze()
}
```

</p>
</details>

<details><summary>@EventTrigger</summary>
<p>
A wrapper that will trigger a `SimpleEvent` or `LazySimpleEvent`, e.g. `AnySimpleEvent` when the value changes. The value should conform to 	`Equatable`, and the enclosing class to `EventTriggerable`.

This removes a lot of boilerplate code, going from:

```swift
protocol ViewModel {

	var foo: String { get }
	var bar: String { get }

	var didChange: SimpleEventObservable { get }
}

class DefaultViewModel: ViewModel {

	public private(set) var foo: String {
		didSet {
			_didChange.trigger(if: foo != oldValue)
		}
	}

	public private(set) var bar: String {
		didSet {
			_didChange.trigger(if: bar != oldValue)
		}
	}

	private let _didChange = SimpleEvent()
	public var didChange: SimpleEventObservable { _didChange }
}
```

To:
```
class DefaultViewModel: ViewModel, EventTriggerable {

	@EventTrigger public private(set) var foo: String
	@EventTrigger public private(set) var bar: String

	private let _didChange = SimpleEvent()
	public var didChange: SimpleEventObservable { _didChange }
}
```

Every time `foo` or `bar` is set, and the `value != oldValue`, the `_didChange` event will trigger.

If your property does not conform to `Equatable`, you could use `@LenientEventTrigger`.

</p>
</details>

<details><summary>@LenientEventTrigger</summary>
<p>
Same as `@EventTrigger`, but without requiring to conform to `Equatable`, this will trigger every time the value hits `didSet`.
</p>
</details>
