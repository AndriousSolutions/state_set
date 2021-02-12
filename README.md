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

## Learn By Example App
Turn to the supplied example app to learn how to use this package.
[![exampleBlocs](https://user-images.githubusercontent.com/32497443/102015078-e843c200-3d1e-11eb-9a6f-722ad2aa3c22.jpg)](https://github.com/AndriousSolutions/set_state/blob/81ada0221dd8f921d2832f6782cdc5d94960d92e/example/lib/main.dart#L257)

## The Business side of the StateSet object
Use the mixin, *StateBloc*, to readily access the underlying 'state object.' As you can see the class, _CounterBloc, below is the parent class of those above.
[![counterBloc](https://user-images.githubusercontent.com/32497443/102015308-6fde0080-3d20-11eb-8ace-47579dd30410.jpg)](https://github.com/AndriousSolutions/set_state/blob/81ada0221dd8f921d2832f6782cdc5d94960d92e/example/lib/main.dart#L286)
## By Example
I'll use well-established examples to demonstrate the this package. We'll use the time-honored ‘startup app’ (the counter app) that’s presented to you when you create a new Flutter project. It’s a classic example. However, this time, we’re going to ramp it up a bit to fully demonstrate the little Dart library file presented here.

You'll find a good computer application, in most instances, divides ‘the interface’ from everything else that makes up your app. Doing this alone makes for better progress during development and better scalability and maintenance down the road. When it comes to Flutter apps, there’s one common trait found in adaptive apps — the access to particular State objects. More specifically, access to their ever-important setState() function.

Below, listed with the first half of the example app we’re using today, is a gif file demonstrating the functionality of that example app. Note, there’s not one, not two, but three State objects (Flutter pages) that make up this example app. In fact, there are four State objects in all — you’ll see that soon enough. Regardless, there are four ‘states’ being retained and managed. This an attempt to convey a typical Flutter app in the guise of a very simple example app, and so it’s a counter app with three counters. Their pages come one after the other. While running, you can go up and down the routing stack. The app is demonstrating the ‘state management’ involved.
|  |  |
| --- | --- |
| ![main](https://user-images.githubusercontent.com/32497443/102795641-b2cc5380-4372-11eb-8768-ccdb17caea92.jpg) | ![Counter App](https://user-images.githubusercontent.com/32497443/102795074-e78bdb00-4371-11eb-9c5c-39bf1b62035c.gif) |

## The Classic State
In the gif above, you see we're going up through the three pages incrementing their individual counters along the way. There's a number of buttons offered so to navigate up and down the routing stack. As anticipated, returning back down the pages then up again, the counter on the third page is reset to zero. This makes sense. The app had retreated back down the routing stack, and the State object retaining the counter (the state) on the third page was terminated (its dispose() function called). Perfectly normal. However, notice the second page is keeping its counter value?? How is it doing that?!

Further note, on the second and third pages, you can increment the counters on the previous page! On the third page, for example, there are two buttons to increment both the second page and the home page. Well, that's neat. Now how is that done? Finally, pressing that 'Home Page New Key' found all the way up on page three results in the counter on the first page (the Home page) to be reset to zero! Now, what's going on there? Granted, this is such a rudimentary example, but it does demonstrate some fundamental aspects involved in the State Management of a typical Flutter app.
> Use the setState() function to a particular State object.

Let's examine the first State object responsible for displaying a screen to the user. In this case, it's the 'Home page' greeting the user with the first counter. Below is a screenshot of that State with little red arrows highlighting points of interest. What do you see?

First and foremost, you can see the example app is using a subclass of the State class called, SetState. What else do you see? Well, there's 'the separation of work' that I personally live by when developing code. More specifically, there's always a separate and dedicated class (_HomePageBloc in this case) that's responsible for the actual 'business logic' involved in the app while the build() function in some widget somewhere is responsible for the interface.

Further, there's the degree of abstraction as the API between these separate areas of responsibility. As an example, the actual 'counter' here in this app is concealed by the class property, data. There's also consistent practice of naming instance fields after the parameter used by the receiving Widget. As it happens, the Text widget's first parameter is named data. All this a consistent approach---a design pattern.
![HomePageState](https://user-images.githubusercontent.com/32497443/102799105-a8f91f00-4377-11eb-94e2-1b8c2738cbf5.jpg)

The three Bloc classes (no direct relation to the BloC design pattern) you'll find in this example are indeed the 'Business Logic Components' for the app. Each has its own little bit of responsibility (their own little bit of 'state to manage'). They're also the app's event handlers---each response to particular events that may be triggered by the user or by the system (the phone) itself.

The screenshot below presents the first Bloc somewhat named after the State object it's to work with. It even explicitly takes in the type of that State object it works with. At a glance, you can see this Bloc class is for the home screen.
![HomePageState](https://user-images.githubusercontent.com/32497443/102799437-2755c100-4378-11eb-9d88-9f4d0d8d6c83.jpg)

Let's take a deep dive into the instantiation of all three Bloc classes. All three Blocs in this app take advantage of inheritance extending from the common parent class, _CounterBloc. After all, they all pretty much do the same thing and so that function is found in one parent class---working with an integer called, counter.
Regardless, note the first Bloc class, _HomePageBloc, doesn't know the type of State object beforehand, and so that type is passed in as a generic type. While in the second Bloc class, _SecondPageBloc, the State type is known and is explicitly specified. Which approach to use, of course, depends on the circumstance. At least, you're free to use either. You have that option.

Further note, the second class utilizes a factory constructor, and that's how it retains its count even when you retreat back down the routing stack! In every Flutter app you write, returning to a previous page will remove a Page from the stack, and if it's represented by a StatefulWidget, that means the StatefulWidget's State object will be disposed of. Every time. Unless you do something about it.

![HomePageBloc](https://user-images.githubusercontent.com/32497443/102799942-caa6d600-4378-11eb-8a7d-0282df139e0d.jpg)

You'll note, when it comes to the second page, the 'State Management' has been allocated to a separate class altogether and not left to the State object. Following the Singleton design pattern, the _SecondPageBloc class remains in resident memory for the life of the app. Thus keep its counter (its state) and is assigning a brand new State object to itself (the second arrow) whenever a user comes back to that page.

Now, let's look at the third and final Bloc class, _ThirdPageBloc. Note that the instance field, state, is successfully overridden with a getter. THIS IS HUGE! Do you know why? It's huge you can successfully override a mutable instance field with an immutable getter! Since a getter is essentially 'instantiated' only when it's first used, you can provide the 'type of state', but you're not obligated to instantiate a reference to that State right then and there! You can wait. Possibly in some situations, the State is not to be instantiated at that point---It may not be available for some reason.

## _CounterBloc class
We might as well take a look at that parent class to the Bloc's now. Again, it's an event handler. Such a class is required to respond to events. In this case, the most profound event is when a user taps on the plus sign to increment the counter. Thus, the most important capability of this class is to then notify the appropriate State object when it's completed responding to that event.

As you know, it does have access to the ever-important setState() function for a particular State object. It takes advantage of that access and even defines its own setState() function---for any other modules to then call to notify the app and reflect a change. Finally, it offers a corresponding dispose() function to be called in its State object's own dispose() function when the State object itself indeed terminates during the course of the app's lifecycle. It's all nice and compact. However, we could do better.

![CounterBloc](https://user-images.githubusercontent.com/32497443/102807335-0eeba380-4384-11eb-8ea3-cfb44ddcbe68.jpg)

Note, such abilities, on the whole, should be present in any and all modules that are to work with a SetState object in this fashion. Such abilities should be readily available to any class you may define to contain the 'business logic' of an app. Such a circumstance would therefore be a good candidate for a mixin, no? A screenshot of that mixin is below.

![StateBloc](https://user-images.githubusercontent.com/32497443/102807426-3b9fbb00-4384-11eb-8bb8-2d5ca9a811ed.jpg)

That parent class, *_CounterBloc*, has now been changed---focusing truly now on the one lone functional responsibility assigned to it in this particular app. When it increments its counter, it then notifies the rest of the app with the setState() function. It now takes in the mixin using the keyword, *with*, resulting in code generally being more modular. Further, as you see below, there's a higher cohesion in the resulting class.

![CounterBloc](https://user-images.githubusercontent.com/32497443/102807598-920cf980-4384-11eb-982e-8ffe1f1aa625.jpg)

## Navigating The State
Looking at the third page in the routing stack, we see it presents to the user five buttons. The first three buttons literally affect 'the state' in three separate regions in the app. The first button calls upon a provided Bloc object to respond to the event of incrementing that page's counter. The next three buttons involve the State objects from 'previously visited' areas of the app. Each is responsible for retaining their own state. Note, the names of the VoidCallback functions of the State objects, *homeState*, and *secondState*: onPressed. Should the fourth and last State object also have such a function?

|  |  |
| --- | --- |
|![floatingButton](https://user-images.githubusercontent.com/32497443/102807964-3b53ef80-4385-11eb-9f8d-92f18af98e6d.jpg) |![PageThree](https://user-images.githubusercontent.com/32497443/102808169-8968f300-4385-11eb-8f18-c6af5434355d.jpg) |

## Attain Your State
Our last look at the third-page State object highlights the four approaches taken to supply the event handling and business logic, as it were, onto this last page. Most of them involve a static function from, in fact, the StateSet mixin.

Note, all but the last State object instantiated is a specific type unique to this app. In other words, this class (this module) has to explicitly know the names of the other classes involved in this app to function. The last instance field, however, is assigned the foundational type, SetState.

![PageThreeSource](https://user-images.githubusercontent.com/32497443/102808448-f4b2c500-4385-11eb-8f18-10b045322a87.jpg)

Polymorphism is in play here. The first 'SetState' object (retrieved by SetState.root)can be anything---we don't know what from this vantage point. However, we do know it is a 'SetState' object. More so, we know it's a State object, and so we know we can call its setState() function from this class---from this vantage point. What it does when we call this object's setState() function, we can only guess. We'll look into what exactly happens next.

![setState](https://user-images.githubusercontent.com/32497443/102808619-2fb4f880-4386-11eb-888d-1c3e8f0184ed.jpg)

## A New Home
Remember, pressing that 'Home Page New Key' button resets the counter to zero on the Home page. Actually, what it does is re-create the State object itself displaying that page! Now does that sound right to you? After all, State objects are to stay in memory retaining their state, right? I mean, that's Flutter's whole State Management approach. This is 'the first' and founding State object for this app. It doesn't terminate until the app does, no? However, if you assign a new key to a State object's corresponding StatefulWidget, that State object is disposed of and a new one created. Let's walk through it and show you how this happens.

Let's look at the two screenshots below. The screenshot on the left-hand side below reveals when you press the 'Home Page New Key' button, the 'app state' State object calls its setState() function. That setState() function is displayed on the right-hand side includes assigning a new value to the instance field, _homeKey. That field, as you see in the build() function above, is passed as the key to the StatefulWidget, MyHomePage. Calling setState() will run the build() function once again, however this time, with a new key.

Calling the setState() function from the State object, appStat---the fourth State object I spoke of, with its the StatefulWidget, _MyApp, being passed to the runApp() function, will cause its build() function to fire again. This means the named parameter, home, receives a StatefulWidget with a brand new key. In turn, this means that the StatefulWidget's createState() function is fired again and a new State object is created. One that calls its initState() and build() functions again.

|  |  |
| --- | --- |
| ![HomePageCounter](https://user-images.githubusercontent.com/32497443/102808953-c8e40f00-4386-11eb-96a1-575debd648b5.jpg) | ![MyAppState](https://user-images.githubusercontent.com/32497443/102809032-ed3feb80-4386-11eb-996a-6e8fe9153b91.jpg) |

## Set Your State
Let's finally take a look at the class, SetState, replacing the traditional State objects in the app. Being abstract, of course, you have to implement its **build**() function, but you still have access to the usual and useful properties found in a State object: mounted, context, and widget. You can see in the screenshot below, this State object adds itself to the collection of State objects used by your app. It removes itself from that collection when it itself terminates. Finally, as you see below, it has its ever-important static function, **of**. You're familiar with such functions in Flutter: Theme.of(), and Scaffold.of().

![SetState](https://user-images.githubusercontent.com/32497443/102809199-3132f080-4387-11eb-8925-ea441c80e041.jpg)

## Magic In The Mix
You'll note the mixin, *StateSet*, utilized in the abstract class above. It is this mixin that stores the collection State objects. Further, looking at the mixin below, you now have a subclass of the State class allowing you to call the **setState**() function without complaint.

![StateSet](https://user-images.githubusercontent.com/32497443/102809463-a7cfee00-4387-11eb-9c01-453820d87c7e.jpg)
