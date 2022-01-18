import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Auth.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class Gender {
  late int id;

  late String name;

  Gender(this.id, this.name);

  String getName() => name;

  static List<Gender> getGenderTypes() {
    return <Gender>[
      Gender(
        1,
        'male',
      ),
      Gender(2, 'female'),
      Gender(3, 'other')
    ];
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  final _email_controller = TextEditingController();
  final _password_controller = TextEditingController();
  final _full_name_controller = TextEditingController();
  final _confirm_password = TextEditingController();
  final _phone_number_controller = TextEditingController();
  final _faculty_controller = TextEditingController();
  late List<DropdownMenuItem<Gender>> _dropdownGenderMenuItems;
  late Gender _selectedGender;
  final List<Gender> _gender = Gender.getGenderTypes();
  var _obsecure_flag = true;
  var _obsecure_confirm_flag = true;
  var valid_password = true;
  var valid_length = true;
  var valid_email = true;

  @override
  void initState() {
    _dropdownGenderMenuItems = buildGenderDropMenu(_gender);
    _selectedGender = _dropdownGenderMenuItems[0].value!;
    super.initState();
  }

  List<DropdownMenuItem<Gender>> buildGenderDropMenu(List Genders) {
    List<DropdownMenuItem<Gender>> items = List.empty(growable: true);
    for (Gender gender in Genders) {
      items.add(
        DropdownMenuItem(
          value: gender,
          child: Text(
            gender.name,
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400)),
          ),
        ),
      );
    }
    return items;
  }

  void onChangeDropdownItem(Gender? selectedGender) {
    setState(() {
      _selectedGender = selectedGender!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthRepository>(context);
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SafeArea(
              child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.15,
            color: Color(0xFF8C88F9),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ))
                  ],
                ),
                Text(
                  "Sign Up to StudentHub",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                )
              ],
            ),
            alignment: Alignment.center,
          )),
          Flexible(
              child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Color(0xFF8C88F9), spreadRadius: 12, blurRadius: 10)
              ],
            ),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  "Create Account ",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
                Flexible(
                    child: SingleChildScrollView(

                  child: Padding(
                    padding: EdgeInsets.only(bottom: bottom),
                    child: Column(

                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(10)),
                        SizedBox(width: 362,child:TextFormField(
                          textAlignVertical: TextAlignVertical.center,
                          controller: _full_name_controller,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor:Color(0xFFF0F4F8) ,


                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xFFF0F4F8)),
                              ),
                              // border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.person,
                                color: Color(0xFFA6BCD0),
                                size: 30,
                              ),
                              labelText: 'Full Name',
                              labelStyle: TextStyle(
                                  fontSize: 20, color: Color(0xFFA6BCD0)),
                              constraints: BoxConstraints(maxWidth: 330),
                              floatingLabelBehavior:
                              FloatingLabelBehavior.never),
                        ))


                         ,




                              Padding(padding: EdgeInsets.all(15.0)),
                              SizedBox(width:362,child: TextFormField(
                                textAlignVertical: TextAlignVertical.center,
                                controller: _email_controller,
                                decoration: InputDecoration(

                                    filled: true,
                                    fillColor:Color(0xFFF0F4F8) ,

                                    errorText: valid_email
                                        ? null
                                        : "Enter a valid student email",
                                   //errorBorder: InputBorder.none,

                                    /// To check about the length and if the input is bigger than 1 line

                                    border:
                                    OutlineInputBorder()
                                    ,
                                    enabledBorder:  OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFF0F4F8)),
                                    )
                                    ,

                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Color(0xFFA6BCD0),
                                      size: 30,
                                    ),
                                    labelText: 'Email',
                                    labelStyle: TextStyle(
                                        fontSize: 20, color: Color(0xFFA6BCD0),),
                                    constraints: BoxConstraints(maxWidth: 330),
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.never),
                              ),),



                        Padding(padding: EdgeInsets.all(15)),

                              SizedBox(width:362,child:TextFormField(
                                obscureText: _obsecure_flag,
                                controller: _password_controller,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor:Color(0xFFF0F4F8) ,

                                    errorText: valid_length
                                        ? null
                                        : "Password must be at least 6 characters",


                                    /// To check about the length and if the input is bigger than 1 line

                                    border:  OutlineInputBorder()
                                    ,
                                    enabledBorder:  OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFF0F4F8)),
                                    )
                                    ,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obsecure_flag
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Color(0xFFA6BCD0),
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obsecure_flag = !_obsecure_flag;
                                        });
                                      },
                                    ),
                                    // border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Color(0xFFA6BCD0),
                                      size: 30,
                                    ),
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                        fontSize: 20, color: Color(0xFFA6BCD0)),
                                    constraints: BoxConstraints(maxWidth: 330),
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.never),
                              )),

                        Padding(
                          padding: EdgeInsets.all(15),
                        ),

                              SizedBox(width: 362,child:TextFormField(
                                obscureText: _obsecure_confirm_flag,
                                controller: _confirm_password,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor:Color(0xFFF0F4F8) ,
                                    errorText: valid_password
                                        ? null
                                        : 'Passwords must match',



                                    border: OutlineInputBorder()
                                    ,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFF0F4F8)),
                                    )
                                    ,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obsecure_confirm_flag
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Color(0xFFA6BCD0),
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obsecure_confirm_flag =
                                          !_obsecure_confirm_flag;
                                        });
                                      },
                                    ),
                                    // border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Color(0xFFA6BCD0),
                                      size: 30,
                                    ),
                                    labelText: 'Confirm Password',
                                    labelStyle: TextStyle(
                                        fontSize: 20, color: Color(0xFFA6BCD0)),
                                    constraints: BoxConstraints(maxWidth: 330),
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.never),
                              ))
                          ,
                        Padding(padding: EdgeInsets.all(15)),

                              SizedBox(width: 362,child:TextFormField(

                                maxLength: 10,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: _phone_number_controller,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor:Color(0xFFF0F4F8) ,
                                    counterText: "",


                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Color(0xFFF0F4F8)),
                                    ),
                                    // border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.phone,
                                      color: Color(0xFFA6BCD0),
                                      size: 30,
                                    ),
                                    labelText: 'Phone Number',
                                    labelStyle: TextStyle(
                                        fontSize: 20, color: Color(0xFFA6BCD0)),
                                    constraints: BoxConstraints(maxWidth: 330),
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.never),
                              )),

                        Padding(padding: EdgeInsets.all(15)),

                              SizedBox(width:362,child:TextFormField(
                                controller: _faculty_controller,
                                decoration: InputDecoration(

                                    filled: true,
                                    fillColor:Color(0xFFF0F4F8) ,
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Color(0xFFF0F4F8)),
                                    ),
                                    // border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.school,
                                      color: Color(0xFFA6BCD0),
                                      size: 30,
                                    ),
                                    labelText: 'Faculty',
                                    labelStyle: TextStyle(
                                        fontSize: 20, color: Color(0xFFA6BCD0)),
                                    constraints: BoxConstraints(maxWidth: 330),
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.never),
                              )),

                        Padding(
                          padding: EdgeInsets.all(15),
                        ),
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 15.0, right: 15.0),
                              decoration: BoxDecoration(
                                  color: Color(0xFFF0F4F8),
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    title: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          DropdownButton(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            dropdownColor: Color(0xFFF0F4F8),
                                            isExpanded: true,
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            iconSize: 40,
                                            underline: const SizedBox(),
                                            value: _selectedGender,
                                            items: _dropdownGenderMenuItems,
                                            onChanged: onChangeDropdownItem,
                                          ),
                                        ]),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.all(20)),
                        user.status == Status.Authenticating
                            ? Center(
                                child: CircularProgressIndicator(
                                color: Colors.deepPurpleAccent,
                              ))
                            : ElevatedButton(
                                onPressed: () async {
                                  if (!(_email_controller.text
                                          .endsWith("@campus.technion.ac.il") ||
                                      _email_controller.text
                                          .endsWith("@cs.technion.ac.il"))) {
                                    setState(() {
                                      valid_email = false;
                                    });
                                  } else {
                                    setState(() {
                                      valid_email = true;
                                    });
                                  }
                                  if (_password_controller.text.length < 6) {
                                    setState(() {
                                      valid_length = false;
                                    });
                                  } else {
                                    setState(() {
                                      valid_length = true;
                                    });
                                  }

                                  if (_confirm_password.text !=
                                      _password_controller.text) {
                                    setState(() {
                                      valid_password = false;
                                    });
                                  } else {
                                    setState(() {
                                      valid_password = true;
                                    });
                                  }
                                  if (valid_password &&
                                      valid_length &&
                                      valid_email) {
                                    final res = await user.signUp(
                                        _email_controller.text,
                                        _password_controller.text,
                                        _full_name_controller.text,_phone_number_controller.text,_faculty_controller.text,_selectedGender.name);
                                    if (res == Error.NO_ERROR) {
                                      Navigator.of(context).pop();
                                      final snackbar = SnackBar(
                                        content: Text(
                                            'An email has just been sent to you, Click the link provided to complete registration'),
                                        backgroundColor: Color(0xFF9189F3),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackbar);
                                    } else if (res ==
                                        Error.Email_Already_in_Use) {
                                      final snackbar = SnackBar(
                                        content: Text(
                                            'The account already exists for that email'),
                                        backgroundColor: Color(0xFF9189F3),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackbar);
                                    } else {
                                      final snackbar = SnackBar(
                                        content: Text('Sign up failed '),
                                        backgroundColor: Color(0xFF9189F3),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackbar);
                                    }
                                  }
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    Text(
                                      "Create Account",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    )
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFA1A3FF),
                                    onPrimary: Colors.white,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0)),
                                    fixedSize: Size(315, 60),
                                    textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                        Padding(padding: EdgeInsets.all(15))
                      ],
                    ),
                  ),
                ))
              ],
            ),
          ))
        ],
      ),
    );
  }
}
