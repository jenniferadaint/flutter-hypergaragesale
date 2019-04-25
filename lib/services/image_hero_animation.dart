import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:hyper_garage_sale/modules/item.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PhotoHero extends StatelessWidget {

  const PhotoHero({ Key key, this.tag, this.onTap, this.width}) : super(key: key);

  final String tag; // used to be unique tag of each Hero and as url for Image
  final VoidCallback onTap;
  final double width;

  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: tag,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: new CachedNetworkImage( // using CachedNetworkImage to download image
                                            // from firebase
              imageUrl: tag,
              placeholder: (context, url) => new CircularProgressIndicator(),
              errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
           // child: Image.network(tag),
          ),
        ),
      ),
    );
  }
}

// using ImageDisplay to display all images each item has
class ImageDisplay extends StatelessWidget {
  Item item;
  ImageDisplay({this.item});
  double width = 150.0;
  double height = 150.0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  new Center(
      child: new Wrap(
      children: <Widget>[
        item.url1 == "" ? new SizedBox( // check if the item has image or not
          width: 180.0,
          height: 140.0,
          child: Image.asset("images/no_image.png", fit:
            BoxFit.contain
          ),
        )
            : new SizedBox(
          width: width,
          height: height,
          child: HeroAnimation(tag: item.url1
          ),
        ),
        item.url2 == "" ? Text("") : new SizedBox(
          width: width,
          height: height,
          child: HeroAnimation(tag: item.url2
          ),
        ),
        item.url3 == "" ? Text("") : new SizedBox(
          width: width,
          height: height,
          child: HeroAnimation(tag: item.url3
          ),
        ),
        item.url4 == "" ? Text("") : new SizedBox(
          width: width,
          height: height,
          child: HeroAnimation(tag: item.url4
          ),
        ),
      ],
    ),
    );
  }
}

// Animation between  thumbnail and image
class HeroAnimation extends StatelessWidget {
  String tag;
  HeroAnimation({this.tag});
  Widget build(BuildContext context) {
    timeDilation = 1.0; // 1.0 means normal animation speed.
    return
      Container(
        padding: const EdgeInsets.all(16.0),
        child: PhotoHero(
          tag: tag,
          width: 150.0,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Zoomed Image'),
                    ),
                    body: Center(
                      child: PhotoHero(
                        tag: tag,
                        width: 300.0,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  );
                }
            ));
          },
        ),
        //),
      );
  }
  }



