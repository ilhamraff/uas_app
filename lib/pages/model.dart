class Game {
  final String title;
  final String genre;
  final String platform;
  final String thumbnail;

  Game(
      {required this.title,
      required this.genre,
      required this.platform,
      required this.thumbnail});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      title: json['title'],
      genre: json['genre'],
      platform: json['platform'],
      thumbnail: json['thumbnail'],
    );
  }
}
