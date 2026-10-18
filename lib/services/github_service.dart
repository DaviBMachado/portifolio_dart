import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/project_model.dart';

class GithubService {
  final String username;

  GithubService({required this.username});

  Future<List<ProjectModel>> loadAllProjects() async {
    final List<ProjectModel> projects = [];

    // 1. Carrega os estudos de caso detalhados do JSON local
    try {
      final rawJson = await rootBundle.loadString('assets/projeto.json');
      final List<dynamic> localList = jsonDecode(rawJson);
      projects.addAll(localList.map((e) => ProjectModel.fromLocalJson(e)));
    } catch (_) {}

    // 2. Busca repositórios públicos diretamente da API do GitHub
    try {
      final uri = Uri.parse(
        'https://api.github.com/users/$username/repos?sort=updated&per_page=8',
      );
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> repos = jsonDecode(response.body);
        for (final repo in repos) {
          if (repo['fork'] == true) continue;
          final ghProject = ProjectModel.fromGithubApi(repo);
          final alreadyExists = projects.any(
            (p) => p.id.toLowerCase() == ghProject.id.toLowerCase(),
          );
          if (!alreadyExists) {
            projects.add(ghProject);
          }
        }
      }
    } catch (_) {}

    return projects;
  }
}