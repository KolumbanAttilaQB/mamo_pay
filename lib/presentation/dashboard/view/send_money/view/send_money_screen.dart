import 'package:flutter/material.dart';
import 'package:mamopay_clone/utils/spacing/spacing.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  _SendMoneyScreenState createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  double balance = 3719.00;
  String amount = '';
  bool isNextEnabled = false;

  List<String> categories = ['Family', 'School', 'Food', 'Transport'];
  String selectedCategory = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        title: const Text('Enter amount'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Mamo Pay balance',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
            MySpacing.spacingSH,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'AED $balance',
                    style: const TextStyle(
                        fontSize: 36, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
            MySpacing.spacingFH,
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  suffixText: 'AED',
                  hintText: '0',
                  labelStyle: TextStyle(fontSize: 24, color: Colors.grey),
                  suffixStyle: TextStyle(fontSize: 24, color: Colors.grey)),
              readOnly: false,
              controller: TextEditingController(text: amount),
            ),
            MySpacing.spacingFH,
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: categories
                    .map((category) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ElevatedButton(
                              onPressed: () {}, child: Text(category)),
                        ))
                    .toList(),
              ),
            ),
            MySpacing.spacingFH,
          ],
        ),
      ),
    );
  }
}
