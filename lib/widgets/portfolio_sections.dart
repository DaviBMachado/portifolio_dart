import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/project_model.dart';
import 'responsive_layout.dart';

Future<void> _openUrl(String url) async {
  if (url.isEmpty) return;
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _SectionContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _SectionContainer({
    required this.child,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: child,
    );
  }
}

// 1. Highlight Card Section (Hero do Projeto)
class HighlightCardSection extends StatelessWidget {
  final ProjectModel project;

  const HighlightCardSection({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return _SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ...project.tags.map(
                (tag) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0x331F6FEB),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0x6658A6FF)),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      color: Color(0xFF58A6FF),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              if (project.date.isNotEmpty)
                Text(
                  '• ${project.date}',
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            project.title,
            style: TextStyle(
              fontSize: isMobile ? 24 : 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            project.subtitle,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton.icon(
                onPressed: () => _openUrl(project.deployUrl),
                icon: const Icon(Icons.rocket_launch, size: 18),
                label: const Text('Ver Projeto / Deploy'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF238636),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => _openUrl(project.githubUrl),
                icon: const Icon(Icons.code, size: 18),
                label: const Text('Repositório GitHub'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF58A6FF),
                  side: const BorderSide(color: Color(0xFF30363D)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 2. Mockup Section
class MockupSection extends StatelessWidget {
  final String imageUrl;

  const MockupSection({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return _SectionContainer(
      padding: const EdgeInsets.all(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AspectRatio(
          aspectRatio: isMobile ? 16 / 10 : 16 / 9,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFF0D1117),
                alignment: Alignment.center,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_outlined, size: 48, color: Colors.white38),
                    SizedBox(height: 8),
                    Text(
                      'Preview do Projeto',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// 3. Problem & Solution Section
class ProblemSolutionSection extends StatelessWidget {
  final String challenge;
  final String solution;

  const ProblemSolutionSection({
    super.key,
    required this.challenge,
    required this.solution,
  });

  @override
  Widget build(BuildContext context) {
    final challengeCard = _SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFD29922)),
              SizedBox(width: 8),
              Text(
                'O Desafio',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            challenge,
            style: const TextStyle(color: Colors.white70, height: 1.5, fontSize: 15),
          ),
        ],
      ),
    );

    final solutionCard = _SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Color(0xFF3FB950)),
              SizedBox(width: 8),
              Text(
                'A Solução',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            solution,
            style: const TextStyle(color: Colors.white70, height: 1.5, fontSize: 15),
          ),
        ],
      ),
    );

    return ResponsiveLayout(
      mobile: Column(
        children: [
          challengeCard,
          const SizedBox(height: 16),
          solutionCard,
        ],
      ),
      desktop: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: challengeCard),
          const SizedBox(width: 24),
          Expanded(child: solutionCard),
        ],
      ),
    );
  }
}

// 4. Tech & Architecture Section
class TechArchitectureSection extends StatelessWidget {
  final List<TechItem> technologies;

  const TechArchitectureSection({super.key, required this.technologies});

  @override
  Widget build(BuildContext context) {
    return _SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.layers_outlined, color: Color(0xFF58A6FF)),
              SizedBox(width: 8),
              Text(
                'Arquitetura & Tecnologias',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...technologies.map(
            (tech) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1117),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF30363D)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle_outline, color: Color(0xFF58A6FF), size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 15, height: 1.4),
                          children: [
                            TextSpan(
                              text: '${tech.name}: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: tech.reason,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 5. Features Section
class FeaturesSection extends StatelessWidget {
  final List<FeatureItem> features;

  const FeaturesSection({super.key, required this.features});

  IconData _mapIcon(String iconName) {
    switch (iconName) {
      case 'palette':
        return Icons.palette_outlined;
      case 'bar_chart':
        return Icons.bar_chart_rounded;
      case 'lock':
        return Icons.lock_outline;
      case 'code':
        return Icons.code_rounded;
      case 'star':
        return Icons.star_border_rounded;
      case 'fork_right':
        return Icons.fork_right_rounded;
      default:
        return Icons.auto_awesome_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Funcionalidades em Destaque',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        isMobile
            ? Column(
                children: features
                    .map(
                      (f) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildFeatureCard(f),
                      ),
                    )
                    .toList(),
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: features
                    .map(
                      (f) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: _buildFeatureCard(f),
                        ),
                      ),
                    )
                    .toList(),
              ),
      ],
    );
  }

  Widget _buildFeatureCard(FeatureItem feature) {
    return _SectionContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_mapIcon(feature.icon), color: const Color(0xFF58A6FF), size: 28),
          const SizedBox(height: 12),
          Text(
            feature.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            feature.description,
            style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }
}

// 6. Results & Learnings Section
class ResultsSection extends StatelessWidget {
  final List<String> results;

  const ResultsSection({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return _SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.trending_up_rounded, color: Color(0xFF3FB950)),
              SizedBox(width: 8),
              Text(
                'Resultados & Aprendizados',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...results.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(color: Color(0xFF3FB950), fontSize: 18)),
                  Expanded(
                    child: Text(
                      r,
                      style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 7. Call To Action (Footer) Section
class CallToActionSection extends StatelessWidget {
  final String email;
  final String linkedinUrl;

  const CallToActionSection({
    super.key,
    required this.email,
    required this.linkedinUrl,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionContainer(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        children: [
          const Text(
            'Gostou do que viu? Vamos conversar!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Estou disponível para novos projetos, oportunidades e colaborações.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => _openUrl('mailto:$email'),
                icon: const Icon(Icons.email_outlined, size: 18),
                label: const Text('Enviar E-mail'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F6FEB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => _openUrl(linkedinUrl),
                icon: const Icon(Icons.open_in_new, size: 18),
                label: const Text('LinkedIn'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFF30363D)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
