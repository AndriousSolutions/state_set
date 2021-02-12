# state_set

A subclass of the State object placed in a static collection.

**Installing**

I don't always like the version number suggested in the '[Installing](https://pub.dev/packages/mvc_pattern#-installing-tab-)' page.
Instead, always go up to the '**major**' semantic version number when installing my library packages. This means always entering a version number trailing with two zero, '**.0.0**'. This allows you to take in any '**minor**' versions introducing new features as well as any '**patch**' versions that involves bugfixes. Semantic version numbers are always in this format: **major.minor.patch**.

1. **patch** - I've made bugfixes
2. **minor** - I've introduced new features
3. **major** - I've essentially made a new app. It's broken backwards-compatibility and has a completely new user experience. You won't get this version until you increment the **major** number in the pubspec.yaml file.

And so, add this to your pubspec.yaml file instead:
```javascript
dependencies:
  set_state:^1.0.0
```
For more information on this topic, read the article, [The importance of semantic versioning](https://medium.com/@xabaras/the-importance-of-semantic-versioning-9b78e8e59bba).

### The StateSet Class

*Find the right State object to call its* ***setState****()*

In time, you'll get to know one important circumstance when working with Flutter --- you will regularly need to call a State object's **setState**() function. In other words, you'll need to repeatedly 'refresh' or 'rebuild' the app's interface and reflect any on-going changes, and that's done by calling a State object's **setState**() function. Doing so will have the Flutter framework call that State object's **build**() function. You're not to directly call the **build**() in the declarative programming framework that is Flutter. You're to call **setState**().

In time, however, while working with Flutter, you'll also discover accessing a State object is easier said than done frankly. As it stands now with Flutter, State objects aren't so readily accessible. Frankly, whole frameworks like Provider and alike were created to make them readily accessible by some degree or another --- all just so to call their **setState**() function.

In my case, I've been using a Dart package that collects all the State objects of an app into a Map object all for ready access. Of course, I love it and use it all the time --- the fact I wrote the Dart package is beside the point. 

Again, a State object's **setState**() function will become all-important to you when developing in Flutter, and I wrote a mixin you can attach to any State class giving you easier yet safe access to that function. It allows you access to a State object anywhere in your app, and if you can't access it it's only because it's not there yet (not instantiated yet) and your attempt will return null. You should know your own app --- that's on you. Again, it compensates for such instances by 'failing gracefully' with null. I'd suggest testing for null when appropriate. In fact, I'll show you in this article circumstances where you should do that. The package is called, *state_set*, and has an extensive example app demonstrating its use. We're going to review that example app here in this article.


[![](https://cdn-images-1.medium.com/max/2000/1*IFmrme1ikM_oyj7r4YrVIA.png)](https://andrious.medium.com/my-medium-9de112c2d85c)

[Other Stores by Greg Perry](https://andrious.medium.com/my-medium-9de112c2d85c)

### Going Home

The example app is demonstrated below. It's a very very simple example app. It's the ol' standby --- the startup counter app. The app you see when you create a new Flutter project. Well, this one is a little different. It's got three counters. In fact, there are three example apps in this Dart package for you to look through --- all with three counters. Today, we'll just look at one of them.

Note, how a counter on the previous home screen is incremented even when we're currently on the second screen. In Flutter, that means a **setState**() function is being called somewhere. The Dart package and its class, *StateSet*, will allow access to the State object previously instantiated back on the home screen --- the very State object that built the home screen. That's huge! Shortly, you'll realize why.

A screenshot of the second screen is also displayed below. The first arrow below points to the FloatingActionButton's **onPressed**() function calling that State object's own **onPressed**() function. Note, it's further wrapped in its own **setState**() function. Thus the **onPressed**() function increments the counter while the **setState**() then displays the incremented value. Again, as you may already know, it's the **setState**() that tells the Flutter framework to call the State object's **build**() function again and consequently rebuild the second screen again. You've seen this time and time again. Perfectly normal.

However, it's the RaisedButton widget also there on the second screen that's the real interesting part. It too has a **onPressed**() function, and notice what's going on in that function. What you're seeing is the code that allows you to also increment the counter back on the home screen. Huge. The second arrow below points to the static function, **of**, from the StateSet class retrieving the State object for the StatefulWidget, *HomeScreen*, so to update the incrementation back on the home screen. See how that works? You're probably thinking, 'What's the big deal?' 

[![](https://cdn-images-1.medium.com/max/2500/1*qUUv220agHa6dMHsXwKeUA.png)](https://github.com/AndriousSolutions/state_set/blob/208af24915e4f27516be73679bdb6fa417d8c994/example/lib/src/home/2/second_screen.dart#L62)

![](https://cdn-images-1.medium.com/max/1000/1*dHxREox2m8QN6KCFLdMLJQ.gif)

[second_screen.dart](https://github.com/AndriousSolutions/state_set/blob/208af24915e4f27516be73679bdb6fa417d8c994/example/lib/src/home/2/second_screen.dart#L62)

### Show The Count

Well, if that **of**() function is commented out (see below), tapping the 'Home Counter' button seemingly now has no effect since, returning to the home screen, you'll find its counter remains at zero. It does continue to increment, however--- its screen just needs to be updated. With that, the code below was further modified to instead update the home screen only when incrementing the second screen's counter. You can see that with the first arrow below. You see, you need the **setState**() to reflect any changes in your app's interface. With that, you will find in time working with Flutter, getting access to the appropriate State object is essential for the typical functionality you would want in your apps. Again, whole frameworks made to allow for this. Well, let's see if we can't narrow this capability down a bit.

![](https://cdn-images-1.medium.com/max/2500/1*PNycX-hKbZhgiOjFxH2koA.png)

![](https://cdn-images-1.medium.com/max/1000/1*-oAP4Nv6caJEuvPegiPAAQ.gif)

### What State Is It?

First, let's step back a bit and take a look at the **setState**() function. A screenshot of this function is displayed below on the left-hand side. As you know, it takes in a function with no arguments and is commonly described as a 'VoidCallback' function as it's not to return any result either. The first red arrow below shows where this passed function is then called. However note, if any result is returned it's actively cast as type dynamic so possibly anything, of any data type, can be returned. Although no result is expected, this is done so if there is a result, it can be tested by the assert function that follows. This function (present only during development) tests if the result is of type, *Future*. That's because a result of type, *Future*, is not good at this point sinceany 'incomplete' Future object present during the next scheduled 'rebuild' of the app's interface may bring about unpredictable side-effects --- and so the assert function will throw an error if an object of type Future was returned as a result.

You see, working with a declarative programming language that is Flutter, likely in a few microseconds from then, the next scheduled 'rebuild' would occur. The Flutter engine will lay out and redraw the current interface again, and any 'dirty' (marked for rebuild) Elements and consequently their associated Widgets in the widget tree are rebuilt. In fact, if no Future object was returned, the last arrow below shows that State object's own associated Element (and consequently its StatefulWidget) is also marked as 'dirty' so it too is redrawn (and updated) with the next scheduled rebuild. See how that works? 

And so, as you see in the next screenshot below, every time you tap and increment the counter, the associated Element object is 'marked', and consequently that State object's **build**() function is called with the next scheduled 'frame rebuild.' The class field, *_counter*, with its new integer value is passed to the Text widget again, and that Text widget is redrawn (i.e. its own **build**() function is called). With me so far?

[![](https://cdn-images-1.medium.com/max/1500/1*BLpmt-yhGQY9uA2N-R-tbA.png)](https://github.com/flutter/flutter/blob/8874f21e79d7ec66d0457c7ab338348e31b17f1d/packages/flutter/lib/src/widgets/framework.dart#L1244)

![](https://cdn-images-1.medium.com/max/2000/1*rMUPmby3_HFSEhYgSX2GSw.png)

[framework.dart](https://github.com/flutter/flutter/blob/8874f21e79d7ec66d0457c7ab338348e31b17f1d/packages/flutter/lib/src/widgets/framework.dart#L1244) and [home_screen.dart](https://github.com/AndriousSolutions/state_set/blob/208af24915e4f27516be73679bdb6fa417d8c994/example/lib/src/home/1/home_screen.dart#L45)

### Declare Its State

Let's quickly note a characteristic of Flutter's declarative programming framework. See the first screenshot below? Being confident that incrementing the variable, *counter*, will not return a result of type Future, notice its expression is not even passed to the **setState**() function wrapped inside a VoidCallback function. Instead, the variable is incremented first and then the **setState**() function is called (passing along an empty VoidCallback function). Although it is good practice to enclose within a **setState**() function operations that change your app's 'state', you can see it's not mandatory. An empty function passed to the **setState**() function is a practice even found within the Flutter framework itself. Now the code below is of the 'original' counter app and is not found in the Dart package. It's just here to demonstrate something for us right now.

Further note, working with a declarative programming language with its scheduled rebuilds, allows you to call **setState**() in any order inside a function involved in 'changing the state.' In the next screenshot below, the **setState**() function is called before the counter is even incremented. Perfectly fine.

![](https://cdn-images-1.medium.com/max/1500/1*dYgRNolMV0pCC_v1g313uw.png)

![](https://cdn-images-1.medium.com/max/1500/1*RmokXTRrLgqw0FQMFzJ7PA.png)

![](https://cdn-images-1.medium.com/max/500/1*chde-8ULgX1Wsj4pzgtbEg.gif)

### Obtain The State

Ok, let's get back to the topic at hand. When first learning Flutter, you may have assumed it would be relatively easy to obtain a reference to a StatefulWidget's seemingly crucial State object. However, by design, it isn't. For example, there isn't a publicly accessible class property in every StatefulWidget referencing its corresponding State object. It's referenced instead in a private class field called, ***_state,*** --- in a completely different class altogether.

For example, the Home Screen's StatefulWidget (see below) calls its **createState**() function to create its State object, *_HomeScreenState*. However, in truth, it's the StatefulWidget's StatefulElement object (see below) when instantiating that initiates the **createState**() function call. It's that 'Element' object that then stores a reference to the State object in a private class field called, ***_state***. Thus, theState object is not readily accessible. You soon find when working with Flutter, safely making State objects readily accessible becomes a very desirable functionality (again, whole frameworks were written), and here is yet another offered approach.

[![](https://cdn-images-1.medium.com/max/1500/1*ZzngQvsBYbe20L-cXGUAxg.png)](https://github.com/AndriousSolutions/state_set/blob/208af24915e4f27516be73679bdb6fa417d8c994/example/lib/src/home/1/home_screen.dart#L9)

[![](https://cdn-images-1.medium.com/max/2000/1*GtwoFpPIzbOl_p6KOsCuOg.png)](https://github.com/flutter/flutter/blob/8874f21e79d7ec66d0457c7ab338348e31b17f1d/packages/flutter/lib/src/widgets/framework.dart#L4712)

[home_screen.dart](https://github.com/AndriousSolutions/state_set/blob/208af24915e4f27516be73679bdb6fa417d8c994/example/lib/src/home/1/home_screen.dart#L9) and [framework.dart](https://github.com/flutter/flutter/blob/8874f21e79d7ec66d0457c7ab338348e31b17f1d/packages/flutter/lib/src/widgets/framework.dart#L4712)

Again, this 'keeping the State object out of reach' in Flutter is by design. It's even suggested your own State objects also remain private and not readily accessible to outside agents in your app. Their code and content are often too important to be susceptible to outside and third-party modules. The code in State objects literally makes your app's interface after all, and in many cases, contains much of your app's business logic. Access to such code should of course be controlled.

### Public vs Private

True, you're certainly free to make your State object public (with no leading underscore). However, for example, there are few instances where you would want its **build**() function readily accessible to the outside world. Right?

Of course, in your public State class, you could selectively make its properties 'library private' with leading underscores here and there, but would that not be more work? Again, in many cases, a lot of your 'business logic' either resides or is accessible within that class --- containing much if not all of your app's mutable data. With any software development, many undesirable side-effects can arise if you don't control the scope of your app's modules. A leading underscore at the start of a class name relieves you of all of that.

### Control The State

So how would you then access your State objects? A State object's corresponding StatefulWidget is usually readily accessible since, more often than not, it will not have an underscore at the start of its name. With that, it's ideally situated to control access to the State object it uses as it itself has to be defined in the very same Dart library file as its State object. Remember, its State object will have a leading underscore to its name. To demonstrate what I mean by all this, do you recall the very first screenshot in this article? It was where the Home Screen's StatefulWidget's **onPressed**() function is called to increment its counter even though we're currently residing in the second screen. It's back again below. We're calling custom functions found in the StatefulWidget itself --- which unbeknownst to the outside World is accessing functions in its corresponding State object.

Can the second screen access the home screen? Yes! The home screen's StatefulWidget, *HomeScreen*, has no leading underscore. Check! Can the second screen increment the home screen's counter? Yes! It knows to call the home screen's 'increment counter function' called, *onPressed* because it too doesn't begin with an underscore. Check! The Home Screen's StatefulWidget has a clearly defined API to work with. You see, Flutter allows you to instantiate a Widget object, again and again, to access its inner workings without ever calling that Widget's **build**() function. Huge!

[![](https://cdn-images-1.medium.com/max/2500/1*T_bvZ0fjZch-sdaRd_tN5g.png)](https://github.com/AndriousSolutions/state_set/blob/208af24915e4f27516be73679bdb6fa417d8c994/example/lib/src/home/2/second_screen.dart#L62)

![](https://cdn-images-1.medium.com/max/1000/1*62bWQqfDaJ1K_O0v4i-Bgw.gif)

[second_screen.dart](https://github.com/AndriousSolutions/state_set/blob/208af24915e4f27516be73679bdb6fa417d8c994/example/lib/src/home/2/second_screen.dart#L62)

Of course, looking at the code presented above, you can see a more efficient approach would be to instead just call the **setState**() function within the Home Screen's **onPressed**() function --- as it's demonstrated below. However, being such a simple example app, I'm just demonstrating how the static function, ***of***, allows you to retrieve the State object of a known and currently running StatefulWidget and call its ever-important **setState**() function. You may not realize it now, but this one lone capability will prove a very powerful and very useful capability for you and your Flutter apps.

![](https://cdn-images-1.medium.com/max/2000/1*IwHIilioMpyHIvTlvuGj6w.png)

### Find Your State

Let's now take a look at the StatefulWidget, *HomeScreen*, in the screenshot below. Note it uses a factory constructor to prevent multiple instances of this class. As you've already seen, this StatefulWidget is called in other screens so to access its API and not just display an interface. Flutter's declarative nature allows you to easily do this --- its **build**() function will not be called when you instantiate a Stateful or Stateless widget. You're not supplying it to another widget's **build**() function, and so it's perfectly acceptable. You instead are calling the StatefulWidget as a means to access its State object. It would be wasteful to have multiple instances in this case, and so the Singleton pattern is utilized. 

With that, note the **onPressed**() function in the StatefulWidget, in turn, calls the corresponding State object's own **onPressed**() function using the static function, ***to***, from the class, *StateSet*. It's in the State object, where we finally see the actual incrementation involving a private integer field called, *_counter*. It's that static function, ***to***, that reliably retrieves the 'most recent' State object created by this StatefulWidget's **createState**() function. Now, I'll explain this.

![](https://cdn-images-1.medium.com/max/1500/1*DEph05J4hjONOGGewHFiIA.png)

![](https://cdn-images-1.medium.com/max/1500/1*06bpDjsp3B_k7r_P9OeuXg.png)

Again, Flutter is a declarative programming platform. This means its widgets are repeatedly destroyed and rebuilt throughout the typical lifecycle of an app. Even State objects can be disposed of (destroyed) and recreated again and again in certain circumstances --- if and when a new Key value is passed to its corresponding StatefulWidget for example. Again, 'keeping the State object out of reach' in Flutter is by design. If you're not careful, you may access a 'disposed' State object when trying to fire its ever-important **setState**() function. However, the StateSet class keeps track of all this and only provides you the 'currently active' State objects at any point in time in your app.

Calling StateSet's static function, ***to***, in the Home Screen's StatefulWidget ensures its corresponding State object is retrieved. Even then note the **?.** operator is used in the **onPressed**() function. This is in case, for some unbeknownst reason, the State object was not instantiated. Although, since we're are calling the static function right inside the StatefulWidget, *HomeScreen*, I'd suggest it would be highly unlikely to return null. In fact, I'll likely take that operator out of there in the Github repository copy. You won't find it when you try out the Dart package. Such an operator is however very prudent in other cases.

### The State of the Widget

On the third screen of the example app, there are two buttons that allow you to increment the counters on the Home Screen and on the Second Screen. A screenshot of these two buttons is displayed below. Again, highlighted with arrows below, the code merely demonstrates to you the means to retrieve the State object of a particular StatefulWidget. In this case, it's the static function, ***of***, from the StateSet class that is used. It's here by the way where the conditional member access operator (***?.***) would be more prudent because an external StatefulWidget may not be instantiated for some reason. If it returns null, there's no error --- the setState() function simply will not fire and no interface updated. It's on the programmer to figure out why there's no update.

![](https://cdn-images-1.medium.com/max/2500/1*U_aexHZOTG6QK4wcWf_NzQ.png)

![](https://cdn-images-1.medium.com/max/1000/1*pli3fbZXrmFZ4YisDcT2Qw.gif)

### The Root Of It

There's an additional static property available to you when using the StateSet class. It's called *root* and always returns 'the first' State object instantiated in your Flutter app. By Flutter's own design, the first State object instantiated in your app would be considered 'the root State object' as it's above all other any subsequent State objects instantiated in your Flutter app. As you're told, time and time again, a Flutter app is composed of a Widget tree --- with one lone Widget at the top. For many very simple apps, accessing 'the root' State object and calling its **setState**() function would be sufficient to 'refresh the interface' and update the whole app with its changes. That property will prove useful.

In our example app, You can see this 'root' property is used when the Home Screen's counter is reset to zero. Pressing the button, *Reset Home*, on the third screen, you see in the screenshot below the 'root' State object (in this case, the State object, *_MyAppState*) is retrieved only to call its **setState**() function. As you know by now, calling that State object's **setState**() function will cause its accompanying **build**() function to be called again soon after. Now, why is that done, I wonder?

![](https://cdn-images-1.medium.com/max/2500/1*VoW7vimyRVa0gLvaQ83mPA.png)

![](https://cdn-images-1.medium.com/max/1000/1*q7yp0YxbMiPD-59F6GmJaw.gif)

The screenshot below of the State object, *_MyAppState*, reveals that its **setState**() function has been 'tweaked' a little bit. In that function, a 'new key' is assigned its class field, *_homeKey*. Note, it's the very same class field passed to the Home Screen StatefulWidget, *HomeScreen,* highlighted by the first arrow below. You know what that means. 

![](https://cdn-images-1.medium.com/max/2000/1*dS5CALbeFBZX8-Hu5gsxfQ.png)

In Flutter, if a StatefulWidget is assigned a new key, its accompanying State object is destroyed and a new one created. Consequently, in this case, a new State object means a new counter. It doesn't matter, by the way, that the StatefulWidget has a factory constructor. The Flutter engine recognizes a new Key value has come about since the last frame rebuild, and it knows to destroy and rebuild the accompanying State object. And so in this case, with a new State object, there's a new counter defaulting to zero. 

![](https://cdn-images-1.medium.com/max/2500/1*1X5S1XhONCFVSpyt1verog.png)

![](https://cdn-images-1.medium.com/max/1000/1*n4Y2hWHodBxE4K7Ha5p86w.gif)

### A State Map

The three screenshots below are of the three State classes that make up this one example app. Each reveals how a State object is incorporated into the StateSet class for ready access. Each takes in the mixin, *StateSet*. That's it.

![](https://cdn-images-1.medium.com/max/1000/1*7nXwE-JZ2zH4kKFBvkelng.png)

![](https://cdn-images-1.medium.com/max/1000/1*HE9Uaq3aE8c6PqtkQ5-eEA.png)

![](https://cdn-images-1.medium.com/max/1000/1*b5TYQGxa3H06EmbDPI-msA.png)