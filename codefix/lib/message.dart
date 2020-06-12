import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';


String username = 'codefixapp@gmail.com';
String password = 'codefix2019';

void sendPin(String recipientEmail,String pin) async {

  final smtpServer = gmail(username, password);

  final message = Message()
    ..from = Address(username, 'Gary Roberts(Founder of CodeFix)')
    ..recipients.add(recipientEmail)
    ..subject = 'Verify your CodeFix account. Thanks for joining us 😀'
    ..text = 'Activation pin for CodeFix: '+pin+'</p>';
    //..html = "<h1>Acitivate now !!!</h1>\n<p>Activation pin for CodeFix: "+pin.toString()+"</p>";

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
 
  var connection = PersistentConnection(smtpServer);

  await connection.send(message);

  await connection.close();
  
}


void sendRecovery(String recipientEmail) async {

  final smtpServer = gmail(username, password);

  final message = Message()
    ..from = Address(username, 'Gary Roberts(Founder of CodeFix)')
    ..recipients.add(recipientEmail)
    ..subject = 'Recover your account now'
    ..text = 'Recovery password for CodeFix: '+getPassword(recipientEmail)+'</p>';
    //..html = "<h1>Acitivate now !!!</h1>\n<p>Activation pin for CodeFix: "+pin.toString()+"</p>";

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
 
  var connection = PersistentConnection(smtpServer);

  await connection.send(message);

  await connection.close();
  
}



String getPassword(String email){
  final db = Firestore.instance;
  var tempPassword="";

db.collection('student').snapshots().listen((data) =>data.documents.forEach((doc) {
     if(doc.data['email']==email)
        {
          tempPassword=doc.data['resetKey'];
        } 
    } 
    )
  );

    return "recover"+tempPassword;
}


 /*_sendEmail() async {
    final String _email = 'mailto:' +
        "garyroberts1995@gmail.com" +
        '?subject=' +
        "Email verification" +
        '&body=' +
        "Your verification code is 363344";
    try {
      await launch(_email);
    } catch (e) {
      //throw 'Could not Call Phone';
      toast("Verification not sent");
    }
  }  */