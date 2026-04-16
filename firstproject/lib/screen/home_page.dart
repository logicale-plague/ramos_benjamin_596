import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? title;
  int counter = 0;
  TextEditingController number1 = TextEditingController();
  TextEditingController number2 = TextEditingController();

  double sum = 0;
  double difference = 0;
  double product = 0;
  String quotient = '0';

  @override
  void initState() {
    number1.text = '0';
    number2.text = '0';
    title = 'Home Page';
    super.initState();
  }

  @override
  void dispose() {
    number1.dispose();
    number2.dispose();
    super.dispose();
  }

  void incrementor() {
    setState(() {
      title = 'Linked List';
      counter += 1;
    });
  }

  void decrementor() {
    setState(() {
      title = 'Home Page';
      counter -= 1;
    });
  }

  void handleCalculate() {
    setState(() {
      sum = double.parse(number1.text) + double.parse(number2.text);
      difference = double.parse(number1.text) - double.parse(number2.text);
      product = double.parse(number1.text) * double.parse(number2.text);
      quotient = (double.parse(number2.text) == 0.0)
          ? 'Undefined'
          : (double.parse(number1.text) / double.parse(number2.text))
                .toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Center(
            child: Text(
              title!,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(child: Text('$counter')),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlinedButton(onPressed: decrementor, child: Text('Decrement')),
              OutlinedButton(onPressed: incrementor, child: Text('Increment')),
            ],
          ),
          SizedBox(width: 150, child: TextField(controller: number1)),
          SizedBox(width: 150, child: TextField(controller: number2)),
          const SizedBox(height: 15),
          OutlinedButton(onPressed: handleCalculate, child: Text('Calculate')),
          Text('Sum: $sum'),
          Text('Difference: $difference'),
          Text('Product: $product'),
          Text('Quotient: $quotient'),
        ],
      ),
    );
  }
}
