import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';
import '../utils/app_config.dart';

class GraphQLService {
  static GraphQLClient? _client;
  
  /// Initialize the GraphQL client
  static Future<void> init() async {
    // Initialize Hive for cache
    await initHiveForFlutter();
    
    // Create an HTTP link to the GraphQL endpoint
    final HttpLink httpLink = HttpLink(AppConfig.graphqlEndpoint);
    
    // Create a cache for caching query results
    final store = await HiveStore.open(boxName: 'graphql');
    final cache = GraphQLCache(store: store);
    
    // Create the GraphQL client
    _client = GraphQLClient(
      link: httpLink,
      cache: cache,
      defaultPolicies: DefaultPolicies(
        query: Policies(
          fetch: FetchPolicy.cacheAndNetwork,
          error: ErrorPolicy.all,
        ),
        mutate: Policies(
          fetch: FetchPolicy.networkOnly,
          error: ErrorPolicy.all,
        ),
        subscribe: Policies(
          fetch: FetchPolicy.cacheAndNetwork,
          error: ErrorPolicy.all,
        ),
      ),
    );
  }
  
  /// Get the GraphQL client instance
  static GraphQLClient get client {
    if (_client == null) {
      throw Exception('GraphQL client not initialized. Call GraphQLService.init() first.');
    }
    return _client!;
  }
  
  /// Create a GraphQL provider for the widget tree
  static Widget wrapWithClient({required Widget child}) {
    return GraphQLProvider(
      client: ValueNotifier(client),
      child: child,
    );
  }
  
  /// Execute a GraphQL query
  static Future<QueryResult> query(String queryString, {Map<String, dynamic>? variables}) async {
    final options = QueryOptions(
      document: gql(queryString),
      variables: variables ?? {},
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );
    
    return await client.query(options);
  }
  
  /// Execute a GraphQL mutation
  static Future<QueryResult> mutate(String mutationString, {Map<String, dynamic>? variables}) async {
    final options = MutationOptions(
      document: gql(mutationString),
      variables: variables ?? {},
      fetchPolicy: FetchPolicy.networkOnly,
    );
    
    return await client.mutate(options);
  }
  
  /// Clear the GraphQL cache
  static Future<void> clearCache() async {
    await client.cache.store.reset();
  }
}