import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'confirm.dart';
import 'StaticTabBar.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Animation Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new showPage(title:'show'),
      routes: <String, WidgetBuilder>{
        'showPage':(BuildContext context) => new showPage(title:'show'),
        'statsPage':(BuildContext context) => new statsPage(),
        'tabPage':(BuildContext context) => new MyHomePage(title: 'animation'),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _ListItem {
  _ListItem(this.value, this.checkState);

  final String value;

  double height = 100.0;
  bool checkState;
}

class listItem {
  listItem({
    this.title,
    this.url,
    this.content,
    this.images,
  });

  final String title;
  final String url;
  final String content;
  final List<String> images;
  double height = 100.0;

  bool showDetail = false;
  double normalHeight = 140.0;
  double detailHeight = 280.0;
}

class ListModel<E> {
  ListModel({
    @required this.listKey,
    @required this.removedItemBuilder,
    Iterable<E> initialItems,
  }) : assert(listKey != null),
        assert(removedItemBuilder != null),
        _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<AnimatedListState> listKey;
  final dynamic removedItemBuilder;
  final List<E> _items;

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList.insertItem(index);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(index, (BuildContext context, Animation<double> animation) {
        return removedItemBuilder(removedItem, context, animation);
      });
    }
    return removedItem;
  }

  int get length => _items.length;
  E operator [](int index) => _items[index];
  int indexOf(E item) => _items.indexOf(item);
}

Widget buildNormalItem(listItem item, bool choose,VoidCallback onTapCallback) {
  return new GestureDetector(
    onTap:onTapCallback,
      child:
      new Opacity(
        opacity: choose == true ? 0.5 : 1.0,
        child: new Stack(
          children: <Widget>[
            new AnimatedContainer(
              //curve: Curves.bounceOut,
              curve: Curves.ease,
              //duration: new Duration(seconds: 1),
              duration: new Duration(milliseconds: 500),
              height: item.showDetail == false ? item.normalHeight : item
                  .detailHeight,
              width: 320.0,
              alignment: Alignment.topRight,
              margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    offset: Offset(0.0, 3.0),
                    blurRadius: 2.0,
                    spreadRadius: -1.0,
                    color: Color(0x33000000),
                  ),
                ],
              ),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    height: 20.0,
                    width: 180.0,
                    margin: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 0.0),

                    child: new Text(
                        item.title, style: new TextStyle(fontSize: 15.0)),
                  ),
                  new Container(
                    height: item.showDetail == false
                        ? item.normalHeight / 2
                        : item.detailHeight / 2,
                    width: 180.0,
                    child: new Text(
                        item.content, style: new TextStyle(fontSize: 13.0)),
                  ),
                ],
              ),
            ),
            new AnimatedContainer(
              curve: Curves.ease,
              height: item.showDetail == false ? item.normalHeight - 20 : item
                  .detailHeight - 20,
              width: item.showDetail == false
                  ? item.normalHeight - 20
                  : 360.0,
              margin: EdgeInsets.fromLTRB(
                  item.showDetail == true ? 0.0 : 10.0, 30.0, 0.0, 0.0),
              duration: new Duration(milliseconds: 500),
              child:  new Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: Colors.white),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      offset: Offset(0.0, 3.0),
                      blurRadius: 2.0,
                      spreadRadius: -1.0,
                      color: Color(0x33000000),
                    ),
                  ],
                ),
                child: new Image.asset(item.url),
              ),
            ),
            new AnimatedContainer(
              curve: Curves.ease,
              duration: new Duration(milliseconds: 500),
              margin: new EdgeInsets.fromLTRB(260.0,
                  item.showDetail == false ? item.normalHeight - 50.0 : item
                      .detailHeight - 50.0, 0.0, 0.0),
              child: item.showDetail == false ? new Opacity(opacity: 0.0) : new GestureDetector(
                  child: new Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      //borderRadius: BorderRadius.circular(5.0),
                      shape: BoxShape.circle,
                    ),
                  )
              ),
            ),
          ],
        ),)

  );
}

