import 'package:flutter/material.dart';
import 'package:lottery/settings.dart';
import 'package:provider/provider.dart';

import 'lottery.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Lottery(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lottery',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
            brightness: Brightness.dark, primary: Colors.blue),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(appTitle)),
      body: Consumer<Lottery>(
        builder: (context, lottery, child) {
          return lottery.luckyNumbers.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Column(children: [
                  ...getColumn(lottery.luckyNumbers),
                  ElevatedButton(
                    onPressed: () => lottery.getLuckyNumbers(),
                    child: const Text(
                      'Shuffle',
                      style: TextStyle(fontSize: 47),
                    ),
                  )
                ]);
        },
      ),
    );
  }

  List<Widget> getColumn(List<List<int>> list) {
    return list.map((e) => getRow(e)).toList();
  }

  Widget getRow(List<int> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: numbers
          .map((e) => Text(
                e.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 47),
              ))
          .toList(),
    );
  }
}
