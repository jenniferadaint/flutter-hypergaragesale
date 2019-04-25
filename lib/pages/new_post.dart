import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hyper_garage_sale/services/process_dialog.dart';
import 'package:hyper_garage_sale/modules/item.dart';
import 'dart:io';
import 'package:hyper_garage_sale/services/image_picker_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        title: Text('Add New Post'),
      ),
      body: new Container(
        padding: new EdgeInsets.only(left: 20.0, right: 25.0),
        child: new CustomForm(),
      ),
    );
  }
}

// Handle the Form
class CustomForm extends StatefulWidget {
  @override
  _CustomFormState createState() => new _CustomFormState();
}

class _CustomFormState extends State<CustomForm>  with TickerProviderStateMixin,ImagePickerListener{
  final _textFormKey = GlobalKey<FormState>();
  Item item;
  DatabaseReference itemRef;
  bool _loading = false;
  List<File> files = List();
  List<String> urls = List();
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  String fileName = "";

  Future<Null> uploadFile(File file) async {
    fileName  = "${Random().nextInt(10000)}.jpg"; // randomly generate name of image file
    StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = ref.putFile(file);
    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    var urlString = downloadUrl.toString();
    // store the downloaded one url to item object
    setState(() {
      if(item.url1 == "") {
        item.url1 = urlString;
      }else if(item.url2 == ""){
        item.url2 = urlString;
      }else if(item.url3 == ""){
        item.url3 = urlString;
      }else if(item.url4 == ""){
        item.url4 = urlString;
      }
    });
  }

  // store all image url into item object
  Future<Null> uploadAndDownloadAll(List<File> files) async{
    if (_textFormKey.currentState.validate()) {
      files.map((f) => uploadFile(f)).toList();
    }
  }

  // show the flutter toast when the uploading images process completed
  Future<Null> _onRefresh() async {
    setState(() {
      _loading = !_loading;
    });
    await Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _loading = !_loading;
        Fluttertoast.showToast(msg: "Successful!");
      });
    });
  }

  Future<Null> handleSubmit() async{
    if (_textFormKey.currentState.validate()) {
      _textFormKey.currentState.save();
      itemRef.push().set(item.toJson());
      item = Item("", "", "", "", "", "", "");
      Scaffold.of(context)
          .showSnackBar(SnackBar(
        content: Text('New post added successfully!'),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    item = Item("", "", "", "", "", "", "");
    final FirebaseDatabase database = FirebaseDatabase.instance;
    itemRef = database.reference().child('items');
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker=new ImagePickerHandler(this,_controller);
    imagePicker.init();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _textFormKey,
      child: ProgressDialog(
          loading: _loading,
          msg: 'Uploading images...',
          child:ListView(
          children: <Widget>[
          new TextFormField(      // first TextFormField: title
            style: TextStyle(
                fontSize: 22.0,
                color: Colors.black54
            ),
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top:40.0, bottom: 10.0),
                hintText: 'Enter title of the item'
            ),
            initialValue: "",
            onSaved: (val) => item.title = val,
            validator: (value) {
              if (value.isEmpty) {
                return 'Input not valid';
              }
            },
          ),
          new TextFormField(      // second TextFormField: price
            style: TextStyle(
                fontSize: 22.0,
                color: Colors.black54
            ),
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top:30.0, bottom: 10.0),
                hintText: 'Enter price',

            ),
            initialValue: "",
            onSaved: (val) => item.price = val,
            validator: (value) {
              if (value.isEmpty) {
                return 'Input not valid';
              }
            },
          ),
          new TextFormField(      // Third TextFormField: description
            style: TextStyle(
                fontSize: 22.0,
                color: Colors.black54
            ),
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter description of the item',
              contentPadding: const EdgeInsets.only(top:30.0, bottom: 90.0),
            ),
            initialValue: "",
            onSaved: (val) => item.description = val,
            validator: (value) {
              if (value.isEmpty) {
                return 'Input not valid';
              }
            },
          ),
          new Wrap(              // images attached with each post
            runSpacing: 4.0,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.camera_enhance, size: 40.0,),
                  tooltip: "Take photo",
                  onPressed: () => imagePicker.showDialog(context), // take picture, and save
                ),
                constructImages(),
              ],
            ),
          //),
          new Container(         // upload images
            padding: const EdgeInsets.only(left: 298.0, top: 15.0),
              child: RaisedButton(
                child: const Text("Upload Image",
                  style: TextStyle(
                    fontSize: 11.0,
                    color: Colors.yellow
                  )
                ),
                splashColor: Colors.blue,
                color: Colors.black54,
                onPressed: () async {
                  if (_textFormKey.currentState.validate()) {
                    await uploadAndDownloadAll(files);
                    _onRefresh();
                  }
                }
              ),
          ),

          Padding(            // save the new post to firebase real time database
            padding: const EdgeInsets.only(left: 0.0, top: 30.0, bottom: 0.0),
            child: RaisedButton(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                color: Colors.yellow,
                onPressed: () async {
                  await handleSubmit();
                  await new Future.delayed(const Duration(seconds: 2)); // after 2s, back to home
                  Navigator.pop(context);
                },
                child: Text('POST')
            ),
          ),
        ],
      ),
      )
    );
  }

  Widget constructImages()  { // display the images which are taken by camera and saved
    return Container(
      padding: const EdgeInsets.only(left: 10.0),
      child: Wrap(
            children: files
                .map((f) => GestureDetector(
                child: new Container(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Image.file(f, height: 80.0, width: 80.0),
                ))).toList(),
          ),
    );
  }

  @override
  userImage(File _image) {
    setState(() {
      files.add(_image);
    });
  }
}
