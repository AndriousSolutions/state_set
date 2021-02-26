### The StateSet Mixin
Find the right State object to call its **setState**().
Collects State Objects by type into a Map object for reliable access across the app.
### Installing
I don't like the version number suggested on the [Installing](https://pub.dev/packages/state_set/install) page.
In most cases, always go up to the '**major**' semantic version number. In your pubspec.yaml file, type in the '**major**' semantic version number followed by two trailing zeros like so: '**.0.0**'
```javascript
dependencies:
 set_state: ^ 2.0.0
```
This package has extensive documentation in the medium article, [A Mixin For State Objects](https://andrious.medium.com/a-stateset-class-part-1-2891f1a0eea1):
[![](https://cdn-images-1.medium.com/max/2000/0*3b5Fx1sGkpz7NUuK.png)](https://andrious.medium.com/a-stateset-class-part-1-2891f1a0eea1)
The screenshot below one of the State classes that make up this example app. It reveals how a State object is incorporated into the StateSet class for ready access. All it takes is to apply the mixin, *StateSet*.
![](https://cdn-images-1.medium.com/max/1000/1*HE9Uaq3aE8c6PqtkQ5-eEA.png)