class CardItem extends StatelessWidget {
  const CardItem({
    Key key,
    @required this.animation,
    this.onTap,
    @required this.item,
    this.selected = false
  })
      : assert(animation != null),
        assert(item != null),
        assert(selected != null),
        super(key: key);

  final Animation<double> animation;
  final VoidCallback onTap;
  final listItem item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: buildNormalItem(item, selected, onTap)
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

  bool show = true;

  void startDrag() {
    setState(() {
      //show = false;
    });
  }

  void startConfirm(TapUpDetails details) {
    print("touch start?");
//    start = (context.findRenderObject() as RenderBox)
//        .globalToLocal(details.globalPosition);

    setState(() {
      start = details.globalPosition;
      show = false;
      controller = AnimationController(vsync: this, duration: Duration(milliseconds: 2000));
      final CurvedAnimation curve = new CurvedAnimation(parent: controller, curve: Curves.linear);
      animation = new Tween(begin: 0.0, end: 2.0).animate(curve)
        ..addListener(() {
          setState(() {
            // the state that has changed here is the animation object’s value
          });
        })
        ..addStatusListener((status) {
          if (status == AnimationStatus.forward) {
            print("动画开始");
          } else if (status == AnimationStatus.completed) {
            print("动画结束");
            show = true;
            controller.stop();
          }
          else if (status == AnimationStatus.dismissed) {
            print("动画消失");
            //   show = true;
            // controller.forward();
          }
        });
      controller.forward(from: 0.0);
    });
  }

  ScrollController _scrollController = new ScrollController();

  Animation<double> animation;
  AnimationController controller;
  Offset start;

  @override
  void initState() {
    _scrollController.addListener(() {
      print("scroll?");
    });
//    for (ScrollPosition position in List <ScrollPosition>.from(_scrollController.positions))
//      position.jumpTo(100.0);
    // _scrollController.jumpTo(10.0);
    //  _scrollController.jumpTo(100.0);
    super.initState();

    _list = ListModel<listItem>(
      listKey: _listKey,
      initialItems: innerItems,
      removedItemBuilder: _buildRemovedItem,
    );
    _nextItem = new listItem(
      title: 'Modern Day',
      url: 'images/4.png',
      images: [
        'images/4.png',
        'images/4.png',
        'images/4.png',
        'images/4.png',
        'images/4.png'
      ],
      content: 'Many people around the world take me',
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildInnerList(String item) {
    return new Container(
      decoration: new BoxDecoration(
        border: Border.all(color: Colors.white),
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            offset: Offset(0.0, 3.0),
            blurRadius: 2.0,
            spreadRadius: -1.0,
            color: Color(0x33000000),
          ),
        ],
      ),
      child: new Image.asset(item),
    );
  }

  Widget buildList(listItem item) {
    const Widget secondary = Text(
      'Even more additional list item information appears on line three.',
    );
    Widget list;
    list = Container(
      key: Key(item.title),
      //height: 100.0,
      //`\\width: 100.0,
      child: buildItem(item),
    );

    return list;
  }

  void itemTapCallback(){

  }

  Widget buildItemaa(listItem item) {
    return new GestureDetector(
        onTap: () {
          setState(() {
            item.showDetail = !item.showDetail;
          });
          print("tap???????");
        },
        child:
        new Stack(
            children: <Widget>[
              new AnimatedContainer(
                //curve: Curves.bounceOut,
                curve: Curves.ease,
                //duration: new Duration(seconds: 1),
                duration: new Duration(milliseconds: 500),
                height: item.showDetail == false ? 140.0:280.0,
                width: 320.0,
//                margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                color: Colors.red,
              )
            ]));
  }

