import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:http/http.dart' as http;

void main() {
  final graphQLService = GraphQLService();
  graphQLService.init();
  runApp(MaterialApp(home: BlogsScreen(graphQLService: graphQLService)));
}

class BlogsScreen extends StatelessWidget {
  final GraphQLService graphQLService;

  const BlogsScreen({super.key, required this.graphQLService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blogs')),
      body: FutureBuilder<List<dynamic>>(
        future: graphQLService.fetchBlogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          }

          final blogs = snapshot.data ?? [];
          return ListView.builder(
            itemCount: blogs.length,
            itemBuilder: (context, index) {
              final blog = blogs[index];
              return Card(
                child: ListTile(
                  leading: blog['featured_image'] != null && blog['featured_image'].isNotEmpty
                      ? Image.network(blog['featured_image'], width: 100, height: 100)
                      : const SizedBox(width: 100, height: 100), // Placeholder in case of no image
                  title: Text(blog['title']),
                  subtitle: Text(blog['short_content']),
                  trailing: Text(blog['creation_time']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class GraphQLService {
  late GraphQLClient client;

  void init() {
    final HttpLink httpLink = HttpLink(
      'https://backend.almasrypharmacy.com/graphql',
      httpClient: http.Client(),
    );

    client = GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(),
    );
  }

  Future<List<dynamic>> fetchBlogs() async {
    const String query = r'''
    query GetBlogData {
      blogPosts {
        items {
          creation_time
          featured_image
          title
          short_content
        }
      }
    }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(query),
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return result.data?['blogPosts']['items'] as List<dynamic>;
  }
}
