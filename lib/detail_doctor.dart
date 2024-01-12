import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ringworm_admin/constraints.dart';
import 'package:ringworm_admin/widget/defaultTextField.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../global_methods.dart';

class DoctorDetail extends StatefulWidget {
  final String id;
  const DoctorDetail({super.key, required this.id});

  @override
  State<DoctorDetail> createState() => _DoctorDetailState();
}

class _DoctorDetailState extends State<DoctorDetail> {
  // final FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController noted = TextEditingController();
  bool _isLoading = false;
  String alamatLink = "";
  String alamat = "";
  String email = "";
  String img = "";
  String nama = "";
  String noHp = "";
  String sertifikat = "";
  String status = "";
  @override
  void initState() {
    getUserData();

    super.initState();
  }

  void getUserData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('akun')
          .doc(widget.id)
          .get();
      if (userDoc == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      } else {
        alamat = userDoc.get('alamat');
        alamatLink = userDoc.get('alamatLink');
        email = userDoc.get('email');
        img = userDoc.get('img');
        nama = userDoc.get('nama');
        noHp = userDoc.get('noHp');
        sertifikat = userDoc.get('sertifikat');
        status = userDoc.get('status');
        print("object");
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void aktifkanDoctor() async {
    try {
      await FirebaseFirestore.instance
          .collection('akun')
          .doc(widget.id)
          .update({'status': "active"});
      GlobalMethods.errorDialog(
          subtitle: "Berhasil di Aktifkan", context: context);
    } catch (err) {
      GlobalMethods.errorDialog(subtitle: err.toString(), context: context);
    }
  }

  void nonAktifkanDoctor() async {
    try {
      await FirebaseFirestore.instance
          .collection('akun')
          .doc(widget.id)
          .update({
        'status': "non-active",
      });
      GlobalMethods.errorDialog(
          subtitle: "Berhasil di Non Aktifkan", context: context);
    } catch (err) {
      GlobalMethods.errorDialog(subtitle: err.toString(), context: context);
    }
  }

  void tolakDoctor() async {
    try {
      if (_formKey.currentState!.validate()) {
        await FirebaseFirestore.instance
            .collection('akun')
            .doc(widget.id)
            .update({'status': "ditolak", 'note': noted.text});
        GlobalMethods.errorDialog(
            subtitle: "Berhasil di Tolak", context: context);
      }
    } catch (err) {
      GlobalMethods.errorDialog(subtitle: err.toString(), context: context);
    }
  }

  Future<void> _launchUrl() async {
    final Uri _url = Uri.parse(alamatLink);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text("Profil Doctor",
            style: GoogleFonts.rubik(
                textStyle: const TextStyle(
                    color: kPrimaryLightColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w500))),
      ),
      body: SingleChildScrollView(
          child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                color: kPrimaryColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    img != ""
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(img),
                          )
                        : CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                'https://i.stack.imgur.com/l60Hf.png'),
                          ),
                  ],
                )),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nama",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: kPrimaryColor, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            nama,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Email",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: kPrimaryColor, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            email,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "No Hp",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: kPrimaryColor, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            noHp,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Alamat Rumah Sakit",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: kPrimaryColor, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            alamat,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: _launchUrl,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          "Lihat di Google Maps",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Sertifikat",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  sertifikat != ""
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(sertifikat),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(5),
                              border:
                                  Border.all(color: kPrimaryColor, width: 1)),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border:
                                  Border.all(color: kPrimaryColor, width: 1)),
                          child: Center(
                            child: Text("Tidak Ada Image"),
                          ),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        status != "active" && status != "ditolak"
                            ? Expanded(
                                child: InkWell(
                                  onTap: () {
                                    aktifkanDoctor();
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                      child: Text(
                                        "Aktifkan",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(
                          width: 10,
                        ),
                        status == "non-active"
                            ? Expanded(
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Form(
                                              key: _formKey,
                                              child: DefaultTextFild(
                                                label: "Note",
                                                controller: noted,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "Please enter a valid value";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                hintText: "Note",
                                                keyboardType:
                                                    TextInputType.text,
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  if (Navigator.canPop(
                                                      context)) {
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                child: Text(
                                                  "Cancle",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 18),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  tolakDoctor();
                                                  if (Navigator.canPop(
                                                      context)) {
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                child: Text(
                                                  "Oke",
                                                  style: TextStyle(
                                                      color: Colors.cyan,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                      child: Text(
                                        "Tolak",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : status == "active"
                                ? Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        nonAktifkanDoctor();
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Center(
                                          child: Text(
                                            "Non Aktifkan",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container()
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