  Widget buildItem(listItem item) {
    return new GestureDetector(
        onTap: () {
          setState(() {
            item.showDetail = !item.showDetail;
          });
          print("tap???????");
        },
        child:
        new Stack(
          children: <Widget>[
            new AnimatedContainer(
              //curve: Curves.bounceOut,
              curve: Curves.ease,
              //duration: new Duration(seconds: 1),
              duration: new Duration(milliseconds: 500),
              height: item.showDetail == false ? item.normalHeight : item
                  .detailHeight,
              width: 320.0,
              alignment: Alignment.topRight,
              margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    offset: Offset(0.0, 3.0),
                    blurRadius: 2.0,
                    spreadRadius: -1.0,
                    color: Color(0x33000000),
                  ),
                ],
              ),
              child: new Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    height: 20.0,
                    width: 180.0,
                    margin: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 0.0),
//                      decoration: new BoxDecoration(
//                        color: Colors.lightBlue,
//                        borderRadius: BorderRadius.circular(5.0),
//                      ),
                    child: new Text(
                        item.title, style: new TextStyle(fontSize: 15.0)),
                  ),
                  new Container(
                    height: item.showDetail == false
                        ? item.normalHeight / 2
                        : item.detailHeight / 2,
                    width: 180.0,
//                      margin: EdgeInsets.fromLTRB(0.0, 5.0, 60.0, 0.0),
//                      decoration: new BoxDecoration(
//                        color: Colors.lightBlue,
//                        borderRadius: BorderRadius.circular(5.0),
//                      ),
                    child: new Text(
                        item.content, style: new TextStyle(fontSize: 13.0)),
                  ),

//                  new RaisedButton(
//                    child: new Text('GO'),
//                    onPressed: startDrag,
//                  ),
                ],
              ),
            ),
            new AnimatedContainer(
              curve: Curves.ease,
              height: item.showDetail == false ? item.normalHeight - 20 : item
                  .detailHeight - 20,
              width: item.showDetail == false
                  ? item.normalHeight - 20
                  : 360.0,
              margin: EdgeInsets.fromLTRB(
                  item.showDetail == true ? 0.0 : 10.0, 30.0, 0.0, 0.0),
              duration: new Duration(milliseconds: 500),
              child: item.showDetail == true ? new ListView(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 280.0, 0.0),
                // padding: new EdgeInsets.symmetric(vertical: 4.0),
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                children: item.images.map<Widget>(buildInnerList).toList(),
              ) : new Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: Colors.white),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      offset: Offset(0.0, 3.0),
                      blurRadius: 2.0,
                      spreadRadius: -1.0,
                      color: Color(0x33000000),
                    ),
                  ],
                ),
                child: new Image.asset(item.url),
              ),
            ),
            new AnimatedContainer(
              curve: Curves.ease,
              duration: new Duration(milliseconds: 500),
              margin: new EdgeInsets.fromLTRB(260.0,
                  item.showDetail == false ? item.normalHeight - 50.0 : item
                      .detailHeight - 50.0, 0.0, 0.0),
              child: item.showDetail == false ? new Opacity(opacity: 0.0) : new GestureDetector(
                  onTapUp: (TapUpDetails details) {
                    setState(() {
                      item.showDetail = !item.showDetail;
                    });
                    startConfirm(details);
                  },
                  child: new Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      //borderRadius: BorderRadius.circular(5.0),
                      shape: BoxShape.circle,
                    ),
                  )
              ),
            ),

          ],
        )

    );
  }

  TabController _tabController;

  final List<_ListItem> _items = <String>[
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N',
  ].map<_ListItem>((String item) => _ListItem(item, false)).toList();

  final List<listItem> innerItems = <listItem>[
    new listItem(
      title: 'The Old Man and The Sea',
      url: 'images/1.png',
      images: [
        'images/1.png',
        'images/1.png',
        'images/1.png',
        'images/1.png',
        'images/1.png'
      ],
      content: 'He was an old man who fished alone in a shiff in the GulfStream',
    ),
    new listItem(
      title: 'The Godfather',
      url: 'images/2.png',
      images: [
        'images/2.png',
        'images/2.png',
        'images/2.png',
        'images/2.png',
        'images/2.png'
      ],
      content: 'Never tell anybody outside the family what you are thinking again',
    ),
    new listItem(
      title: 'Walden',
      url: 'images/3.png',
      images: [
        'images/3.png',
        'images/3.png',
        'images/3.png',
        'images/3.png',
        'images/3.png'
      ],
      content: 'Most men, even in this comparatively free country, through,',
    ),
    new listItem(
      title: 'Modern Day',
      url: 'images/4.png',
      images: [
        'images/4.png',
        'images/4.png',
        'images/4.png',
        'images/4.png',
        'images/4.png'
      ],
      content: 'Many people around the world take me',
    ),
    new listItem(
      title: 'The Old Man and The Sea',
      url: 'images/1.png',
      images: [
        'images/1.png',
        'images/1.png',
        'images/1.png',
        'images/1.png',
        'images/1.png'
      ],
      content: 'He was an old man who fished alone in a shiff in the GulfStream',
    ),
    new listItem(
      title: 'The Godfather',
      url: 'images/2.png',
      images: [
        'images/2.png',
        'images/2.png',
        'images/2.png',
        'images/2.png',
        'images/2.png'
      ],
      content: 'Never tell anybody outside the family what you are thinking again',
    ),
    new listItem(
      title: 'Walden',
      url: 'images/3.png',
      images: [
        'images/3.png',
        'images/3.png',
        'images/3.png',
        'images/3.png',
        'images/3.png'
      ],
      content: 'Most men, even in this comparatively free country, through,',
    ),
    new listItem(
      title: 'Modern Day',
      url: 'images/4.png',
      images: [
        'images/4.png',
        'images/4.png',
        'images/4.png',
        'images/4.png',
        'images/4.png'
      ],
      content: 'Many people around the world take me',
    ),
  ];

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final _ListItem item = _items.removeAt(oldIndex);
      _items.insert(newIndex, item);
    });
  }

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<Null> _handleRefresh() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    print("refresh");
    return null;
  }

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ListModel<listItem> _list;
  listItem _selectedItem;
  listItem _nextItem;

  Widget _buildItem(BuildContext context, int index,
      Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: _list[index],
      selected: _selectedItem == _list[index],
      onTap: () {
        setState(() {
          _selectedItem = _selectedItem == _list[index] ? null : _list[index];
        });
      },
    );
  }

  Widget _buildRemovedItem(listItem item, BuildContext context,
      Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: item,
      selected: false,
      // No gesture detector here: we don't want removed items to be interactive.
    );
  }

  // Insert the "next item" into the list model.
  void _insert() {
    final int index = _selectedItem == null ? _list.length : _list.indexOf(
        _selectedItem);
    _list.insert(index, _nextItem);
  }

  // Remove the selected item from the list model.
  void _remove() {
    if (_selectedItem != null) {
      _list.removeAt(_list.indexOf(_selectedItem));
      setState(() {
        _selectedItem = null;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 3,
      child: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white,
          title: new Text('animation'),
          elevation: 1.0,
          actions: _selectedItem == null? <Widget>[
            IconButton(
              color:Colors.red,
              icon: const Icon(Icons.add_circle),
              onPressed: (){Navigator.of(context).pushNamed('showPage');},
            ),
          ] :<Widget>[
            IconButton(
              color:Color(0xFFEB841C),
              icon: const Icon(Icons.add_circle),
              onPressed: _insert,
              tooltip: 'insert a new item',
            ),
            IconButton(
              color: Color(0xFFEB841C),
              icon: const Icon(Icons.remove_circle),
              onPressed: _remove,
              tooltip: 'remove the selected item',
            ),
          ],
//          bottom: new TabBar(
//            tabs: <Widget>[
//              new Tab(text: "Title"),
//              new Tab(text: "Title"),
//              new Tab(text: "Title"),
//            ],
//            controller: _tabController,
//            // indicatorColor: Colors.red,
//            // indicatorWeight: 15.0,
//            labelColor: Color(0xFFEB841C),
//            labelStyle: new TextStyle(fontSize: 18.0),
//            unselectedLabelColor: Color(0xFF999999),
//            unselectedLabelStyle: new TextStyle(fontSize: 16.0),
//            //  indicatorPadding: new EdgeInsets.only(bottom: 20.0),
////            indicator: new BoxDecoration(
////              color: Colors.white24,
////              borderRadius: BorderRadius.circular(5.0),
////            ),
//          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: Theme(
              data: Theme.of(context).copyWith(accentColor: Colors.white),
              child: Container(
                height: 48.0,
                alignment: Alignment.center,
                child: StaticTabBarSelector(controller: _tabController,
                    color: Color(0xFFCCCCCC),
                    selectedColor: Color(0xFF999999)),
              ),
            ),
          ),
        ),
        body: new TabBarView(
          children: <Widget>[

            new RefreshIndicator(
              child: new Container(
                color: Color(0xFFCCCCCC),
                child: new ListView(
                  children: innerItems.map<Widget>(buildList).toList(),
                ),
              ),
              onRefresh: _handleRefresh,
            ),

            new Container(
              color: Color(0xFFCCCCCC),
              child: AnimatedList(
                key: _listKey,
                initialItemCount: _list.length,
                itemBuilder: _buildItem,
              ),
            ),

//            new Container(
//              color: Color(0xFFCCCCCC),
//              child: new Column(
//                children: <Widget>[
//                  new Row(
//                    children: <Widget>[
//                      IconButton(
//                        icon: const Icon(Icons.add_circle),
//                        onPressed: _insert,
//                        tooltip: 'insert a new item',
//                      ),
//                      IconButton(
//                        icon: const Icon(Icons.remove_circle),
//                        onPressed: _remove,
//                        tooltip: 'remove the selected item',
//                      ),
//                    ],
//                  ),
//
//                ],
//              ),
//            ),
            new Container(
              color: Color(0xFFCCCCCC),
              child: ReorderableListView(
//                header: Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Text('Header of the list', style: Theme.of(context).textTheme.headline)),
                onReorder: _onReorder,
                scrollDirection: Axis.vertical,
           //     padding: const EdgeInsets.symmetric(vertical: 8.0),
                children: innerItems.map<Widget>(buildList).toList(),
              ),
            ),
          ],
        ),
        floatingActionButton: show ? null : ConfirmBox(
            controller: controller,
            doubleAnimation: animation,
            start: start),
      ),
    );
  }
}

