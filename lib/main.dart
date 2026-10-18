import 'package:flutter/material.dart';
import 'models/project_model.dart';
import 'services/github_service.dart';
import 'widgets/portfolio_sections.dart';
import 'widgets/responsive_layout.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Davi Bernardes | Portfólio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF58A6FF),
          surface: Color(0xFF161B22),
        ),
      ),
      home: const PortfolioHomePage(),
    );
  }
}

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  // Altere para o seu username exato do GitHub:
  final GithubService _githubService = GithubService(username: 'DaviBMachado');
  final ScrollController _scrollController = ScrollController();

  List<ProjectModel> _projects = [];
  int _selectedIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  Future<void> _fetchProjects() async {
    final list = await _githubService.loadAllProjects();
    if (mounted) {
      setState(() {
        _projects = list;
        _isLoading = false;
      });
    }
  }

  void _scrollTo(double offset) {
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        elevation: 0,
        title: const Text(
          '<Davi.Dev />',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        actions: isMobile
            ? null
            : [
                TextButton(
                  onPressed: () => _scrollTo(0),
                  child: const Text('Projetos', style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () => _scrollTo(600),
                  child: const Text('Sobre', style: TextStyle(color: Colors.white)),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: TextButton(
                    onPressed: () => _scrollTo(1400),
                    child: const Text('Contato', style: TextStyle(color: Color(0xFF58A6FF))),
                  ),
                ),
              ],
      ),
      drawer: isMobile
          ? Drawer(
              backgroundColor: const Color(0xFF161B22),
              child: ListView(
                children: [
                  const DrawerHeader(
                    child: Center(
                      child: Text(
                        '<Davi.Dev />',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.folder_open),
                    title: const Text('Projetos'),
                    onTap: () {
                      Navigator.pop(context);
                      _scrollTo(0);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.architecture),
                    title: const Text('Sobre / Arquitetura'),
                    onTap: () {
                      Navigator.pop(context);
                      _scrollTo(500);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.mail_outline),
                    title: const Text('Contato'),
                    onTap: () {
                      Navigator.pop(context);
                      _scrollTo(1200);
                    },
                  ),
                ],
              ),
            )
          : null,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _projects.isEmpty
              ? const Center(child: Text('Nenhum projeto encontrado.'))
              : SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 48,
                    vertical: 24,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Seletor horizontal de projetos (GitHub + Local)
                          const Text(
                            'Selecione um Projeto do GitHub:',
                            style: TextStyle(color: Colors.white60, fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 42,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _projects.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final proj = _projects[index];
                                final selected = index == _selectedIndex;
                                return ChoiceChip(
                                  label: Text(proj.id),
                                  selected: selected,
                                  onSelected: (_) => setState(() => _selectedIndex = index),
                                  selectedColor: const Color(0xFF1F6FEB),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Seções do Wireframe
                          HighlightCardSection(project: _projects[_selectedIndex]),
                          const SizedBox(height: 24),
                          MockupSection(imageUrl: _projects[_selectedIndex].mockupUrl),
                          const SizedBox(height: 24),
                          ProblemSolutionSection(
                            challenge: _projects[_selectedIndex].challenge,
                            solution: _projects[_selectedIndex].solution,
                          ),
                          const SizedBox(height: 24),
                          TechArchitectureSection(
                            technologies: _projects[_selectedIndex].technologies,
                          ),
                          const SizedBox(height: 24),
                          FeaturesSection(
                            features: _projects[_selectedIndex].features,
                          ),
                          const SizedBox(height: 24),
                          ResultsSection(
                            results: _projects[_selectedIndex].results,
                          ),
                          const SizedBox(height: 32),
                          const CallToActionSection(
                            email: 'davibernardes021@gmail.com',
                            linkedinUrl: 'https://www.linkedin.com/in/davibmachado/?isSelfProfile=true',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}