class ReadingState {
  final bool isLoading;
  final String? error;
  final String? text;

  ReadingState._({this.isLoading = false, this.error, this.text});

  factory ReadingState.loading() => ReadingState._(isLoading: true);
  factory ReadingState.loaded(String text) => ReadingState._(text: text);
  factory ReadingState.error(String error) => ReadingState._(error: error);
}
