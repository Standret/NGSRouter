# NGSRouter

## Description
NGSRouter is light-weight transition library, which make transition between pages easy and takes a couple lines of code.

## Installation
### CocoaPods

Add to your podfile:

```ruby
pod "NGSRouter", "~> 1.0.0"
```

## Example

- **Demo project:** [iOS Example](https://github.com/Standret/NGSRouter/tree/master/NGSRouterExample)

## About NGSRouter

NGSRouter can work with `Storyboard`, `.xib`, and code-based view controllers.

For navigation, you can use the basic implementation `NGSRouter` and select the better appropriate function. You can change transition flow, how you want.

## How to use

For example, we will make the transition between two pages:

```swift
import NGSRouter

// MARK: - The first view controller.

final class ViewController: UIViewController {

  // This property contain protocol protected view controller for transition.
  private lazy var router = NGSRouter(transitionHandler: self)

  @IBAction func onOpenPage(_ sender: UIButton) {
    router.navigate(
        to: DestinationViewController.self,
        typeNavigation: .push,
        animated: true
    )
  }
} 

// MARK: - The destination view controller.

final class DestinationViewController: UIViewController, NGSNavigatable { 
  func prepare() { 
    // configure page here. This function call by router before navigation
  }
} 
```
In this case, you make default transition between viewControllers and configure target view controller how you want.
But before navigation will be done, you have to register navigation in the system:

```swift
// 1. Register storyboard id factory
NGSRouterConfig.shared.registerStoryboardIdFactory(factory: NGSViewControllerStoryboardIdFactory())
// 2. Register navigation
NGSRouterAssember.default.register(
  DestinationViewController.self,
  storyboard: Storyboard.main
)
/// and etc..
```

where `Storyboard` is enum in project which implements `NGSStoryboard`.

**Note❗️**
If you use storyboard navigation your `storyboardId` should follow next rule:

ViewController-based: cut `ViewController` from className
className: `DestinationViewController` -> storyboardId `Destination`

Presenter-based: cut `Presenter` from className
className: `DestinationPresenter` -> storyboardId `Destination`

You also can make your own storyboardId factory by implementing protocol `NGSStoryboardIdFactory`.

## Transition case 
For example, we analyze next code with different types of navigation:
- Simple navigation
- Navigation with parameter
- Navigation with close parameter
- Combined usage


**Simple navigation (NGSNavigatable):**

This default case, with default NGSRouter implementation. If you want just present new screen, then use that.

Example:

Implement in target class NGSParamNavigatable:
```swift

final class DestinationViewController: UIViewController, NGSNavigatable { 
  func prepare() { 
    // configure page here. This function call by router before navigation
  }
} 

```

Make navigation:
```swift

router.navigate(
  to: DestinationViewController.self,
  typeNavigation: .modal,
  animated: true
)

```


**Navigation with parameter (NGSParamNavigatable):**

Sometimes in a program, you need to pass some data to the next screen but with default implementation, it is a little bit verbose. NGSRouter provides you with flexible ability to do that in a really short way.

Example:

Implement in target class NGSParamNavigatable:
```swift

final class DestinationViewController: UIViewController, NGSParamNavigatable { 
  func prepare() { 
    // configure page here. This function call by router before navigation
  }

  func prepare(parameter: String) {
    // you receive parameter here. Pay attention that this function is called before navigation.
  }
} 

```

Make navigation:
```swift

_router.navigate(
    to: DestinationViewController.self,
    parameter: "Target text",
    typeNavigation: .modal,
    animated: true
)

```

**Navigation with close parameter (NGSParamNavigatable):**

Sometimes in a program, you need to pass some data to the previus screen, (Return some data from the input view controller for instance). NGSRouter provides you with flexible ability to do that in a really short way.

Example:

Implement in target class NGSCloseNavigatable:
```swift

final class DestinationViewController: UIViewController, NGSParamNavigatable { 
  func prepare() { 
    // configure page here. This function call by router before navigation
  }

  // Special object to return data to the previous screen. Set here appropriate type
  var closableObject = NGSCloseObject<String>()

  // close current
  func closeScreen(parameter: String) {
    _router.close(target: self, parameter: parameter, animated: true)
  }
} 

```

Make navigation:
```swift

_router.navigate(
    to: DestinationViewController.self,
    typeNavigation: .modal,
    animated: true,
    closeCompletion: { parameter in
      // you receive close parameter here
    }
)

```
**Combined usage**

If you need to pass parameter and also receive close parameter you should implement both protocols in target class or use special typealias `NGSParamCloseNavigatable`.

If you do not need to pass a parameter to the target screen, but your target screen implements a special protocol, you can use a function for simple navigation instead of using a function for navigation with parameter.

## Customize transition

For customize your transition you can change transition presentation and set animation.

**Animate transition**

This parameter can animate your current transition.
Set an appropriate value to the `animated` in a navigation function.

**Change presentation**

Parameter `typeNavigation`, have responsobility for change presentation style. He work with UINavigationController, UISplitViewController, ModalPresentation and default presentation.

- ***Default styles*** (`push`, `modal`, `crossDisolve`, `formSheet`)

**📌Supported custom styles:**
- ***Navigation style*** (`push`, `pop`, `present`)
  ```swift
  typeNavigation: .custom(.navigation(style: NavigationStyle))
   ```
 - ***Split style*** (`detail`, `default`)
    ```swift
    typeNavigation: .custom(.split(style: SplitStyle))
   ```
 - ***Modal style*** (`UIModalTransitionStyle`, `UIModalPresentationStyle` - standart UIKit's presentations styles.)
    ```swift
    typeNavigation: .custom(style: .modal(transition: UIModalTransitionStyle, presentation: UIModalPresentationStyle))
   ```

## Configure you destination controller

All navigation has to be register once before usage. You can do it on `AppDelegate` or your `Coordinator` or `Assembler` it does not matter, but you have to register it before you make an navigation otherwise you will get fatal error. 

**Register view controller with view on storyboard**
````swift

NGSRouterAssember.default.register(
    DestinationViewController.self,
    storyboard: Storyboard.main
) { (vc: DestinationViewController) in
    // configure target vc if needed
}
  
````

**Register view controller with .xib or code based**
````swift

 NGSRouterAssember.default.register(
    DestinationViewController.self,
    factory: { DestinationViewController() }
) { (vc: DestinationViewController) in
    // configure target vc if needed
}
  
````
If you do not need configure target view controller you can skip this parameter.

## Note

- License: `MIT`
- Author: Peter Standret / pstandret@gmail.com

Thanks for watching.
