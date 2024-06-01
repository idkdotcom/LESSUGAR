import 'package:flutter/material.dart';
import 'package:lessugar/add_food.dart';
import 'package:lessugar/models/food.dart';

void main() {
  runApp(
    const MaterialApp(
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Food> consumed = [];
  double totalSugar = 0;
  void addFood(Food newFood) {
    setState(() {
      consumed.add(newFood);
      totalSugar += newFood.sugarContent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 67, 59, 8),
      appBar: AppBar(
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(186, 31, 72, 32),
                border: Border.all(color: Colors.black),
              ),
              height: 420,
              width: 310,
              child: ListView.separated(
                itemCount: consumed.length,
                itemBuilder: (context, int index) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    height: 50,
                    color: const Color.fromARGB(182, 127, 196, 252),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            "Product : ${consumed[index].foodName}",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 25),
                        Expanded(
                          child: Text(
                            "Sugar : ${consumed[index].sugarContent}",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              totalSugar -= consumed[index].sugarContent;
                              consumed.removeAt(index);
                            });
                          },
                          icon: const Icon(Icons.remove),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, int index) => const Divider(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                "Total Sugar Consumed Today : $totalSugar",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddFood(
                                addFood: addFood,
                                consumed: consumed,
                              )),
                    );
                  },
                  child: const Text("Add Food")),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    consumed = [];
                    totalSugar = 0;
                  });
                },
                child: const Text("Empty List"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
