import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum ContextMenu {
  addCategory,
  renameCategory,
  removeCategory,
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Memo',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Simple Memo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _selectedCategoryIndex = 0;
  final List<Widget> _tabs = List<Widget>.empty(growable: true);
  final List<Widget> _tabViews = List<Widget>.empty(growable: true);
  final HashMap<int, List<Widget>> _memoMap = HashMap<int, List<Widget>>();
  TabController? _tabController;

  @override
  void initState() {
    _tabs.clear();
    _tabViews.clear();
    _tabController = TabController(length: 0, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void addMemoInCategory() {
    setState(() {
      //Container view = _tabViews[_selectedCategoryIndex] as Container;
      //ListView listView = view.child as ListView;
      _memoMap[_selectedCategoryIndex]?.add(createMemo(_selectedCategoryIndex));
    });
  }

  void addTab() {
    setState(() {
      int index = _tabs.length;

      _tabs.add(
          GestureDetector(
            child: Tab(text: "Tab $index"),
            onLongPress: () {
              if (kDebugMode) {
                print("onLongPress: $index");
              }
            },
          )
      );

      List<Widget> views = <Widget>[];

      _memoMap[index] = views;

      _tabViews.add(
          createTabView(views)
      );

      _tabController?.dispose();
      _tabController = TabController(
        length: _tabs.length,
        initialIndex: index,
        vsync: this,
      );
      _selectedCategoryIndex = index;
    });
  }

  void removeTab() {
    setState(() {
      if(1 < _tabs.length) {
        _tabs.removeAt(_selectedCategoryIndex);
        _tabViews.removeAt(_selectedCategoryIndex);

        if (0 < _selectedCategoryIndex) {
          _selectedCategoryIndex -= 1;
        }

        _tabController?.dispose();
        _tabController = TabController(
          length: _tabs.length,
          initialIndex: _selectedCategoryIndex,
          vsync: this,
        );
      }
    });
  }

  void selectContextMenu(ContextMenu menu) {
    if (ContextMenu.addCategory == menu) {
      addTab();
    } else if (ContextMenu.removeCategory == menu) {
      removeTab();
    }
  }

  Widget createMemo(int index) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          child: Text(
            "TabView $index",
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  elevation: 16,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      const Center(child: Text('Leaderboard')),
                      const SizedBox(height: 20),
                      buildRow('assets/choc.png', 'Name 1', 1000),
                      buildRow('assets/choc.png', 'Name 2', 2000),
                      buildRow('assets/choc.png', 'Name 3', 3000),
                      buildRow('assets/choc.png', 'Name 4', 4000),
                      buildRow('assets/choc.png', 'Name 5', 5000),
                      buildRow('assets/choc.png', 'Name 6', 6000),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget createTabView(List<Widget> views) {
    return Container(
      color: const Color(0xFF111111),
      alignment: Alignment.center,
      child: ListView(
        children: views,
      ),
    );
  }

  Widget buildRow(String imageAsset, String name, double score) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 12),
          Container(height: 2, color: Colors.redAccent),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              //CircleAvatar(backgroundImage: AssetImage(imageAsset)),
              const SizedBox(width: 12),
              Text(name),
              const Spacer(),
              Container(
                decoration: BoxDecoration(color: Colors.yellow[900], borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Text('$score'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (ContextMenu menu) { selectContextMenu(menu); },
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<ContextMenu>(
                  value: ContextMenu.addCategory,
                  child: Text("Add Category"),
                ),
                const PopupMenuItem<ContextMenu>(
                  value: ContextMenu.removeCategory,
                  child: Text("Remove Category"),
                ),
              ];
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: TabBar(
                isScrollable: true,
                tabs: _tabs,
                indicator: const BoxDecoration(
                  color: Color(0xFF555555),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                controller: _tabController,
                onTap: (int index) {
                  setState(() {
                    _selectedCategoryIndex = index;
                  }); // showDialog
                },
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _tabViews,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addMemoInCategory,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}