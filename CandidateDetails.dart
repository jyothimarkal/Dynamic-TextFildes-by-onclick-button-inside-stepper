import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;
import 'dart:math' as Math;

import 'package:HRVISITOR/utils/network_utils.dart';


import 'package:documents_picker/documents_picker.dart';
import 'package:flutter/services.dart';
import 'package:HRVISITOR/startpage.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:frideos_core/frideos_core.dart';
import 'package:frideos/frideos.dart';

const TextStyle buttonText = TextStyle(color: Colors.white);

class CandidateDetails extends StatefulWidget {
  @override
  MyHomeState createState() => new MyHomeState();
}

class MyHomeState extends State<CandidateDetails> {
  // init the step to 0th position
  int current_step = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final formKey1= GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3= GlobalKey<FormState>();

  String candidates_name="",date_of_birth="",gender="",mobile_num="",email="",address="",blood_group="",marital_status="",father_name="",husband_name="";
  String fresher="",post_applied="",experience="",organization="",amount="";
  String high_qualification="",high_university="",high_passing_year="",high_percentagge="",puc_university="",puc_passing_year="",puc_percentagge="",sslc_university="",sslc_passing_year="",sslc_percentagge="";
  String part_time="",higher_study="",strengths="",weakness="",leave_employment="",why_hire_you="",achivements="",goals="",know_about_orgnization="",selected_join_date="",refre_friend_family="",phot="",resume="";

  String gender_value="",fresher_value="Yes",marital_status_value="",refre_friend_value="";


  List<String> _blood_group = <String>['Select Blood Group','A+','O+','B+','AB+','A-','O-','B-','AB-'];
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _blood_group_value = 'Select Blood Group';

  List<String> _know_organization = <String>['Select Option','Job Portal','Advertisement','Reference'];
  List<DropdownMenuItem<String>> _dropDownMenuOption;
  String _know_organization_value = 'Select Option';


  bool _validate = false,_validate1 = false,_validate3= false;

  File _image,_resume;
  String img_path="";
  TextEditingController cTitle = new TextEditingController();

  String _fileName="";

