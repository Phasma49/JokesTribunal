bool isValidFirebaseUserId(String userId) {
  // Expression régulière pour vérifier si la chaîne correspond au format attendu
  RegExp regex = RegExp(r'^[a-zA-Z0-9_-]{28}$');
  return regex.hasMatch(userId);
}
