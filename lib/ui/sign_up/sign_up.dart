import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_recipe_app/theme/color_primary.dart';
import 'package:food_recipe_app/ui/bottom_nav/bottom_navigation.dart';
import 'package:food_recipe_app/ui/homepage/home_page.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();

  static Future<User?> loginUsingEmailPaswword({required String email, required String password, required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e){
      if
      (e.code == "user-not-found"){
        print('No user found for that email');
      }
    }

    return user;
  }

  Future signUp() async {
    if(passwordConfirmed()) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );
      addDetailUser(_firstName.text.trim(), _usernameController.text.trim());
    }
  }

  Future addDetailUser(String name, String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name' : name,
      'email' : email,
    });
  }

  bool passwordConfirmed() {
    if(_passwordController.text.trim() == _confirmPasswordController.text.trim()){
      return true;
    }else{
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  alignment: Alignment.topRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              top: 48,
                              left: 10
                            ),
                            child: IconButton(onPressed: () {
                              Navigator.of(context).pop(true);
                            }, icon: Icon(Icons.arrow_back, color: MyColor.primary,)),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: 50,
                                right: 20
                            ),
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BottomNavbar(),));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: Container(
                                  width: 50,
                                  color: MyColor.primary.withOpacity(0.2),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Skip',
                                    style: GoogleFonts.poppins(
                                        color: MyColor.primary,
                                        fontSize: 14
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.all(40),
                        child: SvgPicture.asset(
                            'assets/reset_password.svg'
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 25,
                            right: 25
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 20,
                                right: 20
                            ),
                            color: Colors.black.withOpacity(0.03),
                            child: TextField(
                              maxLines: 1,
                              controller: _firstName,
                              style: TextStyle(
                                  fontSize: 18
                              ),
                              decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  hintText: "Name",
                                  hintStyle: TextStyle(
                                    color: Colors.black26,
                                    fontSize: 18,
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 25,
                            right: 25
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 20,
                                right: 20
                            ),
                            color: Colors.black.withOpacity(0.03),
                            child: TextField(
                              maxLines: 1,
                              controller: _usernameController,
                              style: TextStyle(
                                  fontSize: 18
                              ),
                              decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  hintText: "Email",
                                  hintStyle: TextStyle(
                                    color: Colors.black26,
                                    fontSize: 18,
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 25,
                            right: 25
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 20,
                                right: 20
                            ),
                            color: Colors.black.withOpacity(0.03),
                            child: TextField(
                              obscureText: true,
                              maxLines: 1,
                              controller: _passwordController,
                              style: TextStyle(
                                  fontSize: 18
                              ),
                              decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                    color: Colors.black26,
                                    fontSize: 18,
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 25,
                            right: 25
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 20,
                                right: 20
                            ),
                            color: Colors.black.withOpacity(0.03),
                            child: TextField(
                              obscureText: true,
                              maxLines: 1,
                              controller: _confirmPasswordController,
                              style: TextStyle(
                                  fontSize: 18
                              ),
                              decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  hintText: "Confirm Password",
                                  hintStyle: TextStyle(
                                    color: Colors.black26,
                                    fontSize: 18,
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Container(
                          color: MyColor.primary,
                          width: 250,
                          height: 50,
                          child: InkWell(
                              onTap: () async {
                                signUp();
                                if(FirebaseAuth.instance.currentUser != null){
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BottomNavbar(),));
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      backgroundColor: Color.fromARGB(255, 23, 23, 23),
                                      duration: Duration(seconds: 1),
                                      content: Row(
                                        children: [
                                          Icon(Icons.login,
                                              color: MyColor.primary,size: 18),
                                          SizedBox(width: 15),
                                          Text("SignUp Success"),
                                        ],
                                      )));
                                } else{
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      backgroundColor: Color.fromARGB(255, 23, 23, 23),
                                      duration: Duration(seconds: 1),
                                      content: Row(
                                        children: [
                                          Icon(Icons.error,
                                              color: Color.fromARGB(255, 213, 70, 70), size: 18),
                                          SizedBox(width: 15),
                                          Text("SignUp Failed"),
                                        ],
                                      )));
                                }
                              },
                              child: Center(child: Text('Sign Up', style: TextStyle(color: Colors.white),))
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}
