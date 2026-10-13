/// Optional online backend (Firebase). The app works without it using local demo accounts;
/// see DEPLOYMENT.md "Add Firebase" to plug the Firebase version in.
abstract class CloudBackend {
  bool get loggedIn;
  String? get userName;
  Future<String?> signUp(String name, String id, String pw); // null = success, else English error key
  Future<String?> login(String id, String pw);
  Future<String?> googleSignIn(); // null = success, '' = cancelled
  Future<String?> resetPassword(String email);
  Future<void> logout();
  Future<Set<int>> loadFavourites();
  Future<void> setFavourite(int recipeId, bool on);
}
