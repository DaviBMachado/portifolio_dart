import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MeuPortfolioApp());
}

class MeuPortfolioApp extends StatelessWidget {
  const MeuPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfólio - Estudo de Caso',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const PaginaProjeto(),
    );
  }
}

class PaginaProjeto extends StatelessWidget {
  const PaginaProjeto({super.key});

  Future<Map<String, dynamic>> carregarDadosProjeto() async { 
    await Future.delayed(const Duration(seconds: 1));
    final String resposta = await rootBundle.loadString('assets/projeto.json');
    return jsonDecode(resposta);
  }

  Widget _buildSecaoTitulo(String titulo, IconData icone) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        Icon(icone, size: 28, color: Colors.black87),
        const SizedBox(width: 12),
        Expanded( // <-- Envolver o Text com o Expanded
          child: Text(
            titulo,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTechItem(String tech, String motivo, IconData icone, Color cor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icone, color: cor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tech,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  motivo,
                  style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String titulo, String desc, IconData icone, Color cor) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, size: 32, color: cor),
          const SizedBox(height: 16),
          Text(
            titulo,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: TextStyle(color: Colors.grey.shade600, height: 1.4),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            'LOGO / NOME',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Projetos', style: TextStyle(color: Colors.black87)),
          ),
          const SizedBox(width: 10),
          TextButton(
            onPressed: () {},
            child: const Text('Sobre', style: TextStyle(color: Colors.black87)),
          ),
          const SizedBox(width: 10),
          TextButton(
            onPressed: () {},
            child: const Text('Contato', style: TextStyle(color: Colors.black87)),
          ),
          const SizedBox(width: 30),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: carregarDadosProjeto(),
        builder: (context, snapshot) {
          // --- ESTADOS DO FUTUREBUILDER ---

          // 1. A Aguardar os Dados (Loading)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            );
          }

          // 2. Erro no Carregamento
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      'Erro ao carregar dados do projeto:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3. Sem dados
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Nenhum dado encontrado.'));
          }

          // 4. Sucesso! Dados carregados
          final dados = snapshot.data!;

          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- ETAPA 2 (Agora Dinâmica) ---
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: (dados['tags'] as List).map((tag) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.blue.withOpacity(0.3)),
                            ),
                            child: Text(
                              tag.toString(),
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          )).toList(),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        dados['titulo'], // Dado vindo do JSON
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, height: 1.2),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        dados['resumo'], // Dado vindo do JSON
                        style: TextStyle(fontSize: 18, color: Colors.grey.shade700, height: 1.5),
                      ),
                      const SizedBox(height: 32),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.code),
                            label: const Text('Ver Código no GitHub'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              foregroundColor: Colors.black87,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.auto_awesome),
                            label: const Text('Acessar Deploy em Produção'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 56),
                      Container(
                        width: double.infinity,
                        height: 450,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.grey.shade300),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_outlined, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text('Imagem/GIF ou Vídeo demonstrativo da interface', style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 80),

                      // --- ETAPA 3 ---
                      _buildSecaoTitulo('O Problema e a Solução', Icons.lightbulb_outline),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.red.shade100)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
                                const SizedBox(width: 8),
                                Text('O Desafio', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade900, fontSize: 18)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text('Lojistas precisavam monitorar vendas sem atualizar a página manualmente...', style: TextStyle(color: Colors.red.shade900, height: 1.5)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.green.shade100)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.check_circle_outline, color: Colors.green.shade700),
                                const SizedBox(width: 8),
                                Text('A Solução', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900, fontSize: 18)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text('Criação de um pipeline de dados com WebSockets e renderização otimizada...', style: TextStyle(color: Colors.green.shade900, height: 1.5)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 80),
                      _buildSecaoTitulo('Arquitetura e Tecnologias', Icons.architecture),
                      const SizedBox(height: 32),
                      _buildTechItem('React.js', 'Escolhido pela componentização e facilidade em lidar com atualizações de estado complexas na UI.', Icons.javascript, Colors.blue),
                      _buildTechItem('Node.js & WebSockets', 'Backend não bloqueante para gerenciar milhares de conexões persistentes recebendo dados em tempo real.', Icons.dns, Colors.green),
                      _buildTechItem('Tailwind CSS', 'Agilidade na estilização e facilidade em manter um design system consistente e responsivo.', Icons.color_lens, Colors.teal),
                      const SizedBox(height: 80),

                      // --- ETAPA 4: FEATURES ---
                      _buildSecaoTitulo('Características Principais', Icons.bolt),
                      const SizedBox(height: 32),
                      Wrap(
                        spacing: 24,
                        runSpacing: 24,
                        children: [
                          _buildFeatureCard('UI/UX Responsivo', 'Se adapta a qualquer tamanho de tela com perfeição.', Icons.devices, Colors.purple),
                          _buildFeatureCard('Gráficos Dinâmicos', 'Atualização a cada 500ms usando ApexCharts.', Icons.bar_chart, Colors.orange),
                          _buildFeatureCard('Autenticação Segura', 'Proteção de rotas com JWT e controle de sessão.', Icons.lock_outline, Colors.blueGrey),
                        ],
                      ),
                      const SizedBox(height: 80),

                      // --- ETAPA 4: RESULTADOS ---
                      _buildSecaoTitulo('Resultados e Lições Aprendidas', Icons.trending_up),
                      const SizedBox(height: 32),
                      ListTile(
                        leading: const Icon(Icons.speed, color: Colors.blueAccent),
                        title: const Text('Desempenho Otimizado', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Redução de 40% no tempo de carregamento inicial (LCP).'),
                        contentPadding: EdgeInsets.zero,
                      ),
                      ListTile(
                        leading: const Icon(Icons.school_outlined, color: Colors.blueAccent),
                        title: const Text('Aprendizado Técnico', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Implementação profunda de gerenciamento de estado global e websockets.'),
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 80),

                      // --- ETAPA 4: FOOTER / CTA ---
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade900,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Vamos trabalhar juntos?',
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Gostou do projeto? Estou disponível para novos desafios e contratos.',
                              style: TextStyle(fontSize: 16, color: Colors.blue.shade100),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              alignment: WrapAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.email_outlined),
                                  label: const Text('Enviar Mensagem'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.blue.shade900,
                                  ),
                                ),
                                OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.link),
                                  label: const Text('Conectar no LinkedIn'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}