/// An abstract listener interface for handling file pick results.
abstract class PiccoloPickerListener {
  /// Handles the result of a file pick action.
  ///
  /// - [result]: The result of the file pick.
  ///   If [isList] is `true`, it will be a `List<String>` containing file paths.
  ///   Otherwise, it will be a single `String` representing the file path.
  /// - [isList]: A flag indicating whether the result is a list of file paths (`true`) or a single file path (`false`). Defaults to `false`.
  void onFilePicked(dynamic result, {bool isList = false});
}
