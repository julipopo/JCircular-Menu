# JCircular Menu

[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://cocoapods.org/pods/LFAlertController)
[![Swift Version][swift-image]][swift-url]

Circular menu interactive, customizable in color, buttons, and actions delegate! <br>
Available from 3 to 8 buttons.


###### ++ Work in progress for more features ++

<img src="/floader.gif" width="300px">

## Installation

add the Pod `JCircularMenu` to your podfile


## Creation

- Step 1 : Initialize the menu in the ViewController class:

``` swift-3
var circularMenu =  JCircularMenu()
```

- Step 2 : In the viewDidLoad, set the menu in its view, its the Color and its delegate :

``` swift-3
circularMenu = JCircularMenu(inView: view, withColor: UIColor.blue)
circularMenu.delegate = self
```

- Step 3 : set the buttons with a title and your local icons (from 3 to 8) :
```  swift-3
menu.addButton(title: "Heel", imageName: "icon_heel")
menu.addButton(title: "Truck", imageName: "icon_truck")
menu.addButton(title: "Spider", imageName: "icon_spider")
menu.addButton(title: "Brique", imageName: "icon_brique")
menu.addButton(title: "Cardio", imageName: "icon_cardio")
menu.addButton(title: "Path", imageName: "icon_path")
menu.addButton(title: "Medecin", imageName: "icon_medecin")
```
- Step 3 : add it to the view :
```  swift-3
view.addSubview(menu)
```

#### Delegate Event :

- Create an extension of your ViewController who conform to CircularMenuDelegate protocol, with circularMenuDidSelect function :

```  swift-3
extension ViewController: JCircularMenuDelegate {
  func jcircularMenuDidSelect(atIndex index: Int) {
      //Do stuff once a button has been tapped
  }
}
```

- Optional : you can listen event from the menu as `jcircularMenuDidOpen()` and `jcircularMenuDidClose()`


[swift-image]:https://img.shields.io/badge/swift-3.0-orange.svg
[swift-url]: https://swift.org/
