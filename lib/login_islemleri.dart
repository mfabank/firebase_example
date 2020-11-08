import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


FirebaseAuth _auth = FirebaseAuth.instance;

class LoginIslemleri extends StatefulWidget {
  @override
  _LoginIslemleriState createState() => _LoginIslemleriState();
}

class _LoginIslemleriState extends State<LoginIslemleri> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth.authStateChanges().listen((User user) {
      if (user == null) {
        print('Kullanıcı oturumu kapattı');
      } else {
        print('Kullanıcı oturum açtı!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login İşlemleri"),
      ),
      body: Center(
        child: Column(
          children: [
            RaisedButton(
              child: Text("Email-Şifre Oluştur"),
              color: Colors.blueAccent,
              onPressed: _emailSifreKullaniciOlustur,
            ),
            RaisedButton(
              child: Text("Email-Şifre Giriş"),
              color: Colors.greenAccent,
              onPressed: _emailSifreKullaniciGirisYap,
            ),
            RaisedButton(
              child: Text("Şifremi Unuttum"),
              color: Colors.deepPurple,
              onPressed: _resetPassword,
            ),
            RaisedButton(
              child: Text("Şifremi Güncelle"),
              color: Colors.pinkAccent,
              onPressed: _updatePassword,
            ),
            RaisedButton(
              child: Text("Email Güncelle"),
              color: Colors.teal,
              onPressed: _updateEmail,
            ),
            RaisedButton(
              child: Image.network("https://img-authors.flaticon.com/google.jpg",width: 40,height: 40,),
              color: Colors.teal,
              onPressed: _signInWithGoogle,
            ),
            RaisedButton(
              child: Text("Çıkış Yap"),
              color: Colors.red,
              onPressed: _cikisYap,
            ),
          ],
        ),
      ),
    );
  }

  void _emailSifreKullaniciOlustur() async {
    String _email = "muhammedfatihaktass@gmail.com";
    String _password = "123456";

    try {
      UserCredential _credential = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      User _yeniUser = _credential.user;
      await _yeniUser.sendEmailVerification();
      if (_auth.currentUser != null) {
        debugPrint("Lütfen mail adresinizi onaylayın.");
        _auth.signOut();
        debugPrint("Kullanıcı sistemden atılıyor.");
      }
      debugPrint(_yeniUser.toString());
    } catch (e) {
      debugPrint("***************************OPS**********************");
      debugPrint(e.toString());
    }
  }

  void _emailSifreKullaniciGirisYap() async {
    String _email = "muhammedfatihaktass@gmail.com";
    String _password = "123456";
    try {
      if (_auth.currentUser == null) {
        User _oturumAcanUser = (await _auth.signInWithEmailAndPassword(
            email: _email, password: _password)).user;

        if(_oturumAcanUser.emailVerified){
          debugPrint("Ana sayfaya yönlendiriliyorsunuz..");
        }
        else{
          debugPrint("Lütfen mail adresinizi onaylayın");
          _auth.signOut();
        }

      } else {
        debugPrint("Şu an zaten giriş yapılmış");
      }
    } catch (e) {
      debugPrint("***************************OPS**********************");
      debugPrint(e.toString());
    }
  }

  void _cikisYap() async {
    if (_auth.currentUser != null) {
      await _auth.signOut();
    } else {
      debugPrint("Zaten oturum açılmamış.");
    }
  }

  void _resetPassword() async{
    String _email = "muhammedfatihaktass@gmail.com";
    try {
      await _auth.sendPasswordResetEmail(email: _email);
      debugPrint("Mail gönderildi");
    }
    catch(e) {
      debugPrint("Şifre Sıfırlama Hatası");
    }
  }

  void _updatePassword() async{
    try {
     await _auth.currentUser.updatePassword("123456");
      debugPrint("Şifreniz Güncellendi");

    }
    catch(e) {

      try{
        String email = "muhammedfatihaktass@gmail.com";
        String password = "123456";

        EmailAuthCredential credential =
        EmailAuthProvider.credential(email: (email), password: password);
        await FirebaseAuth.instance.currentUser.reauthenticateWithCredential(credential);
        await _auth.currentUser.updatePassword("password2");
      }
      catch(e){
        debugPrint("Hata Çıktı");
      }

      debugPrint("Hatalı İşlem !!! : $e");
    }
  }

  void _updateEmail() async{
    try {
      await _auth.currentUser.updateEmail("fatih@fatih.com");
      debugPrint("Email Güncellendi");

    }
    catch(e) {

      try{
        String email = "muhammedfatihaktass@gmail.com";
        String password = "password2";

        EmailAuthCredential credential =
        EmailAuthProvider.credential(email: (email), password: password);
        await FirebaseAuth.instance.currentUser.reauthenticateWithCredential(credential);
        await _auth.currentUser.updateEmail("fatih@fatih.com");
      }
      catch(e){
        debugPrint("Hata Çıktı");
      }

      debugPrint("Hatalı İşlem !!! : $e");
    }
  }

  Future<UserCredential> _signInWithGoogle() async{
    try {

      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await _auth.signInWithCredential(credential);

    }
    catch(e) {
      debugPrint("Hata var! $e");
    }
  }
}
 