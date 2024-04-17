

// import 'package:flutter/material.dart';
// import 'package:graphql/client.dart';

// void main() {
//   runApp(MaterialApp(
//     home: BlogsScreen(client: GraphQLConfiguration.initializeClient().value),
//   ));
// }



// class GraphQLConfiguration {
//   static HttpLink httpLink = HttpLink(
//     'https://backend.almasrypharmacy.com/graphql',
//   );

//   static ValueNotifier<GraphQLClient> initializeClient() {
//     GraphQLClient client = GraphQLClient(
//       cache: GraphQLCache(),
//       link: httpLink,
//     );
//     return ValueNotifier<GraphQLClient>(client);
//   }
// }

// class GraphQLDataGetter {
//   final GraphQLClient client;

//   GraphQLDataGetter(this.client);

//   Future<List<dynamic>> getBlogPosts() async {
//     const String query = r'''
//     query GetBlogData {
//       blogPosts {
//         items {
//           creation_time
//           featured_image
//           title
//           short_content
//         }
//       }
//     }
//     ''';

//     final QueryOptions options = QueryOptions(
//       document: gql(query),
//     );

//     final QueryResult result = await client.query(options);

//     if (result.hasException) {
//       throw result.exception!;
//     }

//     return result.data?['blogPosts']['items'] as List<dynamic>;
//   }
// }


// class BlogsScreen extends StatelessWidget {
//   final GraphQLClient client;

//   const BlogsScreen({super.key, required this.client});

//   @override
//   Widget build(BuildContext context) {
//     final dataGetter = GraphQLDataGetter(client);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Blogs')),
//       body: FutureBuilder<List<dynamic>>(
//         future: dataGetter.getBlogPosts(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (snapshot.hasData) {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 var item = snapshot.data![index];
//                 return Card(
//                   child: ListTile(
//                     leading: item['featured_image'] != ''
//                         ? Image.network(item['featured_image'], width: 100, height: 100)
//                         : null,
//                     title: Text(item['title']),
//                     subtitle: Text(item['short_content']),
//                     trailing: Text(item['creation_time']),
//                   ),
//                 );
//               },
//             );
//           } else {
//             return const Center(child: Text("No blogs found"));
//           }
//         },
//       ),
//     );
//   }
// }
