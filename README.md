# HyperGarageSale
#### A Flutter application (iOS/Android)
## Structure of this document

* [Introduction](#intro)
* [Getting start](#setup)
* [Demo](#demo)

## <a name="intro" style="color: #000;"> Introduction </a>

### Project Scope

This project is a starting point for a Flutter application with Firebase as backend. HyperGarageSale is a Flutter application with features
 
* User authentication by email
* Add new posts with photos 
* Using camera
* Display all posts' preview
* View details of each post
* Back up data with Firebase

### Skills & Tools Required

* Flutter environment. To develop a Flutter application, your developement environment must meet these [minimum requirements](https://flutter.dev/docs/get-started/install) .  
* Adequate knowledge of [Dart](https://www.dartlang.org/guides/language/language-tour) is required to be able to maintain and furthur expand this project.

A few resources to help getting start if this is your first Flutter project:

* [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
* [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)


## <a name="setup" style="color: #000;"> Getting Start </a>    

1. Create a new Flutter application or clone this project
2. [Register the app in Firebase](https://firebase.google.com/docs/flutter/setup). This project only configured Andriod app. 
-  Install dependencies. To avoid gradle crashes, make sure all packages used are [lastest major version](https://flutter.dev/docs/development/packages-and-plugins/androidx-compatibility)
	* open pubspec.yaml file, add packages in dependencies, eg: 

	 ``` 
	 dependencies:
		  flutter:
		    sdk: flutter
		  image_picker: ^0.4.12+1
		  firebase_database: ^1.0.5
		  firebase_core: ^0.2.5+1  
		  firebase_storage: ^1.0.4
		  firebase_auth: ^0.7.0
		  fluttertoast: ^3.0.4
	```
	* run ` $ flutter packages get`
			
## <a name="dem0" style="color: #000;"> Demo </a>

#### Login and Signup

<img src="https://user-images.githubusercontent.com/35616520/56709601-03d80000-66d7-11e9-84b7-44d5d7e75ac8.png" width="160"/>   <img src="https://user-images.githubusercontent.com/35616520/56709619-194d2a00-66d7-11e9-9d3e-26bc22afa765.png " width="160">

#### Dispaly all posts

<img src="https://user-images.githubusercontent.com/35616520/56709641-2e29bd80-66d7-11e9-83e7-b116f1965eb5.png" width="160">

#### Add new posts

<img src="https://user-images.githubusercontent.com/35616520/56710122-76e27600-66d9-11e9-85a2-6ee02d676518.png" width="160"> <img src="https://user-images.githubusercontent.com/35616520/56709662-44377e00-66d7-11e9-879d-f9d7ab9adf64.png" width="160">

#### View posts
<img src="https://user-images.githubusercontent.com/35616520/56709693-6cbf7800-66d7-11e9-8648-b5c4ed90d860.png" width="160"> <img src="https://user-images.githubusercontent.com/35616520/56710035-19e6c000-66d9-11e9-9855-ffefbb6448e1.png" width="160">

