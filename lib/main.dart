import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:serializable_annotation_demo/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'First name',
                  ),
                  controller: firstNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter first name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Last name',
                  ),
                  controller: lastNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final scaffoldMessengerContext =
                        ScaffoldMessenger.of(context);

                    if (_formKey.currentState!.validate()) {
                      Person object = Person(
                        firstName: firstNameController.value.text,
                        lastName: lastNameController.value.text,
                      );

                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString(
                          'PersonData', jsonEncode(object).toString());

                      scaffoldMessengerContext.showSnackBar(
                        const SnackBar(content: Text('Data saved.')),
                      );
                    }
                  },
                  child: const Text('Save data to Shared Preference'),
                ),
                const SizedBox(
                  height: 100,
                ),
                GestureDetector(
                    onTap: () async {
                      final scaffoldMessengerContext =
                          ScaffoldMessenger.of(context);

                      final prefs = await SharedPreferences.getInstance();
                      String? string = prefs.getString('PersonData');
                      SnackBar snackBar;
                      if (string != null || string?.isNotEmpty == true) {
                        Map<String, dynamic> userMap = jsonDecode(string ?? '');
                        Person object = Person.fromJson(userMap);

                        snackBar = SnackBar(
                          content: Text(
                              'First name: ${object.firstName}   &   Last name: ${object.lastName}'),
                        );
                      } else {
                        snackBar = const SnackBar(
                          content: Text('No First name & Last name found.'),
                        );
                      }
                      scaffoldMessengerContext.showSnackBar(snackBar);
                    },
                    child: const Text(
                      'Fetch data from Shared Preference',
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
