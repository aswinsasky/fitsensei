import 'package:flutter/material.dart';

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({super.key});
  @override
  State<NewUserScreen> createState() {
    return _NewuserScreenState();
  }
}

class _NewuserScreenState extends State<NewUserScreen> {
  DateTime? _selectedDate;
  String? _exerciseRegularly;
  String? _kneePain;
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitsensei'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.all(16.0)),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      value.length < 3) {
                    return 'Please enter a valid username';
                  }
                  return null;
                },
              ),
              const Padding(padding: EdgeInsets.all(10.0)),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const Padding(padding: EdgeInsets.all(10.0)),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const Padding(padding: EdgeInsets.all(10.0)),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Height in cm',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const Padding(padding: EdgeInsets.all(10.0)),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Weight in kg',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const Padding(padding: EdgeInsets.all(10.0)),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: _selectedDate == null
                            ? 'No Date Chosen!'
                            : 'Picked Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _presentDatePicker,
                    child: const Text(
                      'Choose Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.all(10.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Expanded(
                      child: Text(
                    'Do you exercise regularly?',
                    style: TextStyle(fontSize: 15),
                  )),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Yes'),
                      value: 'Yes',
                      groupValue: _exerciseRegularly,
                      onChanged: (value) {
                        setState(() {
                          _exerciseRegularly = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text(
                        'No',
                      ),
                      value: 'No',
                      groupValue: _exerciseRegularly,
                      onChanged: (value) {
                        setState(() {
                          _exerciseRegularly = value;
                        });
                      },
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Expanded(
                      child: Text(
                    'Do you have Knee Pain?',
                    style: TextStyle(fontSize: 15),
                  )),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Yes'),
                      value: 'Yes',
                      groupValue: _kneePain,
                      onChanged: (value) {
                        setState(() {
                          _kneePain = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text(
                        'No',
                      ),
                      value: 'No',
                      groupValue: _kneePain,
                      onChanged: (value) {
                        setState(() {
                          _kneePain = value;
                        });
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
