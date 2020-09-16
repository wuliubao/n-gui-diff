import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'confirm.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Animation Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'animation'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {

  List<String> items = <String>['A', 'B', 'C', 'D', 'E', 'F'];
  List<double> itemsHeight = <double>[100.0, 100.0, 100.0, 100.0, 100.0, 100.0];

  double animValue = 100.0;


  void _changeValue() {
    setState(() => animValue = animValue == 100 ? 200.0 : 100.0);
  }

  void startDrag(DragStartDetails details) {
    print("touch start?");
    setState(() {
      animValue = animValue == 100 ? 200.0 : 100.0;
    });
  }

  ScrollController _scrollController = new ScrollController();


  @override
  void initState() {
    _scrollController.addListener(() {
      print("scroll?");
    });

    super.initState();
  }

  Widget buildList(BuildContext context, String item) {
    return new GestureDetector(
        onTap: () {
          print("tap???????");
        },
        child:
        new Stack(
          children: <Widget>[
            new Container(
              //curve: Curves.bounceOut,
              //duration: new Duration(seconds: 1),
              height: 20 + animValue,
              width: 300.0,
              alignment: Alignment.topRight,
              margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
              decoration: new BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Container(
                    height: 20.0,
                    width: 180.0,
                    margin: EdgeInsets.all(10.0),
                    decoration: new BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
//                    new Container(
//                      height: 15.0,
//                      width: 100.0,
//                      margin: EdgeInsets.all(5.0),
//                      decoration: new BoxDecoration(
//                        color: Colors.lightBlue,
//                        borderRadius: BorderRadius.circular(5.0),
//                      ),
//                    ),
//                    new Container(
//                      height: 15.0,
//                      width: 100.0,
//                      margin: EdgeInsets.all(5.0),
//                      decoration: new BoxDecoration(
//                        color: Colors.lightBlue,
//                        borderRadius: BorderRadius.circular(5.0),
//                      ),
//                    ),
                  new RaisedButton(
                    child: new Text('GO'),
                    onPressed: _changeValue,
                  ),
                ],
              ),
            ),
            new GestureDetector(
              onPanStart: startDrag,
              child: new Container(
                height: 20 + animValue,
                width: 100.0,
                // margin: EdgeInsets.fromLTRB(10.0, 20.0, 100.0, 20.0),
                // duration: new Duration(seconds: 1),
                child: new ListView(
                  // padding: EdgeInsets.fromLTRB(10.0, 20.0, 100.0, 20.0),
                  // padding: new EdgeInsets.symmetric(vertical: 4.0),
                    scrollDirection: Axis.horizontal,
                    //   controller: _scrollController,
                    children: [
                      new Image.asset("images/placeholder.png"),
                      new Image.asset("images/placeholder.png"),
                      new Image.asset("images/placeholder.png"),
                    ]
                ),
              ),
            ),
            new Container(
              width: 200.0,
              height: 50.0,
              margin: EdgeInsets.fromLTRB(110.0, 0.0, 0.0, 0.0),
              color: Colors.red,
            )
          ],
        )
    );
  }


  Widget buildItemList(BuildContext context, int index) {
    return new GestureDetector(
        onTap: () {
          setState(() {
            itemsHeight[index] = itemsHeight[index] == 100 ? 200.0 : 100.0;
          });
          print("tap???????");
        },
        child:
        new Stack(
          children: <Widget>[
            new AnimatedContainer(
              //curve: Curves.bounceOut,
              //duration: new Duration(seconds: 1),
              duration: new Duration(milliseconds: 300),
              height: itemsHeight[index],
              width: 300.0,
              alignment: Alignment.topRight,
              margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
              decoration: new BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Container(
                    height: 20.0,
                    width: 180.0,
                    margin: EdgeInsets.all(10.0),
                    decoration: new BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  new RaisedButton(
                    child: new Text('GO'),
                    onPressed: _changeValue,
                  ),
                ],
              ),
            ),
            new AnimatedContainer(
              height: -20+itemsHeight[index],
              width: 100.0,
              margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
              duration: new Duration(milliseconds: 300),
              child: new ListView(
                // padding: EdgeInsets.fromLTRB(10.0, 20.0, 100.0, 20.0),
                // padding: new EdgeInsets.symmetric(vertical: 4.0),
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  children: [
                    new Image.asset("images/placeholder.png"),
                    new Image.asset("images/placeholder.png"),
                    new Image.asset("images/placeholder.png"),
                  ]
              ),
            )
          ],
        )
    );
  }

  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    Iterable<Widget> listContainer = items.map((String item) =>
        buildList(context, item));
    listContainer =
        ListTile.divideTiles(context: context, tiles: listContainer);


    return new DefaultTabController(
      length: 3,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('animation'),
          bottom: new TabBar(
            tabs: <Widget>[
              new Tab(icon: new Icon(Icons.view_stream),),
              new Tab(icon: new Icon(Icons.view_stream),),
              new Tab(icon: new Icon(Icons.view_stream),),
            ],
            controller: _tabController,
            indicator: new BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        body: new TabBarView(
          children: <Widget>[
            new Container(
              color: Colors.lightBlue,
              child: new Scrollbar(
                  child: ListView.builder(
                      itemCount: 6,
                      itemBuilder: buildItemList)
              ),
            ),
            new Container(
              color: Colors.lightBlue,
              child: new Scrollbar(
                  child: new ListView(
                    // padding: new EdgeInsets.symmetric(vertical: 4.0),
                    children: listContainer.toList(),
                  )
              ),
            ),
            new Container(
              color: Colors.lightBlue,
              child: new Scrollbar(
                  child: new ListView(
                    // padding: new EdgeInsets.symmetric(vertical: 4.0),
                    children: listContainer.toList(),
                  )
              ),
            ),
          ],
        ),
        //floatingActionButton: new ConfirmBox(),
      ),
    );
  }
}


