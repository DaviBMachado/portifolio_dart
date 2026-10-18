class TechItem {
  final String name;
  final String reason;

  TechItem({required this.name, required this.reason});

  factory TechItem.fromJson(Map<String, dynamic> json) => TechItem(
        name: json['name'] ?? '',
        reason: json['reason'] ?? '',
      );
}

class FeatureItem {
  final String icon;
  final String title;
  final String description;

  FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  factory FeatureItem.fromJson(Map<String, dynamic> json) => FeatureItem(
        icon: json['icon'] ?? 'star',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
      );
}

class ProjectModel {
  final String id;
  final String title;
  final String subtitle;
  final List<String> tags;
  final String date;
  final String githubUrl;
  final String deployUrl;
  final String mockupUrl;
  final String challenge;
  final String solution;
  final List<TechItem> technologies;
  final List<FeatureItem> features;
  final List<String> results;

  ProjectModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.tags,
    required this.date,
    required this.githubUrl,
    required this.deployUrl,
    required this.mockupUrl,
    required this.challenge,
    required this.solution,
    required this.technologies,
    required this.features,
    required this.results,
  });

  factory ProjectModel.fromLocalJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      date: json['date'] ?? '',
      githubUrl: json['githubUrl'] ?? '',
      deployUrl: json['deployUrl'] ?? '',
      mockupUrl: json['mockupUrl'] ?? '',
      challenge: json['challenge'] ?? '',
      solution: json['solution'] ?? '',
      technologies: (json['technologies'] as List? ?? [])
          .map((t) => TechItem.fromJson(t))
          .toList(),
      features: (json['features'] as List? ?? [])
          .map((f) => FeatureItem.fromJson(f))
          .toList(),
      results: List<String>.from(json['results'] ?? []),
    );
  }

  factory ProjectModel.fromGithubApi(Map<String, dynamic> repo) {
    final language = repo['language'] as String?;
    final updatedAt = repo['updated_at'] as String? ?? '';
    final yearMonth = updatedAt.length >= 7 ? updatedAt.substring(0, 7) : 'Recente';

    return ProjectModel(
      id: repo['name'] ?? '',
      title: repo['name'] ?? 'Projeto GitHub',
      subtitle: repo['description'] ?? 'Repositório público integrado via GitHub API.',
      tags: [
        if (language != null) language,
        ...(List<String>.from(repo['topics'] ?? [])),
      ],
      date: yearMonth,
      githubUrl: repo['html_url'] ?? '',
      deployUrl: (repo['homepage'] != null && repo['homepage'].toString().isNotEmpty)
          ? repo['homepage']
          : repo['html_url'] ?? '',
      mockupUrl:
          'https://opengraph.githubassets.com/1/${repo['full_name'] ?? ''}',
      challenge:
          'Desenvolver uma solução modular, limpa e de fácil manutenção seguindo boas práticas de engenharia de software.',
      solution:
          'Arquitetura estruturada em ${language ?? 'código moderno'} com versionamento contínuo no GitHub.',
      technologies: [
        if (language != null)
          TechItem(
            name: language,
            reason: 'Linguagem principal utilizada na construção do repositório.',
          ),
        TechItem(
          name: 'Git & GitHub',
          reason: 'Controle de versão, documentação e CI/CD.',
        ),
      ],
      features: [
        FeatureItem(
          icon: 'code',
          title: 'Código Aberto',
          description: 'Repositório público disponível para inspeção e colaboração.',
        ),
        FeatureItem(
          icon: 'star',
          title: '${repo['stargazers_count'] ?? 0} Stars',
          description: 'Relevância e engajamento no repositório do GitHub.',
        ),
        FeatureItem(
          icon: 'fork_right',
          title: '${repo['forks_count'] ?? 0} Forks',
          description: 'Ramificações e contribuições da comunidade.',
        ),
      ],
      results: [
        'Projeto versionado e documentado diretamente no GitHub.',
        'Integração automática com o portfólio em Flutter.',
      ],
    );
  }
}