import 'dart:async';
import 'dart:convert';

import 'package:crypto/coinCard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<Coin>> fetchCoin() async {
    coinList = [];
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false'));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = json.decode(response.body);
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            coinList.add(Coin.fromJson(map));
          }
        }
        // print(coinList.first.name);
        // print(coinList.last.name);
        setState(() {
          coinList;
        });
      }
      return coinList;
    } else {
      throw Exception('Failed to load coin');
    }
  }

  @override
  void initState() {
    fetchCoin();
    Timer.periodic(Duration(seconds: 10), (timer) => fetchCoin());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          title: Text(
            'CRYPTO',
            style: TextStyle(
              fontSize: 26,
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: coinList.length,
            itemBuilder: (context, index) {
              return CoinCard(
                name: coinList[index].name,
                symbol: coinList[index].symbol,
                imageUrl: coinList[index].imageUrl,
                price: coinList[index].price.toDouble(),
                change: coinList[index].change.toDouble(),
                changePercentage: coinList[index].changePercentage.toDouble(),
              );
            }));
  }
}
