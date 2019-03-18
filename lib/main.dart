import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

var data = [
  "https://i.imgur.com/tY3sbBZ.jpg",
  "https://cdn.shopify.com/s/files/1/0969/9128/products/Art_Poster_-_Sicario_-_Tallenge_Hollywood_Collection_47b4ca39-2fb6-45a2-9e85-d9ef34016e8a.jpg?v=1505078993",
  "https://www.movieposter.com/posters/archive/main/82/MPW-41488",
  "https://m.media-amazon.com/images/M/MV5BMTU2NjA1ODgzMF5BMl5BanBnXkFtZTgwMTM2MTI4MjE@._V1_.jpg",
  "https://cdn-images-1.medium.com/max/1600/1*H-WYYsGMF4Wu6R0iPzORGg.png",
  "https://static01.nyt.com/images/2017/09/24/arts/24movie-posters1/24movie-posters1-jumbo.jpg",
];

var MOVIE_POSTER_ASPECT_RATIO = 27.0 / 41.0;
var WIDGET_ASPECT_RATIO = MOVIE_POSTER_ASPECT_RATIO * 1.2;

/*
Rules:
Movie posters must maintain aspect ratio
custom view should maintain fixed aspect ratio, moderately wider than movie poster


 */

class _MyHomePageState extends State<MyHomePage> {
  double currentPage = data.length - 1.0;

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: data.length - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });

    return Scaffold(
        body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Text(
              "Movies",
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          Stack(children: <Widget>[
            PosterScrollWidget(data, currentPage),
            Positioned.fill(
              child: PageView.builder( //this PageView is basically a glorified GestureDetector.
                  itemCount: data.length,
                  controller: controller,
                  itemBuilder: (context, index) {
                    return Container();
                  }),
            ),
          ]),
        ],
      ),
    ));
  }
}

class PosterScrollWidget extends StatelessWidget {
  double currentPage;
  List<String> data;

  var padding = 20.0;
  var hiddenPosterVerticalInset = 20.0;

  PosterScrollWidget(this.data, this.currentPage);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: WIDGET_ASPECT_RATIO,
        child: LayoutBuilder(builder: (context, constraints) {
          var width = constraints
              .maxWidth; //above aspect ratio ensures fixed width and height
          var height = constraints.maxHeight;

          var safeWidth = width - 2 * padding;
          var safeHeight = height - 2 * padding;

          var heightOfPrimaryPoster = safeHeight;
          var widthOfPrimaryPoster =
              heightOfPrimaryPoster * MOVIE_POSTER_ASPECT_RATIO;

          var primaryPosterLeft = safeWidth - widthOfPrimaryPoster;

          var hiddenPosterHorizontalInset = primaryPosterLeft / 2;

          var posters = <Widget>[];
          for (var i = 0; i < data.length; i++) {
            var url = data[i];
            var deltaFromCurrentPage = i -
                currentPage; //should be positive if page is to the right, negative if to the left
            var isOnRight = deltaFromCurrentPage > 0;
            if (deltaFromCurrentPage > 1 || deltaFromCurrentPage < -4) {
              continue;
            }
            var opacity = 0.0;
            if (deltaFromCurrentPage < 0) {
              opacity = clamp(1 + 0.33 * deltaFromCurrentPage, 0, 1);
            } else if (deltaFromCurrentPage < 1) {
              opacity = clamp(
                  1 - 2 * (deltaFromCurrentPage - deltaFromCurrentPage.floor()),
                  0,
                  1);
            } else {
              opacity = 0;
            }

            var start = padding +
                max(primaryPosterLeft - hiddenPosterHorizontalInset * -deltaFromCurrentPage * (isOnRight ? 15 : 1), 0);

            posters.add(Positioned.directional(
              key: Key(url),
              top: padding +
                  hiddenPosterVerticalInset * max(-deltaFromCurrentPage, 0.0),
              bottom: padding +
                  hiddenPosterVerticalInset * max(-deltaFromCurrentPage, 0.0),
              start: start,
              textDirection: TextDirection.ltr,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: deltaFromCurrentPage < 0
                      ? BoxDecoration(color: Colors.white)
                      : BoxDecoration(),
                  child: Opacity(
                    opacity: opacity,
                    child: AspectRatio(
                      aspectRatio: 27.0 / 41.0,
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ));
          }

          return Stack(
            children: posters,
          );
        }));

    //Stack(children: posters)),
  }
}

double clamp(double val, double min, double max) {
  if (val < min) return min;
  if (val > max) return max;
  return val;
}
