import 'package:flutter/material.dart';
import 'package:hyper_garage_sale/services/image_hero_animation.dart';
import 'package:hyper_garage_sale/modules/item.dart';
/*
  This page is used to display the details of an item when it is clicked in the home page's ListView
 */
class ViewDetail extends StatelessWidget{
  final Item item;
  ViewDetail({Key key, this.item}) : super(key: key);

  void popFrom(BuildContext context) {
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                popFrom(context);
              },
            );
          },
        ),
        title: Text(item.title),
      ),
      body: new ListView( // using ListView which enables auto-scroll
        children: <Widget>[
          ImageDisplay(item: item,
          ),
          new Container(
            padding: const EdgeInsets.all(20.0),
            alignment: Alignment.topLeft,
            child: Text("Description: ",
              style:
              new TextStyle(
                  fontSize: 23.0,
                  fontFamily: "Times New Roman"
              ),),
          ),
          new Container(
            padding: const EdgeInsets.only(left: 25.0),
            child: Wrap(
              spacing: 8.0,
              children: <Widget>[
                Text("Price: ", style:
                new TextStyle(
                    fontSize: 20.0,
                    color: Colors.blue,
                    fontFamily: "Times New Roman",
                ),
                ),
                Text(item.price, style:
                new TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  fontFamily: "Times New Roman",

                ),
                )
              ],
            ),
          ),
          new Wrap(     // using wrap to avoid overflow of the screen and auto wrap for line
            children: <Widget>[
              new Container(
                padding: const EdgeInsets.only(left: 25.0, top: 25.0),
                child:
                  Text(item.description, style:
                  new TextStyle(
                      fontSize: 20.0,
                    fontFamily: "Times New Roman",
                  ),
                  ),
              ),
            ],
            //padding: const EdgeInsets.only(top: 20.0, left: 10.0),
          ),
        ],
      ),
    );
  }

}