  String _platformVersion = "";

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  final formats = {
     //InputType.date: DateFormat('yyyy-MM-dd'),
    InputType.date: DateFormat("EEEE, MMMM d, yyyy"),
  };
  InputType inputType = InputType.date;
  DateTime date;
  ////////////////////////////////////////////////////////////////////////////////
  ///Gender values
  setRadioValue(String value) {
    setState(() {
      gender_value = value;
      print(gender_value);
    });
  }
  //Fresher values
  setRadioFresherValue(String value) {

    setState(() {
      fresher_value = value;
      print(fresher_value);
    });
  }
  //Fresher values
  setRadioMaritalStatusValue(String value) {

    setState(() {
      marital_status_value = value;
      print(marital_status_value);
    });
  }
  //refre_friend_value values
  setRadioRefreFriendValue(String value) {

    setState(() {
      refre_friend_value = value;
      print(refre_friend_value);
    });
  }
  set(String value) {
    setState(() {
      gender_value = value;
      fresher_value = value;
      marital_status_value = value;
      refre_friend_value = value;
   //   print(radioValue);
    });
  }
  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
  }
  //////////////////FOR DROPDOWN VALUES FOR BLOODGROUP/////////////////////////////////////////////////////////
  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String _blood_group_value in _blood_group) {
      items.add(new DropdownMenuItem(
          value: _blood_group_value,
          child: new Text(_blood_group_value)
      ));
    }
    return items;
  }
  void changedDropDownItem(String selectedBloodGroup) {
    setState(() {
      _blood_group_value = selectedBloodGroup;
    });
  }
  //////////////////FOR DROPDOWN VALUES FOR BLOODGROUP////////////////////////////////////////
  List<DropdownMenuItem<String>> getDropDownMenuOption() {
    List<DropdownMenuItem<String>> items = new List();
    for (String _know_organization_value in _know_organization) {
      items.add(new DropdownMenuItem(
          value: _know_organization_value,
          child: new Text(_know_organization_value)
      ));
    }
    return items;
  }
  void changedDropDownOption(String selectedOption) {
    setState(() {
      _know_organization_value = selectedOption;
    });
  }
 ///////////////////Select Date /////////////////
  /*Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2019)
    );
    if(picked != null) setState(() => _value = picked.toString());
  }*/
  ////////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    //about Organization
    _dropDownMenuOption=getDropDownMenuOption();
    _know_organization_value = _dropDownMenuOption[0].value;
    //Blood Group
    _dropDownMenuItems = getDropDownMenuItems();
    _blood_group_value = _dropDownMenuItems[0].value;
    super.initState();
  }

  //////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
      // Appbar
        appBar: new AppBar(
          title: new Text("HRVisitor"),
        ),
      body: new Container(
          child: Padding(
              padding: EdgeInsets.all(0.0),
              child: new Stepper(
                type: StepperType.vertical,
                // Using a variable here for handling the currentStep
                currentStep: this.current_step,
                // List the steps you would like to have
                steps: [
                  Step(
                    title: Text("Personal Details",style: TextStyle(fontWeight: FontWeight.bold),),
                    content: Form(
                       autovalidate: _validate,
                       key: formKey,
                        child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              //Text('Personal Details: ',style: TextStyle(fontWeight: FontWeight.bold),),
                             // SizedBox(height: 16.0),

                              Row(
                                  children: <Widget>[
                                    Text('Full Name: '),
                                    Icon(Icons.star,color: Colors.red,
                                      size: 10,)]),
                              SizedBox(height: 16.0),
                              TextFormField(
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                                  ),
                                  hintText: 'Full Name',
                                ),
                                validator: (String arg) {
                                  if(arg.length == 0)
                                    return 'Full Name is Required"';
                                  else
                                    return null;
                                },
                                keyboardType: TextInputType.text,
                                onSaved: (str) => candidates_name = str,
                              ),
                              SizedBox(height: 16.0),
                              Text('Date Of Birth: '),
                              SizedBox(height: 16.0),

                              DateTimePickerFormField(
                                inputType: inputType,
                                format: formats[inputType],
                                editable: true,
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red, width: 1.0),
                                    ),
                                    labelText: 'Date/Time', hasFloatingPlaceholder: false),
                                onChanged: (dt) => setState(() => date = dt),

                                onSaved:(dt) => date = dt,
                              ),

                              SizedBox(height: 16.0),
                              Row(
                                  children: <Widget>[
                                    Text('Gender: '),
                                    Icon(Icons.star,color: Colors.red,
                                      size: 10,)]),
                              SizedBox(height: 16.0),
                              new Container(
                                width: 300,
                                padding: const EdgeInsets.all(4.0),
                                decoration: new BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: new BorderRadius.circular(4.0),
                                    border: Border.all(color: Colors.red, width: 1.0)
                                ),
                                child:  Row(
                                  mainAxisSize: MainAxisSize.min,

                                  children:<Widget>[
                                    new Radio(
                                      onChanged: (String val) {
                                        setRadioValue(val);
                                      },
                                      activeColor: Colors.red,
                                      value: 'Male',
                                      groupValue: gender_value,
                                    ),
                                    Text('Male'),

                                    new Radio(
                                      onChanged: (String val) {
                                        setRadioValue(val);
                                      },
                                      activeColor: Colors.red,
                                      value: 'Female',
                                      groupValue: gender_value,
                                    ),
                                    Text('Female'),
                                  ],
                                ),

                              ),


                              SizedBox(height: 16.0),

                              Row(
                                  children: <Widget>[
                                    Text('Mobile No: '),
                                    Icon(Icons.star,color: Colors.red,
                                      size: 10,)]),
                              SizedBox(height: 16.0),
                              TextFormField(
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                                  ),
                                  hintText: 'Mobile No.',
                                ),
                                validator: (String arg) {
                                  if((arg.length == 0 ) || (arg.length != 10) )
                                    return 'Mobile Number must be 10 digits.';
                                  else
                                    return null;
                                },
                                keyboardType: TextInputType.phone,
                                onSaved: (str) => mobile_num = str,
                              ),

                              SizedBox(height: 16.0),


                               SizedBox(height: 16.0),
                               Row(
                                  children: <Widget>[
                                    Text('E-Mail : '),
                                    Icon(Icons.star,color: Colors.red,
                                      size: 10,)]),

                              SizedBox(height: 16.0),
                              TextFormField(
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                                  ),
                                  hintText: 'Email ',
                                ),
                                validator: validateEmail,
                                keyboardType: TextInputType.emailAddress,
                                onSaved: (str) => email = str,
                              ),
                              SizedBox(height: 16.0),
                              Text('Address: '),
                              SizedBox(height: 16.0),
                              TextFormField(
                                maxLines:5,
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                                  ),
                                  hintText: 'Address',
                                ),

                                keyboardType: TextInputType.multiline,
                                onSaved: (str) => address = str,
                              ),

                              SizedBox(height: 16.0),
                              Text('Blood Group: '),
                              SizedBox(height: 16.0),
                              new Container(
                                width: 260, padding: const EdgeInsets.all(4.0),
                                decoration: new BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: new BorderRadius.circular(4.0),
                                    border: Border.all(color: Colors.red, width: 1.0)
                                ),
                                child:  new DropdownButton(
                                  isExpanded: true,
                                  value: _blood_group_value,
                                  items: _dropDownMenuItems,
                                  onChanged: changedDropDownItem,
                                ),

                              ),


                              SizedBox(height: 16.0),
                              Text('Marital Status: '),
                              SizedBox(height: 16.0),
                              new Container(
                                width: 300, padding: const EdgeInsets.all(4.0),
                                decoration: new BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: new BorderRadius.circular(4.0),
                                    border: Border.all(color: Colors.red, width: 1.0)
                                ),
                                child:  Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children:<Widget>[
                                    new Radio(
                                      onChanged: (String val) {
                                        setRadioMaritalStatusValue(val);
                                      },
                                      activeColor: Colors.red,
                                      value: 'Single',
                                      groupValue: marital_status_value,
                                    ),
                                    Text('Single'),

                                    new Radio(
                                      onChanged: (String val) {
                                        setRadioMaritalStatusValue(val);
                                      },
                                      activeColor: Colors.red,
                                      value: 'Married',
                                      groupValue: marital_status_value,
                                    ),
                                    Text('Married'),
                                  ],
                                ),
                              ),


                              SizedBox(height: 16.0),


                              Text('Father / Husband Name : '),
                              SizedBox(height: 16.0),
                              TextFormField(
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                                  ),
                                  hintText: 'Father / Husband Name',
                                ),

                                keyboardType: TextInputType.text,
                                onSaved: (str) => father_name = str,
                              ),

                              SizedBox(height: 16.0),
                              /*Text('Husband Name : '),
                              SizedBox(height: 16.0),
                              TextFormField(
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                                  ),
                                  hintText: 'Husband Name ',
                                ),
                                keyboardType: TextInputType.text,
                                onSaved: (str) => husband_name = str,
                              ),*/
                            ])),
                        isActive: true
                      ),


                  Step(
                    title: new Text("Work Experience",style: TextStyle(fontWeight: FontWeight.bold),),
                    content:
                    Form(
                      autovalidate: _validate1,
                      key: formKey1,
                        child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              DynamicFieldsWidget(),
                             /* SizedBox(height: 16.0),
                                Text('Post Applied For: '),
                              SizedBox(height: 16.0),
                              TextFormField(
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                                  ),
                                  hintText: 'Post Applied For',
                                ),

                                keyboardType: TextInputType.text,
                                onSaved: (str) => post_applied = str,
                              ),

                              SizedBox(height: 16.0),
                              Row(
                                  children: <Widget>[
                                    Text('Fresher: '),
                                    Icon(Icons.star,color: Colors.red,
                                      size: 10,)]),
                              new Container(
                                width: 300, padding: const EdgeInsets.all(4.0),
                                decoration: new BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: new BorderRadius.circular(4.0),
                                    border: Border.all(color: Colors.red, width: 1.0)
                                ),
                                child:  Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children:<Widget>[
                                    new Radio(
                                      onChanged: (String val) {
                                        setRadioFresherValue(val);
                                      },
                                      activeColor: Colors.red,
                                      value: 'Yes',
                                      groupValue: fresher_value,
                                    ),
                                    Text('Yes'),

                                    new Radio(
                                      onChanged: (String val) {
                                        setRadioFresherValue(val);
                                      },
                                      activeColor: Colors.red,
                                      value: 'No',
                                      groupValue: fresher_value,
                                    ),
                                    Text('No'),
                                  ],
                                ),
                              ),

                              SizedBox(height: 16.0),
                              Text('Total Years of Experience: '),
                              SizedBox(height: 16.0),
                              TextFormField(
                                enabled: fresher_value=="No"?true : false,
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                                  ),

                                  hintText: 'Experience',
                                ),
                                keyboardType: TextInputType.number,
                                onSaved: (str) => experience = str,
                              ),
                              SizedBox(height: 16.0),
                              Text('Current Working Organization : '),
                              SizedBox(height: 16.0),
                              TextFormField(
                                enabled: fresher_value=="No"?true : false,
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                                  ),
                                  hintText: 'Organization',
                                ),
                                keyboardType: TextInputType.text,
                                onSaved: (str) => organization = str,
                              ),

                              SizedBox(height: 16.0),
                              Text('Take Home Amount: '),
                              SizedBox(height: 16.0),
                              TextFormField(
                                enabled: fresher_value=="No"?true : false,
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                                  ),
                                  hintText: 'Amount',
                                ),
                                keyboardType: TextInputType.number,
                                onSaved: (str) => amount = str,
                              ),*/

                            ])),
                    isActive: true,
                  ),
                  Step(
                    title: Text("Educational Details",style: TextStyle(fontWeight: FontWeight.bold),),
                    content:
                        Form(
                        key: formKey2,
                        child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 16.0),
                          Center(
                            child:
                            Text('HIGHEST QUALIFICATION',
                              style: TextStyle(
                                  fontSize:20 ,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(0.8)),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Container(
                            height: 420,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.blueAccent,
                                  width: 2
                              ),
                              borderRadius: new BorderRadius.all(
                                new Radius.circular(16.0),
                              ),
                            ),
                            child: ListView(children: <Widget>[
                              SizedBox(height: 8.0),
                              Text('Qualification: '),
                              SizedBox(height: 16.0),
                              TextFormField(
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                                  ),
                                  hintText: 'Qualification',
                                ),
                                keyboardType: TextInputType.text,
                                onSaved: (str) => high_qualification = str,
                              ),

                              SizedBox(height: 8.0),
                              Text('Board/University: '),
                              SizedBox(height: 16.0),
                              TextFormField(
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                                  ),
                                  hintText: 'Board/University',
                                ),
                                keyboardType: TextInputType.text,
                                onSaved: (str) => high_university = str,
                              ),


                              SizedBox(height: 8.0),
                              Text('Year of Passing: '),
                              SizedBox(height: 16.0),
                              TextFormField(
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                                  ),
                                  hintText: 'Year',
                                ),
                                keyboardType: TextInputType.number,
                                onSaved: (str) => high_passing_year = str,
                              ),
                              SizedBox(height: 8.0),
                              Text('Percentage: '),
                              SizedBox(height: 16.0),
                              TextFormField(
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                                  ),
                                  hintText: 'Percentage',
                                ),
                                keyboardType: TextInputType.number,
                                onSaved: (str) => high_percentagge = str,
                              ),
                            ],),
                          ),


                          SizedBox(height: 16.0),
                          Center(
                            child:
                            Text('PUC',
                              style: TextStyle(
                                  fontSize:20 ,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(0.8)),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Container(
                            height: 320,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blueAccent,
                                width: 2,
                              ),
                              borderRadius: new BorderRadius.all(
                                new Radius.circular(16.0),
                              ),
                            ),

                            child: ListView(children: <Widget>[

                              SizedBox(height: 8.0),
                              Text('Board/University: '),
                              SizedBox(height: 16.0),
                              TextFormField(
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                                  ),
                                  hintText: 'Board/University',
                                ),
                                keyboardType: TextInputType.text,
                                onSaved: (str) => puc_university = str,
                              ),


                              SizedBox(height: 8.0),
                              Text('Year of Passing: '),
                              SizedBox(height: 16.0),
                              TextFormField(
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                                  ),
                                  hintText: 'Year',
                                ),
                                keyboardType: TextInputType.number,
                                onSaved: (str) => puc_passing_year = str,
                              ),
                              SizedBox(height: 8.0),
                              Text('Percentage: '),
                              SizedBox(height: 16.0),
                              TextFormField(
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                                  ),
                                  hintText: 'Percentage',
                                ),
                                keyboardType: TextInputType.number,
                                onSaved: (str) => puc_percentagge = str,
                              ),

                            ],),
                          ),

                          SizedBox(height: 16.0),
                          Center(
                            child:
                            Text('SSLC',
                              style: TextStyle(
                                  fontFamily: "Rock Salt",
                                  fontSize:20 ,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(0.8)),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Container(
                            height: 320,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.blueAccent,
                                  width: 2
                              ),
                              borderRadius: new BorderRadius.all(
                                new Radius.circular(16.0),
                              ),
                            ),
                            child: ListView(children: <Widget>[


                              SizedBox(height: 8.0),
                              Text('Board/University: '),
                              SizedBox(height: 16.0),
                              TextFormField(
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                                  ),
                                  hintText: 'Board/University',
                                ),
                                keyboardType: TextInputType.text,
                                onSaved: (str) => sslc_university = str,
                              ),


                              SizedBox(height: 8.0),
                              Text('Year of Passing: '),
                              SizedBox(height: 16.0),
                              TextFormField(
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                                  ),
                                  hintText: 'Year',
                                ),
                                keyboardType: TextInputType.number,
                                onSaved: (str) => sslc_passing_year = str,
                              ),

                              SizedBox(height: 8.0),
                              Text('Percentage: '),
                              SizedBox(height: 16.0),
                              TextFormField(
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                                  ),
                                  hintText: 'Percentage',
                                ),
                                keyboardType: TextInputType.number,
                                onSaved: (str) => sslc_percentagge = str,
                              ),

                            ],),
                          ),

                          SizedBox(height: 16.0),
                        ])),
                    isActive: true,
                  ),
                  Step(
                    title: new Text("Other Details",style: TextStyle(fontWeight: FontWeight.bold),),
                    content:
                      Form(
                       autovalidate: _validate3,
                       key: formKey3,
                        child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 16.0),
                          Text('Pursuing any course currently in part time base? Please mention.: '),
                          TextFormField(
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 1.0),
                              ),
                              hintText: 'Course',
                            ),
                            keyboardType: TextInputType.text,
                            onSaved: (str) => part_time = str,
                          ),

                          SizedBox(height: 16.0),

                          Text('Future interest in higher study (Write down course name): '),
                          TextFormField(
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 1.0),
                              ),
                              hintText: 'Course',
                            ),
                            keyboardType: TextInputType.text,
                            onSaved: (str) => higher_study = str,
                          ),

                          SizedBox(height: 16.0),
                          Text('Your Strengths : '),
                          TextFormField(
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 1.0),
                              ),
                              hintText: 'Strengths',
                            ),
                            validator: (String arg) {
                              if(arg.length == 0)
                                return 'Write Your Strengths."';
                              else
                                return null;
                            },
                            maxLines: 2,
                            keyboardType: TextInputType.multiline,
                            onSaved: (str) => strengths = str,
                          ),

                          SizedBox(height: 16.0),
                          Text('Your Weaknesses: '),
                          TextFormField(
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 1.0),
                              ),
                              hintText: 'Weaknesses',
                            ),
                            validator: (String arg) {
                              if(arg.length == 0)
                                return 'Write Your Weaknesses."';
                              else
                                return null;
                            },
                            maxLines: 2,
                            keyboardType: TextInputType.multiline,
                            onSaved: (str) => weakness = str,
                          ),


                          SizedBox(height: 16.0),
                          Text('Why do you wish to leave you existing employment?: '),
                          TextFormField(
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 1.0),
                              ),
                              hintText: 'Reason',
                            ),
                            maxLines: 2,
                            keyboardType: TextInputType.multiline,
                            onSaved: (str) => leave_employment = str,
                          ),

                          SizedBox(height: 16.0),
                          Text('Why should we hire you?: '),
                          TextFormField(
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 1.0),
                              ),
                              hintText: 'Reason',
                            ),
                            maxLines: 2,
                            keyboardType: TextInputType.multiline,
                            onSaved: (str) => why_hire_you = str,
                          ),

                          SizedBox(height: 16.0),
                          Text('What are your achievements till date?: '),
                          TextFormField(
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 1.0),
                              ),
                              hintText: 'Achievements',
                            ),
                            maxLines: 2,
                            keyboardType: TextInputType.multiline,
                            onSaved: (str) => achivements = str,
                          ),

                          SizedBox(height: 16.0),
                          Text('Write your goals in details please: '),
                          TextFormField(
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 1.0),
                              ),
                              hintText: 'Goals',
                            ),
                            maxLines: 2,
                            keyboardType: TextInputType.multiline,
                            onSaved: (str) => goals = str,
                          ),

                         SizedBox(height: 16.0),

                          Row(
                              children: <Widget>[
                                Text('How did you come to know about our organization?: '),
                                Icon(Icons.star,color: Colors.red,
                                  size: 10,)]),
                          new Container(
                            width: 260, padding: const EdgeInsets.all(4.0),
                            decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.circular(4.0),
                                border: Border.all(color: Colors.red, width: 1.0)
                            ),
                            child:  new DropdownButton(
                              isExpanded: true,
                              value: _know_organization_value,
                              items: _dropDownMenuOption,
                              onChanged: changedDropDownOption,
                            ),
                          ),

                          SizedBox(height: 16.0),
                          Text('How soon you can join with our organization, if you get selected? '),
                          TextFormField(
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 1.0),
                              ),
                              hintText: 'Joining Details',
                            ),
                            validator: (String arg) {
                              if(arg.length == 0)
                                return 'Joining Details required."';
                              else
                                return null;
                            },
                            maxLines: 2,
                            keyboardType: TextInputType.multiline,
                            onSaved: (str) => selected_join_date = str,
                          ),



                          SizedBox(height: 16.0),
                          Text('Refer friends or family for the position ? yes /no: '),
                          new Container(
                            width: 300, padding: const EdgeInsets.all(4.0),
                            decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.circular(4.0),
                                border: Border.all(color: Colors.red, width: 1.0)
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children:<Widget>[
                                new Radio(
                                  onChanged: (String val) {
                                    setRadioRefreFriendValue(val);
                                  },
                                  activeColor: Colors.red,
                                  value: 'Yes',
                                  groupValue: refre_friend_value,
                                ),
                                Text('Yes'),

                                new Radio(
                                  onChanged: (String val) {
                                    setRadioRefreFriendValue(val);
                                  },
                                  activeColor: Colors.red,
                                  value: 'No',
                                  groupValue: refre_friend_value,
                                ),
                                Text('No'),
                              ],
                            ),
                          ),
                         SizedBox(height: 16.0),

                        Text('Photo Upload: '),
                          new RaisedButton(
                            padding: const EdgeInsets.all(16.0),
                            textColor: Colors.blue,
                            onPressed: getImageGallery,
                            child: new Text("Photo Upload"),
                          ),
                          new Text(img_path),

                          SizedBox(height: 16.0),
                          Text('Resume Upload:'),
                          new RaisedButton(
                            padding: const EdgeInsets.all(16.0),
                            textColor: Colors.blue,
                            onPressed: () =>  _openFileExplorer(),
                            child: new Text("Resume Upload"),
                          ),
                          new Text(_platformVersion),

                         SizedBox(height: 16.0),
                        ])),
                    isActive: true,
                  ),
                ],
                // Know the step that is tapped
                onStepTapped: (step) {
                  setState(() {
                    current_step = step;
                   });
                  print("onStepTapped : " + step.toString());
                },
                onStepCancel: () {
                  setState(() {
                    if (current_step > 0) {
                      current_step = current_step - 1;
                    } else {
                      current_step = 0;
                    }
                  });
                  print("onStepCancel : " + current_step.toString());
                },
                onStepContinue: () {
                  setState(() {
                  if(current_step==0)
                    {
                      onPressed1();
                      if( _validate!=true)
                      {
                        current_step = current_step + 1;
                        // showInSnackBar("Move to Next");
                      }
                     // showInSnackBar("Move to step 1");
                    }
                    else if(current_step==1)
                    {
                      onPressed2();
                      if( _validate1!=true)
                      {
                        current_step = current_step + 1;
                        // showInSnackBar("Move to Next");
                      }
                     // showInSnackBar("Move to step 2");
                    }
                    else if(current_step==2)
                    {
                      onPressed3();
                      current_step = current_step + 1;
                     // showInSnackBar("Move to step 3");
                    }
                    else if(current_step==3)
                    {
                      onPressed4();

                      if( _validate3!=true)
                      {
                        _insertCandidatesDetails(context);
                        current_step = 0;
                       // _ackAlert(context);
                      }
                     // showInSnackBar("Move to step 4");
                    }

                  });

                },
              )),
        )

    );
  }
  /////////////////////SERVER CODE//////////////////////////////
  ///////////////////GALLERY IMAGE PICKER/////////////////////////////
  Future getImageGallery() async{

    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    try {
      final tempDir = await getTemporaryDirectory();
      final path = tempDir.path;
     print('imageFile path: $imageFile');
    /*  int rand = new Math.Random().nextInt(100000);

      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      Img.Image smallerImg = Img.copyResize(image, 500);

      var compressImg = new File("$path/image_$rand.jpg")
        ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));
      */
      setState(() {
        img_path=imageFile.path;
        _image = imageFile;
        print(_image);
        print("img_path :111 $img_path");
      });
    }
    catch (e) {
      print(e.toString());
    }

  }

  Future upload(File imageFile) async{
    print("insde upload"+imageFile.path);
    try {
      var stream = new http.ByteStream(
          DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      //var uri = Uri.parse("http://192.168.1.6/flutter_upload_image/upload.php");
     var uri = Uri.parse("http://workspacelab.in/StudentProject/Flutter/candidateImageUpload.php");
      //  var uri = Uri.parse("http://hrmetrix.in/HRVisitor/candidateImageUpload.php");
      print("insde uri "+imageFile.path  +" url = "+uri.toString());
      img_path=imageFile.path;
      var request = new http.MultipartRequest("POST", uri);

      //   print("before multipartFile "+imageFile.path  +" request = "+request.toString());
      var multipartFile = new http.MultipartFile("image", stream, length, filename: basename(imageFile.path));
      request.fields['title'] = cTitle.text;
      request.files.add(multipartFile);
      // print("after  multipartFile "+imageFile.path  +" multipartFile = "+multipartFile.toString());

      var response = await request.send();
      print("insde upload11113"+imageFile.path);
      if (response.statusCode == 200) {
        print("Image Uploaded");
      } else {
        print("Upload Failed");
      }
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    }
    catch(e)
    {
      print(e.toString());
    }
  }
  //////////////////////////////////////////////////////////////////////////
  /////////////////////////RESUME UPLOAD/////////////////////////////////
  // Platform messages are asynchronous, so we initialize in an async method.
  _openFileExplorer() async {
    List<dynamic> docPaths;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      docPaths = await DocumentsPicker.pickDocuments;
    } on PlatformException {
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted)
      return;
    setState(() {
      _platformVersion = docPaths[0];
      print('_platformVersion  $_platformVersion');
      _fileName = _platformVersion;
    });


  }

  Future uploadResume(File imageFile) async{
    print("insde upload"+imageFile.path);
    try {
      var stream = new http.ByteStream(
          DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
     var uri = Uri.parse("http://workspacelab.in/StudentProject/Flutter/candidateResumeUpload.php");
      // var uri = Uri.parse("http://hrmetrix.in/HRVisitor/candidateResumeUpload.php");
      print("insde uri "+imageFile.path  +" url = "+uri.toString());
      var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile("image", stream, length, filename: basename(imageFile.path));
      request.files.add(multipartFile);

      var response = await request.send();
      print("insde upload11113"+imageFile.path);
      if (response.statusCode == 200) {
        print("Image Uploaded");
      } else {
        print("Upload Failed");
      }
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    }
    catch(e)
    {
      print(e.toString());
    }
  }
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////Send data to server //////////////////////////////////

  void onPressed1() {
    var form = formKey.currentState;
      if (form.validate()) {
      // Text forms has validated.
      // Let's validate radios and checkbox
      if (gender_value.trim().length==0  || gender_value.isEmpty)
      {
        // None of the radio buttons was selected
        print("radioValue : $gender_value.trim().length");
        var snackbar = SnackBar(
          content:
          Text('Please Select Gender '),
          duration: Duration(milliseconds: 3000),
        );
        setState(() => _validate = true);
        _scaffoldKey.currentState.showSnackBar(snackbar);
      }

      else {
        // Every of the data in the form are valid at this point
        form.save();
        setState(() {
          _validate = false;
        });
      }
    } else {
      setState(() => _validate = true);

      var snackbar = SnackBar(
        content:
        Text('Please check required fileds !!'),
        duration: Duration(milliseconds: 3000),
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }
  void onPressed2() {
    var form = formKey1.currentState;

     if (form.validate()) {
      // Text forms has validated.
      // Let's validate radios and checkbox
      if (fresher_value.trim().length==0  || fresher_value.isEmpty)
      {
        // None of the radio buttons was selected
        print("fresher_value : $fresher_value.trim().length");
        var snackbar = SnackBar(
          content:
          Text('Please Select Fresher Type '),
          duration: Duration(milliseconds: 3000),
        );
        setState(() => _validate1 = true);
        _scaffoldKey.currentState.showSnackBar(snackbar);
      } else {
        // Every of the data in the form are valid at this point
        form.save();
        setState(() {
          _validate1 = false;
        });
      }
    } else {
      setState(() => _validate1 = true);

      var snackbar = SnackBar(
        content:
        Text('Please check required fileds !!'),
        duration: Duration(milliseconds: 3000),
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }
  void onPressed3() {
    var form = formKey2.currentState;
    if (form.validate()) {
      form.save();
      print('Education : $fresher_value ');
     }
  }
  void onPressed4() {

    final form = formKey3.currentState;
    if (form.validate()) {
      // Text forms has validated.
      // Let's validate radios and checkbox

      if (_know_organization_value=="Select Option" )
      {
        // None of the radio buttons was selected
        print("know_organization_value : $_know_organization_value.trim().length");
        var snackbar = SnackBar(
          content:
          Text('Select How you know about organization.'),
          duration: Duration(milliseconds: 3000),
        );
        setState(() => _validate3 = true);
        _scaffoldKey.currentState.showSnackBar(snackbar);
      }
      else if (img_path.trim().length==0  || img_path.isEmpty)
      {
        // None of the radio buttons was selected
        print("Photo : $img_path.trim().length");
        var snackbar = SnackBar(
          content:
          Text('Please Upload Your Photo '),
          duration: Duration(milliseconds: 3000),
        );
        setState(() => _validate3 = true);
        _scaffoldKey.currentState.showSnackBar(snackbar);
      }
    /*  else if (_platformVersion.trim().length==0  || _platformVersion.isEmpty)
      {
        // None of the radio buttons was selected
        print("Resume : $_platformVersion.trim().length");
        var snackbar = SnackBar(
          content:
          Text('Please Upload Your Resume '),
          duration: Duration(milliseconds: 3000),
        );
        setState(() => _validate3 = true);
        _scaffoldKey.currentState.showSnackBar(snackbar);
      }*/
       else {
        // Every of the data in the form are valid at this point
        form.save();
        setState(() {
          _validate3 = false;
        });
      }
    } else {
      setState(() => _validate3 = true);

      var snackbar = SnackBar(
        content:
        Text('Please check required fileds !!'),
        duration: Duration(milliseconds: 3000),
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }


  _insertCandidatesDetails(BuildContext context1) async
  {
      print('_insertVisitorDetails values :');
    print('candidates_name: $candidates_name, date_of_birth: $date, gender : $gender_value ,mobile_num: $mobile_num,email: $email,address:  $address,blood_group: $_blood_group_value ,marital_status: $marital_status_value,father_name: $father_name');
    print('Fresher: $fresher_value, Post Applied: $post_applied, experience : $experience ,Organization: $organization,amount: $amount');
    print('high_qualification: $high_qualification, high_university: $high_university, high_passing_year : $high_passing_year ,high_percentagge: $high_percentagge');
    print('puc_university: $puc_university, puc_passing_year: $puc_passing_year, puc_percentagge : $puc_percentagge');
    print('sslc_university: $sslc_university, sslc_passing_year: $sslc_passing_year, sslc_percentagge : $sslc_percentagge');

    print('part_time: $part_time, higher_study: $higher_study, strengths : $strengths ,weakness: $weakness,leave_employment: $leave_employment,why_hire_you:  $why_hire_you');
    print('achivements: $achivements ,goals: $goals,know_about_orgnization: $know_about_orgnization,selected_join_date: $selected_join_date,refre_friend_value : $refre_friend_value');
    print('image : $img_path');

     var responseJson = await NetworkUtils.registerCandidates(
        candidates_name,date.toString(),mobile_num,gender_value,email,address,_blood_group_value,marital_status_value,father_name,
        fresher_value,post_applied,experience,organization,amount,
        high_qualification,high_university,high_passing_year,high_percentagge,
        puc_university,puc_passing_year,puc_percentagge,
        sslc_university,sslc_passing_year,sslc_percentagge,
        part_time,higher_study,strengths,weakness,leave_employment,why_hire_you,achivements,goals,know_about_orgnization,selected_join_date,refre_friend_value,img_path,_platformVersion
      );
    print('response222: '+responseJson.toString());
    print(responseJson.toString());

      if(_image!=null) {
        upload(_image);
      }
      if (_fileName != null) {
        File imageFile = new File(_fileName);
        uploadResume(imageFile);
      }
      var snackbar = SnackBar(
        content:
        Text('Success'),
        // duration: Duration(milliseconds: 3000),
        action: new SnackBarAction(
          label: 'Okay',
          onPressed: () {
            // do something
            Navigator.of(context1).pop(true);
          },
        ),
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);
  }

    ///////////////////SUECCSS MESSAGE IN ALERT DIALOG/////////////////////////////
  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Successfully !!'),
          content: const Text('Data Saved Successfully.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StartPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }
////////////////////////////////////////////////////////////////////////////////
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }
}
//////////////////////////////Dynamic felids ////////////////////////////
/*class DynamicFieldsPage extends StatefulWidget {
  @override
  _DynamicFieldsPageState createState() => _DynamicFieldsPageState();
}

class _DynamicFieldsPageState extends State<DynamicFieldsPage> {
  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dynamic fields validation'),
        ),
        body: DynamicFieldsWidget(),
      ),
    );
  }
}*/

class FieldsWidget extends StatelessWidget {
  const FieldsWidget({this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text('${index + 1}:')),
        Expanded(
         child: SizedBox(height: 200.0,
          child: Column(
            children: <Widget>[
              StreamBuilder<String>(
                  initialData: ' ',
                  stream: bloc.qualificationFields.value[index].outStream,
                  builder: (context, snapshot) {
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: TextField(
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Name:',
                              hintText: 'Insert a name...',
                              errorText: snapshot.error,
                            ),
                            onChanged: bloc.qualificationFields.value[index].inStream,
                          ),
                        ),
                      ],
                    );
                  }),
              StreamBuilder<String>(
                  initialData: ' ',
                  stream: bloc.universityFields.value[index].outStream,
                  builder: (context, snapshot) {
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: TextField(
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Age:',
                              hintText: 'Insert the age (1 - 999).',
                              errorText: snapshot.error,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: bloc.universityFields.value[index].inStream,
                          ),
                        ),
                      ],
                    );
                  }),

              StreamBuilder<String>(
                  initialData: ' ',
                  stream: bloc.yearFields.value[index].outStream,
                  builder: (context, snapshot) {
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: TextField(
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: 'year:',
                              hintText: 'Insert a yearFields...',
                              errorText: snapshot.error,
                            ),
                            onChanged: bloc.yearFields.value[index].inStream,
                          ),
                        ),
                      ],
                    );
                  }),
              StreamBuilder<String>(
                  initialData: ' ',
                  stream: bloc.percentageFields.value[index].outStream,
                  builder: (context, snapshot) {
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: TextField(
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: 'percentage:',
                              hintText: 'Insert the percentage.',
                              errorText: snapshot.error,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: bloc.percentageFields.value[index].inStream,
                          ),
                        ),
                      ],
                    );
                  }),
              const SizedBox(
                height: 22.0,
              ),
            ],
          ),
         ),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          color: Colors.red,
          onPressed: () => bloc.removeFields(index),
        ),
      ],
    );
  }
}

class DynamicFieldsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> _buildFields(int length) {

      return List<Widget>.generate(length, (i) => FieldsWidget(index: i));
    }

    return ListView(

      children: <Widget>[
        Container(
          width: 200,
          height: 16.0,
        ),
        ValueBuilder<List<StreamedValue<String>>>(

          streamed: bloc.qualificationFields,
          builder: (context, snapshot) {
            return Column(
              children: _buildFields(snapshot.data.length),
            );
          },
          noDataChild: const Text('NO DATA'),
        ),
        Container(height: 20,width: 200,),
        Row(

          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            RaisedButton(
              color: Colors.green,
              child: const Text('Add', style: buttonText),
              onPressed: bloc.newFields,
            ),
            StreamBuilder<bool>(
                stream: bloc.isFormValid.outStream,
                builder: (context, snapshot) {

                  return RaisedButton(
                    color: Colors.blue,
                    child: Text('Submit', style: buttonText),
                    onPressed: () async {
                      // ignore: argument_type_not_assignable, argument_type_not_assignable
                      bloc.submit();

                      for (var item in bloc.qualificationFields.value) {
                        if (item.value != null) {
                          final qualification=item.value.toString();
                          print('qualification111  $qualification');
                        }
                      }

                      for (var item in bloc.universityFields.value) {
                        if (item.value != null) {
                          final university = int.tryParse(item.value);
                          print('university11 $university');
                        }
                      }
                      for (var item in bloc.yearFields.value) {
                        if (item.value != null) {
                          final year = int.tryParse(item.value);
                          print('year11 $year');
                        }
                      }
                      for (var item in bloc.percentageFields.value) {
                        if (item.value != null) {
                          final percentage = int.tryParse(item.value);
                          print('percentage11 $percentage');
                        }
                      }
                    },
                  );




                }),
          ],
        ),
      ],
    );
  }
}

