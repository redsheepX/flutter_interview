import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '講師清單',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AppBarExample(),
    );
  }
}

class AppBarExample extends StatefulWidget {
  const AppBarExample({super.key});

  @override
  State<AppBarExample> createState() => _AppBarExampleState();
}

class _AppBarExampleState extends State<AppBarExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildListView(),
    );
  }

  ListView _buildListView() {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: title.length,
        itemBuilder: (BuildContext context, int index) {
          return _generateCard(title[index], name[index]);
        });
  }

  bool _customTileExpanded = false;

  Card _generateCard(String title, String name) {
    return Card(
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ExpansionTile(
            trailing: Icon(
              _customTileExpanded ? Icons.minimize : Icons.add,
            ),
            title: _buildCardInfo(title, name),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _customTileExpanded = expanded;
              });
            },
            children: [
              SizedBox(
                  width: 300,
                  height: schedule[name]!.length * 50,
                  child: _buildSchedule(name))
            ],
          ),
        ));
  }

  Widget _buildCardInfo(String title, String name) {
    return Row(children: [
      ClipOval(
        child: SizedBox.fromSize(
          size: const Size.fromRadius(24), // Image radius
          child: Image.network(
              'https://i.natgeofe.com/n/548467d8-c5f1-4551-9f58-6817a8d2c45e/NationalGeographic_2572187_square.jpg',
              fit: BoxFit.cover),
        ),
      ),
      const SizedBox(
        width: 20,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(title), Text(name)],
      ),
      const Spacer(),
    ]);
  }

  ListView _buildSchedule(String name) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: schedule[name]?.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
              onTap: () {},
              child: Row(
                children: [
                  const Icon(Icons.calendar_month),
                  Column(children: [
                    Text(schedule[name]?[index]["title"]),
                    Text(
                        '${schedule[name]?[index]["interval"]},${schedule[name]?[index]["time"]}'),
                  ]),
                  const Spacer(),
                  const Icon(Icons.arrow_forward)
                ],
              ));
        });
  }
}

AppBar _buildAppBar() {
  return AppBar(
    leading: const Icon(Icons.arrow_back),
    title: const Text("講師清單"),
  );
}

// 模擬資料
final List<String> title = <String>[
  'Demonstrator',
  'Lecturer',
  'Senior Lecturer',
  'Professor',
  'Professor'
];
final List<String> name = <String>['A', 'B', 'C', 'D', 'E'];
final Map<String, List<Map>> schedule = {
  "A": [
    {"title": "吃飯A", "interval": "每週一", "time": "11:00-17:00"},
    {"title": "吃飯2", "interval": "每週一", "time": "11:00-17:00"}
  ],
  "B": [
    {"title": "吃飯A", "interval": "每週一", "time": "11:00-17:00"},
    {"title": "吃飯2", "interval": "每週一", "time": "11:00-17:00"}
  ],
  "C": [
    {"title": "吃飯A", "interval": "每週一", "time": "11:00-17:00"},
    {"title": "吃飯2", "interval": "每週一", "time": "11:00-17:00"}
  ],
  "D": [
    {"title": "吃飯A", "interval": "每週一", "time": "11:00-17:00"},
    {"title": "吃飯2", "interval": "每週一", "time": "11:00-17:00"}
  ],
  "E": [
    {"title": "吃飯A", "interval": "每週一", "time": "11:00-17:00"},
    {"title": "吃飯2", "interval": "每週一", "time": "11:00-17:00"}
  ],
};
// 模擬資料
