
class NewsArticle {
  final String pid;
  final String postId;
  final String title;
  final String uTitle;
  final String category;
  final String content;
  final String uContent;
  final String images;
  final String postDate;
  final String createdAt;
  final String updatedAt;

  NewsArticle({
    required this.pid,
    required this.postId,
    required this.title,
    required this.uTitle,
    required this.category,
    required this.content,
    required this.uContent,
    required this.images,
    required this.postDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      pid: json['pid'] ?? '',
      postId: json['post_id'] ?? '',
      title: json['title'] ?? '',
      uTitle: json['u_title'] ?? '',
      category: json['category'] ?? '',
      content: json['content'] ?? '',
      uContent: json['u_content'] ?? '',
      images: json['images'] ?? '',
      postDate: json['post_date'] ?? '',
      createdAt: json['p_create'] ?? '',
      updatedAt: json['update_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pid': pid,
      'post_id': postId,
      'title': title,
      'u_title': uTitle,
      'category': category,
      'content': content,
      'u_content': uContent,
      'images': images,
      'post_date': postDate,
      'p_create': createdAt,
      'update_at': updatedAt,
    };
  }
}
