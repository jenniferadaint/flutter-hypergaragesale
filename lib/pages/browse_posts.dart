import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hyper_garage_sale/services/authentication.dart';
import 'package:hyper_garage_sale/pages/new_post.dart';
import 'package:hyper_garage_sale/modules/item.dart';
import 'view_details.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomePage>{
  List<Item> items = []; // store the new posts
  DatabaseReference itemRef;
  DataSnapshot snapshot;
  bool _isEmailVerified = false;

  @override
  void initState() {
    _checkEmailVerification(); // initially, check if authenticated

    super.initState();
    final FirebaseDatabase database = FirebaseDatabase.instance;
    itemRef = database.reference().child('items');
    itemRef.onChildAdded.listen(_onEntryAdded);
    itemRef.onChildChanged.listen(_onEntryChanged);
  }

  _onEntryAdded(Event event) {
    setState(() {
      items.add(Item.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var old = items.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      items[items.indexOf(old)] = Item.fromSnapshot(event.snapshot);
    });
  }

  // handle user signout
  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  // before show content, checking authentication
  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }
  void _resentVerifyEmail(){
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resent link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('HyperGarageSale',
          style: TextStyle(
              fontSize: 24.0
          ),),
        actions: <Widget>[
          FlatButton(
            child: Text("Logout"
          , style:
              new TextStyle(
                fontSize: 17.0,
                color: Colors.black
              ),),
            onPressed: () async {
              _signOut();
            },
          )
        ],
      ),
      body: new Container(
          padding: new EdgeInsets.only(left: 20.0, right: 25.0),
          child: FirebaseAnimatedList( // a dynamical view/ recycle view
              query: itemRef,
              itemBuilder: (
                  BuildContext context, DataSnapshot snapshot, Animation<double> animation,
                  int index) {
                return GestureDetector(
                  child: Container (
                    padding: const EdgeInsets.only(top: 10.0),
                    child: new Row(
                      children: <Widget>[
                        new SizedBox(
                          width: 90.0,
                          height: 90.0,
                          child: items[index].url1 == "" ? Image.asset("images/no_image.png",
                            fit: BoxFit.contain, )
                              :new CachedNetworkImage(
                            imageUrl: items[index].url1,
                            placeholder: (context, url) => new CircularProgressIndicator(),
                            errorWidget: (context, url, error) => new Icon(Icons.error),
                          ),
                        ),
                        Text(
                          items[index].title,
                          style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.black
                          ),
                        ),
                        IconButton(icon: Icon(Icons.keyboard_arrow_right), onPressed: null,
                          alignment: Alignment.bottomRight,)
                      ],
                    )
                  ),
                  onTap: () {
                    viewDetils(context, items[index]);
                  },
                );
              }
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          addNew(context);
        },
        tooltip: "To New Post",
        child: Icon(Icons.add),
      ),
    );
  }

  // view details of a post
  void viewDetils(BuildContext context, Item item) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ViewDetail(item: item)),
    );
  }

  // add a new post
  void addNew(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPage()),
    );
  }
}