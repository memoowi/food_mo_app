import 'package:flutter/material.dart';
import 'package:food_mo/providers/order_provider.dart';
import 'package:provider/provider.dart';

class CodeFieldBox extends StatefulWidget {
  const CodeFieldBox({
    super.key,
  });

  @override
  State<CodeFieldBox> createState() => _CodeFieldBoxState();
}

class _CodeFieldBoxState extends State<CodeFieldBox> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController codeController = TextEditingController();
  // String? codeNotFound;

  String? codeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter restaurant code';
    } else if (value.length < 6) {
      return 'Code must be at least 6 characters';
    } else {
      return null;
    }
  }

  // void getCodeNotFound() {
  //   setState(() {
  //     Provider.of<OrderProvider>(context, listen: false).codeNotFound =
  //         codeNotFound;
  //   });
  // }

  void submitCode() {
    Provider.of<OrderProvider>(context, listen: false)
        .submitCode(context, codeController, formKey);
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Text(
              'Order food'.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: codeController,
                    validator: codeValidator,
                    onChanged: (String text) {
                      codeController.text = text.toUpperCase();
                    },
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter Restaurant Code',
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.white24,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          width: 0.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          width: 0.0,
                        ),
                      ),
                      prefixIcon: Icon(Icons.code),
                      prefixIconColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: submitCode,
                  child: Icon(Icons.send),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    surfaceTintColor: Colors.white,
                    elevation: 0.0,
                    minimumSize: Size(60, 60),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            Consumer(builder: (context, OrderProvider provider, _) {
              if (provider.codeNotFound != null) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red),
                      SizedBox(width: 10.0),
                      Text(
                        provider.codeNotFound!,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            })
          ],
        ),
      ),
    );
  }
}