class DynamicFieldsBloc {
  DynamicFieldsBloc() {
    print('-------DynamicFields BLOC--------');

    // Adding the initial pair of fields to the screen
    qualificationFields.addElement(StreamedValue<String>());
    universityFields.addElement(StreamedValue<String>());
    yearFields.addElement(StreamedValue<String>());
    percentageFields.addElement(StreamedValue<String>());

    // Set the method to call every time the stream emits a new event
    qualificationFields.value.last.onChange(checkForm);
    universityFields.value.last.onChange(checkForm);
    yearFields.value.last.onChange(checkForm);
    percentageFields.value.last.onChange(checkForm);
  }

  // A StreamedList holds the a list of StreamedValue of type String so
  // it is possibile adding more items.
  final qualificationFields = StreamedList<StreamedValue<String>>(initialData: []);
  final universityFields = StreamedList<StreamedValue<String>>(initialData: []);
  final yearFields = StreamedList<StreamedValue<String>>(initialData: []);
  final percentageFields = StreamedList<StreamedValue<String>>(initialData: []);

  // This StreamedValue is used to handle the current validation state
  // of the form.
  final isFormValid = StreamedValue<bool>();

  // Every time the user clicks on the "New fields" button, this method
  // add two new fields and sets the checkForm method to be called
  // every time these new fields changes.
  void newFields() {
    qualificationFields.addElement(StreamedValue<String>());
    universityFields.addElement(StreamedValue<String>());
    yearFields.addElement(StreamedValue<String>());
    percentageFields.addElement(StreamedValue<String>());

    qualificationFields.value.last.onChange(checkForm);
    universityFields.value.last.onChange(checkForm);
    yearFields.value.last.onChange(checkForm);
    percentageFields.value.last.onChange(checkForm);

    // This is used to force the checking of the form so that, adding
    // the new fields, it can reveal them as empty and sets the form
    // to not valid.
    checkForm(null);
  }

