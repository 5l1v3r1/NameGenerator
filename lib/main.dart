// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';


void main() {
  runApp(const MyApp());
}

//The app extends StatelessWidget, which makes the app itself a widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // Material is a visual design language that is standard on mobile and the web.
    return MaterialApp(
      title: 'Startup Name Generator',
      //The Scaffold widget, provides a default app bar, and a body property that holds the widget tree for the home screen.
      // home: Scaffold(
      //   appBar: AppBar(
      //     title: const Text('Startup Name Generator'),
      //   ),
      //   body:  const Center(
      //     child: RandomWords(),
      //   ),
      // ),
      //  Change the UI using themes
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.blue,
      ),
      //Navigate to a new Page
      ),
      home: const RandomWords(),
    );
  }
}

// Add a Stateful widget, maintains state that might change during the lifetime of the widget.
class RandomWords  extends StatefulWidget {
  const RandomWords ({Key? key}) : super(key: key);

  @override
  //By default, the name of the State class is prefixed with an underbar.
  State<RandomWords > createState() => _RandomWordsState();

}

class _RandomWordsState extends State<RandomWords > {
  //Add a _suggestions list to the _RandomWordsState class for saving suggested word pairings.
  // Also, add a _biggerFont variable for making the font size larger.
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  @override
  Widget build(BuildContext context) {
    return Scaffold(   // NEW from here ...
        appBar: AppBar(
          title: const Text('Startup Name Generator'),
          actions: [
            // Menu Icon up in the left
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: _pushSaved,
              tooltip: 'Saved Suggestions',
            ),
          ],
        ),
        // ListView widget, changed from return to navigate
    body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
    //he itemBuilder callback is called once per suggested word pairing, and places each suggestion into a ListTile row.
    itemBuilder: /*1*/ (context, i) {
    if (i.isOdd) return const Divider(); /*2*/

    final index = i ~/ 2; /*3*/
    if (index >= _suggestions.length) {
    _suggestions.addAll(generateWordPairs().take(10)); /*4*/
    }
    //heck to ensure that a word pairing has not already been added to favorites
    final alreadySaved = _saved.contains(_suggestions[index]);
    //A ListTile is a fixed height row that contains text as well as leading or trailing icons or other widgets.
    return ListTile(
      title: Text(
        _suggestions[index].asPascalCase,
        style: _biggerFont,
      ),
      //Icon heart, (audiotrack, umbrella ->https://api.flutter.dev/flutter/widgets/Icon-class.html)
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
        semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
      ),
      // Make hearts interactive
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove((_suggestions[index]));
          }
          else {
            _saved.add(_suggestions[index]);
          }
        });
      }
    );
    },
    ),
    );
  }
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
                (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              //divideTiles() adds horizontal spacing between each ListTile
              ? ListTile.divideTiles(
            context: context,
            tiles: tiles,
          //  The divided variable holds the final rows converted to a list by the convenience function, toList()
          ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}
