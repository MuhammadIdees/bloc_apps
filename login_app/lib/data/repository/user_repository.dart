import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
    : _firebaseAuth = firebaseAuth?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn?? GoogleSignIn();

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser();
  }

  Future<void> signInWithCredentials({String email, String password}) =>
    _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

  Future<void> signUp({String email, String password}) async =>
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  
  Future<void> signOut() async =>
    await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut(),]);

  Future<bool> isSignedIn() async =>
    await _firebaseAuth.currentUser() != null;

  Future<String> getUser() async =>
    (await _firebaseAuth.currentUser()).email;
}