  void checkForm(String _) {
    bool isValidFieldsTypeQualification = true;
    bool isValidFieldsTypeUniversity = true;
    bool isValidFieldsTypeYear = true;
    bool isValidFieldsTypePercentage = true;

    for (var item in qualificationFields.value) {
      if (item.value != null) {
        if (item.value.isEmpty) {
          item.stream.sink.addError('The text must not be empty.');
          isValidFieldsTypeQualification = false;
        }
      } else {
        isValidFieldsTypeQualification = false;
      }
    }

    for (var item in universityFields.value) {
      if (item.value != null) {
        final age = int.tryParse(item.value);

        if (age == null) {
          item.stream.sink.addError('Enter a valida number.');
          isValidFieldsTypeUniversity = false;
        } else if (age < 1 || age > 999) {
          item.stream.sink
              .addError('The age must be a number between 1 and 999.');
          isValidFieldsTypeUniversity = false;
        }
      } else {
        isValidFieldsTypeUniversity = false;
      }
    }
    for (var item in yearFields.value) {
      if (item.value != null) {
        final age = int.tryParse(item.value);

        if (age == null) {
          item.stream.sink.addError('Enter a valida Year.');
          isValidFieldsTypeYear = false;
        } else if (age < 1 || age > 999) {
          item.stream.sink
              .addError('The Year must be enter');
          isValidFieldsTypeYear = false;
        }
      } else {
        isValidFieldsTypeYear = false;
      }
    }
    for (var item in percentageFields.value) {
      if (item.value != null) {
        final age = int.tryParse(item.value);

        if (age == null) {
          item.stream.sink.addError('Enter a valida number.');
          isValidFieldsTypePercentage= false;
        } else if (age < 1 || age > 999) {
          item.stream.sink
              .addError('The age must be a number between 1 and 999.');
          isValidFieldsTypePercentage = false;
        }
      } else {
        isValidFieldsTypePercentage = false;
      }
    }

    if (isValidFieldsTypeQualification && isValidFieldsTypeUniversity && isValidFieldsTypeYear && isValidFieldsTypePercentage) {
      isFormValid.value = true;
    } else {
      isFormValid.value = null;
    }
  }

