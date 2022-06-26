import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/views/login_view.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'impNotes',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              //final user = FirebaseAuth.instance.currentUser;
              //print(user);
              //if (user?.emailVerified ?? false) {
              //  print("you're a verified user");
              //  return const Center(child: Text('Done'));
              //} else {
              //  print("You need to verify your email first");
              //  return const VerfifyEmailView();
              //}
              return const LoginView();
            default:
              return const Text('Loading...');
          }
        },
      ),
    );
  }
}

class VerfifyEmailView extends StatefulWidget {
  const VerfifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerfifyEmailView> createState() => _VerfifyEmailViewState();
}

class _VerfifyEmailViewState extends State<VerfifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text("Please verify your email address:"),
          TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                print(user);
                await user?.sendEmailVerification();
              },
              child: const Text("Send email verification"))
        ],
      ),
    );
  }
}
