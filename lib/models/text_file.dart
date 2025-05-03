class TextFile {
  final String id;
  final String mainTopic;
  final String subtopic;
  final String title;
  final String author;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;

  TextFile({
    required this.id,
    required this.mainTopic,
    required this.subtopic,
    required this.title,
    required this.author,
    required this.content,
    required this.createdAt,
    this.updatedAt,
  });

  // Add this factory method
  factory TextFile.fromMap(Map<String, dynamic> map) {
    return TextFile(
      id: map['id'] ?? '',
      mainTopic: map['mainTopic'] ?? '',
      subtopic: map['subtopic'] ?? '',
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      content: map['content'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  // Add this method for serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mainTopic': mainTopic,
      'subtopic': subtopic,
      'title': title,
      'author': author,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'TextFile{id: $id, title: $title, author: $author, content: $content, mainTopic: $mainTopic, subtopic: $subtopic, createdAt: $createdAt}';
  }
}