  void submit() {
    print('Actions');
    /* for (var item in qualificationFields.value) {
      if (item.value != null) {
        final qualification=item.value.toString();
        print('qualification  $qualification');
      }
    }

    for (var item in universityFields.value) {
      if (item.value != null) {
        final university = int.tryParse(item.value);
        print('university $university');
      }
    }
    for (var item in yearFields.value) {
      if (item.value != null) {
        final year = int.tryParse(item.value);
        print('year $year');
      }
    }
    for (var item in percentageFields.value) {
      if (item.value != null) {
        final percentage = int.tryParse(item.value);
        print('percentage $percentage');
      }
    }*/


  }

  void removeFields(int index) {
    print('qualification: ${qualificationFields.value[index].value}');
    print('university: ${universityFields.value[index].value}');
    print('year: ${yearFields.value[index].value}');
    print('percentage: ${percentageFields.value[index].value}');

    qualificationFields.removeAt(index);
    universityFields.removeAt(index);
    yearFields.removeAt(index);
    percentageFields.removeAt(index);

    if (index < qualificationFields.length) {
      print('Current qualification at the same index: ${qualificationFields.value[index].value}');
      print('Current university at the same index: ${universityFields.value[index].value}');
      print('Current year at the same index: ${yearFields.value[index].value}');
      print('Current percentage at the same index: ${percentageFields.value[index].value}');
    }
  }

  void dispose() {
    print('-------DynamicFields BLOC DISPOSE--------');

    for (var item in qualificationFields.value) {
      item.dispose();
    }
    qualificationFields.dispose();

    for (var item in universityFields.value) {
      item.dispose();
    }
    universityFields.dispose();

    for (var item in yearFields.value) {
      item.dispose();
    }
    yearFields.dispose();

    for (var item in percentageFields.value) {
      item.dispose();
    }
    percentageFields.dispose();

    isFormValid.dispose();
  }
}

final bloc = DynamicFieldsBloc();