class showPage extends StatelessWidget {
  showPage({Key key, this.title}) : super(key:key);
  final String title;

  Widget build(BuildContext context){
    return new Scaffold(
        body: new GestureDetector(
          onTap: (){Navigator.of(context).pushNamed("statsPage");},
          child:new Center(
            child:  new Text('HUAWEI',
              style: new TextStyle(
                  color: Colors.black,
                  fontSize: 60.0
              ),)
          )
        )
    );
  }
}

class statsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => statsPageState();
}

class statsPageState extends State<statsPage> with SingleTickerProviderStateMixin {

  Animation<double> increaseAnimation;
  AnimationController controller;

  @override
  void initState(){
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    increaseAnimation = new Tween(begin:0.0, end:142857.0).animate(controller)
    ..addListener(() {
      setState(() {
        print(increaseAnimation.value);
      });
    });
    controller.forward(from:0.0);
  }

  void incre() {
    setState((){
      controller.forward(from:0.0);
    });
  }


  Widget build(BuildContext context){
    return new Scaffold(
        appBar: new AppBar(title: new Text("stats")),
        body: new Column(
          children: <Widget>[
            new Container(
              height: 300.0,
              color: Colors.orange,
              child: new Container(
                width: 100.0,
                height: 100.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent
                ),
                child: new Center(
                  child: new Text(increaseAnimation.value.toInt().toString()),
                ),
              ),
            ),
            new Container(
              height: 100.0,
              color: Colors.green,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      new Text("1"),
                      new Text("2"),
                      new Text("3"),
                    ],
                  ),
                ],
              )
            ),
            new GestureDetector(
              onTap: (){Navigator.of(context).pushNamed("tabPage");},
              child: new Container(
                height:200.0,
                color: Colors.deepPurple
              ),
            ),

          ],
        )
    );
  }
}

