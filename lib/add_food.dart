import 'package:flutter/material.dart';
import 'package:lessugar/models/food.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddFood extends StatefulWidget {
  const AddFood({super.key, required this.addFood, required this.consumed});
  final List<Food> consumed;
  final void Function(Food) addFood;

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  final TextEditingController _controller = TextEditingController();

  Future<double> fetchSugarContent(String query) async {
    const String apiKey = 'f7785ab2725e2f7740d5b6d2c642f154';
    const String appId = '17e3d5c8';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'x-app-id': appId,
      'x-app-key': apiKey,
    };

    Map<String, dynamic> body = {"query": query};
    var url =
        Uri.parse('https://trackapi.nutritionix.com/v2/natural/nutrients');

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Extract sugar content from the response
      if (data['foods'] != null && data['foods'].isNotEmpty) {
        final product = data['foods'][0];
        final sugarContent = product['nf_sugars'];
        if (sugarContent == 0.0 || sugarContent == null) {
          return 0.0;
        }
        return sugarContent.toDouble();
      } else {
        // DISINI TOLONG BUAT POP UP "FOOD NOT FOUND"
        return -1;
      }
    } else {
      return -1;
    }
  }

  Future<bool> checkFood(BuildContext context) async {
    double sugarContent = await fetchSugarContent(_controller.text);
    if (sugarContent == -1) {
      return false;
    } else {
      Food newFood =
          Food(foodName: _controller.text, sugarContent: sugarContent);
      widget.addFood(newFood);
      return true;
    }
  }

  Future<void> _showErrorDialog(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            width: 500,
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: 'Input Food Name Here'),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 50,
            width: 150,
            child: ElevatedButton(
                onPressed: () async {
                  bool isFoodValid = await checkFood(context);
                  if (isFoodValid == true) {
                    Navigator.pop(context);
                  } else {
                    _showErrorDialog(
                        context, "Sorry, product mentioned is not in the data");
                  }
                },
                child: const Text("Input Food")),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 50,
            width: 150,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Back to Home")),
          ),
        ],
      )),
    );
  }
}
