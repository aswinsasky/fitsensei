import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  var enteredEmail = '';
  final _passwordController = TextEditingController();
  var enteredPassword = '';
  var _isLogin = true;
  var _isPressed = false;
  final _formkey = GlobalKey<FormState>();
  void _submit() async {
    final _isValid = _formkey.currentState!.validate();
    if (!_isValid) {
      return;
    }
    _formkey.currentState!.save();
    try {
      if (_isLogin) {
        final userCredential = await _firebase.signInWithEmailAndPassword(
            email: enteredEmail, password: enteredPassword);
        print(userCredential);
      } else {
        final userCredential = await _firebase.createUserWithEmailAndPassword(
            email: enteredEmail, password: enteredPassword);
        print(userCredential);
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {}
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authentication Failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 7, 7),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/images/Appicon.png'),
              ),
              const Text(
                'FIT SENSAI',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800),
              ),
              Card(
                elevation: 20,
                shadowColor: Colors.white,
                margin: const EdgeInsets.all(30),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Email Address'),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@') || !checkDotFollowsAt(value)) {
                                return 'Please enter a valid Email Address ';
                              }
                              
                              return null;
                            },
                            onSaved: (value) {
                              enteredEmail = value!;
                            },
                          ),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isPressed = !_isPressed;
                                    });
                                  },
                                  icon: Icon(_isPressed
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined),
                                )),
                            obscureText: _isPressed ? false : true,
                            validator: (value) {
                              if (value == null || value.trim().length <= 6 ) {
                                return 'Password must have more than 6 characters';
                              }
                              if( !containsSpecialCharacters(value)){
                                return 'Password must have atleast a special character';
                              }
                              if( !containsNumbers(value)){
                                return 'Password must have atleast a number';
                              }
                              if( !containsUppercase(value)){
                                return 'Password must have atleast an upper case';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              enteredPassword = value!;
                            },
                          ),
                          !_isLogin
                              ? TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'confirm password'),
                                  obscureText: true,
                                  validator: (value) {
                                    if (value != _passwordController.text) {
                                      return 'Password should match';
                                    }
                                    return null;
                                  },
                                )
                              : Container(),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: _submit,
                                child: Text(_isLogin ? 'Login' : 'Signup'),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(_isLogin
                                    ? 'Create an Account'
                                    : 'Already a user?'),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
