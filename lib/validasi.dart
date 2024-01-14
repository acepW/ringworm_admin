import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ringworm_admin/constraints.dart';
import 'package:ringworm_admin/home.dart';
import 'package:ringworm_admin/login.dart';

class Validasi extends StatefulWidget {
  const Validasi({super.key});

  @override
  State<Validasi> createState() => _ValidasiState();
}

class _ValidasiState extends State<Validasi> {
  String? Role;
  User? user = FirebaseAuth.instance.currentUser;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    try {
      setState(() {
        loading = true;
      });
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('admin')
          .doc(user!.uid)
          .get();
      if (userDoc == null) {
        setState(() {
          loading = false;
          Role = "bukan-admin";
        });

        return;
      } else {
        Role = userDoc.get('role');
        setState(() {
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      setState(() {
        loading = false;
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Role == "admin"
      ? HomeScreens()
      : Scaffold(
          appBar: AppBar(
            title: Text(
              "Validasi Admin",
              style: GoogleFonts.rubik(
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500)),
            ),
            backgroundColor: kPrimaryColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Anda Tidak Memiliki Akses!!!",
                  style: GoogleFonts.rubik(
                      textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 24,
                ),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        minimumSize: Size.fromHeight(50)),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreens()),
                          (route) => false);
                    },
                    icon: Icon(
                      Icons.email,
                      size: 32,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Kembali Ke Login",
                      style: GoogleFonts.rubik(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w500)),
                    )),
              ],
            ),
          ),
        );
}
