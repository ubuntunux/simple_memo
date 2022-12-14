import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
  int _selectedIndex = 0;
  int _counter = 0;
  final List<Tab> _tabs = List<Tab>.empty(growable: true);
  final List<Widget> _tabViews = List<Widget>.empty(growable: true);
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

  void addTab() {
    setState(() {
      _tabs.add(Tab(
        text: "Tab $_counter",
      ));

      _tabViews.add(
          Container(
            color: const Color(0xFF111111),
            alignment: Alignment.center,
            child: Text(
              'TabView $_counter',
              style: const TextStyle(
                fontSize: 30,
              ),
            ),
          )
      );

      _tabController?.dispose();
      _tabController = TabController(
        length: _tabs.length,
        initialIndex: _counter,
        vsync: this,
      );

      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
                '이걸 클릭하시오.',
                textAlign: TextAlign.left
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: TabBar(
                splashBorderRadius: BorderRadius.circular(50),
                isScrollable: true,
                tabs: _tabs,
                indicatorWeight: 10,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: const BoxDecoration(
                  color: Colors.grey,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                controller: _tabController,
                onTap: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });

                  if (kDebugMode) {
                    print('Tab $index is tapped');
                  }
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
        onPressed: addTab,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
