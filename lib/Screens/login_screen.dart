import 'package:bookdb/Screens/forgotPasswordPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:bookdb/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try{
      await Auth().createUserWithEmailAndPassword(email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e){
      setState(() {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Hatalı bir giriş yaptınız, lütfen daha önce kullanılmamış bir mail veya şifrenizi minimum 6 karakterden uzun giriniz."),
            );
          },
        );
        errorMessage = e.message;
      });
    }
  }

  bool _isPasswordVisible = false;
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BookDB'),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, snapshot) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                //Icon
                children: [
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: const Icon(
                      Icons.lock,
                      size: 100,
                      color: Colors.grey,
                    ),
                  ), //Kullanıcı adı - E mail
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _controllerEmail,
                      decoration: InputDecoration(
                        labelText: 'E-Mail',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ), //Kullanıcı adı - E mail
                  const SizedBox(height: 16),

                  //Parola Container
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _controllerPassword,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Parola',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(_isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  // Giriş yapma işlemleri
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      _isLogin ? signInWithEmailAndPassword() : createUserWithEmailAndPassword();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(16),
                    ),
                    child:  Text(
                      _isLogin ? 'Giriş Yap' : 'Kayıt Ol',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Şifremi Unuttum Butonu
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage(),));
                        },
                        child: const Text(
                          'Şifremi Unuttum',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                         setState(() {
                           _isLogin = _isLogin ? false : true;
                         });
                        },
                        child: Text(
                          _isLogin ? 'Kayıt Ol' : 'Giriş Yap',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),

                  //Google ile giriş yap butonu
                  const SizedBox(height: 12),
                  SignInButton(
                    Buttons.Google,
                    text: "Google İle Gİriş",
                    elevation: 4,
                    onPressed: () {
                      try{
                        Auth().signInWithGoogle();
                      }catch(e){}
                     
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }
}