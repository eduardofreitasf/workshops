USE star_projetos;

-- ============================================================================
-- 1. Inserir Departamentos (6 Departamentos)
-- ============================================================================
INSERT INTO departamento (nome, sigla) VALUES
('Departamento de Projetos', 'DP'),
('Departamento Comercial & Vendas', 'DCOM'),
('Departamento de Marketing & Comunicação', 'DMARK'),
('Departamento de Recursos Humanos', 'DRH'),
('Departamento de Qualidade & Inovação', 'DQI'),
('Departamento Financeiro & Jurídico', 'DFIN');

-- ============================================================================
-- 2. Inserir Membros (20 Membros com diferentes cargos e departamentos)
-- Mantém a ordem exata dos IDs 1 a 7 para compatibilidade com queries e transações
-- ============================================================================
INSERT INTO membro (nome, email, cargo, departamento_id) VALUES
-- Membros base originais (IDs 1 a 7)
('Afonso Silva', 'afonso.silva@starjunior.pt', 'Presidente', 1),    -- ID 1 (Orientador elegível)
('Beatriz Costa', 'beatriz.costa@starjunior.pt', 'Diretor', 1),       -- ID 2 (Orientador elegível)
('Carlos Rocha', 'carlos.rocha@starjunior.pt', 'Diretor', 2),        -- ID 3 (Orientador elegível)
('Diana Lopes', 'diana.lopes@starjunior.pt', 'Membro', 1),           -- ID 4 (PM do Projeto 1)
('Eduardo Matos', 'eduardo.matos@starjunior.pt', 'Membro', 1),       -- ID 5 (PM do Projeto 2)
('Francisca Neves', 'francisca.neves@starjunior.pt', 'Membro', 3),   -- ID 6 (PM do Projeto 3)
('Gonçalo Ribeiro', 'goncalo.ribeiro@starjunior.pt', 'Membro', 4),   -- ID 7

-- Diretores adicionais (elegíveis para orientadores conforme regras de negócio)
('Inês Ferreira', 'ines.ferreira@starjunior.pt', 'Diretor', 3),      -- ID 8
('João Pires', 'joao.pires@starjunior.pt', 'Diretor', 4),          -- ID 9
('Leonor Antunes', 'leonor.antunes@starjunior.pt', 'Diretor', 5),    -- ID 10

-- Consultores Operacionais adicionais
('Hugo Martins', 'hugo.martins@starjunior.pt', 'Membro', 1),         -- ID 11
('Mariana Santos', 'mariana.santos@starjunior.pt', 'Membro', 2),     -- ID 12
('Pedro Oliveira', 'pedro.oliveira@starjunior.pt', 'Membro', 1),     -- ID 13
('Rita Carvalho', 'rita.carvalho@starjunior.pt', 'Membro', 3),       -- ID 14
('Tiago Sousa', 'tiago.sousa@starjunior.pt', 'Membro', 2),          -- ID 15
('Sofia Barbosa', 'sofia.barbosa@starjunior.pt', 'Membro', 5),       -- ID 16
('Vasco Teixeira', 'vasco.teixeira@starjunior.pt', 'Membro', 6),     -- ID 17
('Ana Guimarães', 'ana.guimaraes@starjunior.pt', 'Membro', 1),       -- ID 18
('Miguel Esteves', 'miguel.esteves@starjunior.pt', 'Membro', 6),     -- ID 19
-- Consultor recém-chegado sem projetos (ideal para demonstrar LEFT JOIN / contagem 0)
('Catarina Faria', 'catarina.faria@starjunior.pt', 'Membro', 4);     -- ID 20

-- ============================================================================
-- 3. Inserir Clientes (10 Clientes Empresariais)
-- ============================================================================
INSERT INTO cliente (nome_empresa, nif, email_contacto) VALUES
('Queijaria da Serra Lda', '509123456', 'contacto@queijariadaserra.pt'),
('InovTextil Covilhã S.A.', '501987654', 'geral@inovtextil.pt'),
('Turismo da Beira Alta', '503456789', 'info@turismobeira.pt'),
('SolarTech Renewables S.A.', '504112233', 'projetos@solartech.pt'),
('Quinta dos Sabores Gourmet', '508778899', 'geral@quintasabores.pt'),
('Clínica Médica Central', '502334455', 'administracao@clinicacentral.pt'),
('Logística & Distribuição Mondego', '505667788', 'operacoes@logmondego.pt'),
('AlphaByte Soluções Digitais', '507889900', 'comercial@alphabyte.pt'),
('Mobília & Design Vintage', '506443322', 'contacto@mobiliadesign.pt'),
('Cervejaria Artesanal Lusitana', '509998877', 'contacto@cervejalusitana.pt');

-- ============================================================================
-- 4. Inserir Projetos (10 Projetos cobrindo diversos orçamentos e estados)
-- ============================================================================
INSERT INTO projeto (nome, data_inicio, data_fim, orcamento, estado, cliente_id, pm_id, orientador_id) VALUES
-- Projetos base originais (IDs 1 a 3)
('Website E-commerce & Branding', '2026-03-01', '2026-09-01', 3200.00, 'Em Curso', 1, 4, 2),
('Otimização de Processos Têxteis', '2026-04-15', '2026-11-30', 5400.00, 'Em Curso', 2, 5, 2),
('Plano de Marketing Digital 2026', '2026-01-10', '2026-05-30', 1800.00, 'Concluído', 3, 6, 3),

-- Projetos adicionais em escala
('Plataforma IoT de Monitorização Solar', '2026-05-01', '2026-12-15', 8900.00, 'Em Curso', 4, 11, 1),
('Reestruturação de Identidade Visual', '2026-02-01', '2026-04-30', 2100.00, 'Concluído', 5, 14, 8),
('Sistema de Agendamento Clínico Web', '2026-06-01', '2027-01-30', 6700.00, 'Em Curso', 6, 13, 2),
('Auditoria Logística e Armazenagem', '2026-07-01', '2026-10-31', 4300.00, 'Em Planeamento', 7, 12, 3),
('App Mobile de Gestão de Encomendas', '2026-08-01', '2027-03-15', 12500.00, 'Em Planeamento', 8, 4, 10),
('Catálogo Interativo de Mobiliário', '2026-03-15', '2026-07-15', 2900.00, 'Concluído', 9, 6, 8),
('Expansão de E-commerce e CRM', '2026-04-01', '2026-08-01', 3800.00, 'Cancelado', 10, 15, 3);

-- ============================================================================
-- 5. Inserir Equipas de Projetos (Alocações N:M)
-- ============================================================================
INSERT INTO equipa_projeto (projeto_id, membro_id, data_alocacao, horas_semanais) VALUES
-- Projeto 1: Website E-commerce & Branding
(1, 4, '2026-03-01', 12),  -- Diana (PM)
(1, 6, '2026-03-05', 8),   -- Francisca
(1, 7, '2026-03-05', 6),   -- Gonçalo
(1, 18, '2026-03-10', 8),  -- Ana

-- Projeto 2: Otimização de Processos Têxteis
(2, 5, '2026-04-15', 15),  -- Eduardo (PM)
(2, 4, '2026-04-20', 10),  -- Diana
(2, 16, '2026-04-20', 8),  -- Sofia

-- Projeto 3: Plano de Marketing Digital 2026 (Concluído)
(3, 6, '2026-01-10', 10),  -- Francisca (PM)
(3, 14, '2026-01-15', 8),  -- Rita

-- Projeto 4: Plataforma IoT Solar
(4, 11, '2026-05-01', 14), -- Hugo (PM)
(4, 5, '2026-05-05', 10),  -- Eduardo
(4, 13, '2026-05-05', 10), -- Pedro
(4, 16, '2026-05-10', 6),  -- Sofia

-- Projeto 5: Reestruturação Identidade Visual (Concluído)
(5, 14, '2026-02-01', 12), -- Rita (PM)
(5, 6, '2026-02-05', 10),  -- Francisca

-- Projeto 6: Sistema de Agendamento Clínico
(6, 13, '2026-06-01', 15), -- Pedro (PM)
(6, 11, '2026-06-05', 10), -- Hugo
(6, 18, '2026-06-05', 8),  -- Ana
(6, 17, '2026-06-10', 5),  -- Vasco

-- Projeto 7: Auditoria Logística
(7, 12, '2026-07-01', 12), -- Mariana (PM)
(7, 15, '2026-07-05', 8),  -- Tiago
(7, 19, '2026-07-05', 6),  -- Miguel

-- Projeto 8: App Mobile
(8, 4, '2026-08-01', 14),  -- Diana (PM)
(8, 13, '2026-08-05', 12), -- Pedro
(8, 11, '2026-08-05', 10), -- Hugo

-- Projeto 9: Catálogo Mobiliário (Concluído)
(9, 6, '2026-03-15', 10),  -- Francisca (PM)
(9, 14, '2026-03-20', 8),  -- Rita

-- Projeto 10: Expansão E-commerce (Cancelado)
(10, 15, '2026-04-01', 8); -- Tiago (PM)

-- ============================================================================
-- 6. Inserir Tarefas Operacionais (28 Tarefas com variados prazos e estados)
-- ============================================================================
INSERT INTO tarefa (titulo, descricao, prazo, estado, projeto_id) VALUES
-- Projeto 1 (Website E-commerce)
('Design UI/UX da Loja Online', 'Protótipos de alta fidelidade no Figma', '2026-03-25', 'Concluída', 1),
('Integração de Gateway de Pagamento', 'Configurar Stripe e MB Way', '2026-08-29', 'A Decorrer', 1),
('Testes de Carga e Segurança Web', 'Garantir resposta a picos de tráfego', '2026-08-31', 'Pendente', 1),
('Otimização de SEO e Meta Tags', 'Indexação dos produtos em motores de busca', '2026-09-05', 'Pendente', 1),

-- Projeto 2 (Otimização Têxtil)
('Mapeamento de Processos de Fábrica', 'Identificar estrangulamentos na tecelagem', '2026-05-20', 'Concluída', 2),
('Análise de Tempos e Métodos', 'Cronometragem de postos operacionais', '2026-07-15', 'Concluída', 2),
('Implementação de Metodologia 5S', 'Organização e padronização do chão de fábrica', '2026-09-10', 'A Decorrer', 2),
('Relatório de Otimização Lean', 'Apresentação final de melhorias e poupanças', '2026-11-15', 'Pendente', 2),

-- Projeto 3 (Plano Marketing Digital - Concluído)
('Calendário de Publicações Redes Sociais', 'Definir posts para 3 meses', '2026-02-28', 'Concluída', 3),
('Campanha de Google Ads & Meta Ads', 'Segmentação regional de conversão', '2026-04-15', 'Concluída', 3),
('Relatório Final de ROI e Tráfego', 'Análise de métricas de conversão', '2026-05-25', 'Concluída', 3),

-- Projeto 4 (Plataforma IoT Solar)
('Definição de Arquitetura de Sensores', 'Mapeamento de protocolos MQTT e telemetria', '2026-06-15', 'Concluída', 4),
('Desenvolvimento do Backend de Ingestão', 'Pipeline em tempo real com MySQL e Node.js', '2026-09-02', 'A Decorrer', 4),
('Dashboard de Telemetria e Alertas', 'Visualização gráfica de geração solar', '2026-10-15', 'Pendente', 4),
('Integração de Notificações SMS/Email', 'Alertas de quebra de voltagem', '2026-11-01', 'Pendente', 4),

-- Projeto 5 (Identidade Visual - Concluído)
('Estudo de Mercado e Concorrência', 'Benchmarking de marcas concorrentes', '2026-02-20', 'Concluída', 5),
('Criação do Brandbook e Tipografia', 'Guia de estilo e aplicações gráficas', '2026-04-10', 'Concluída', 5),

-- Projeto 6 (Sistema Agendamento Clínico)
('Levantamento de Requisitos Médicos', 'Entrevistas com equipa clínica e receção', '2026-06-30', 'Concluída', 6),
('Modelagem da Base de Dados Clínica', 'Diagramação relacional em MySQL', '2026-07-25', 'Concluída', 6),
('Módulo de Autenticação e Segurança RGPD', 'Cifragem de dados e controlo de acessos', '2026-09-01', 'A Decorrer', 6),
('Módulo de Notificações WhatsApp', 'Lembretes automáticos de consultas', '2026-10-20', 'Pendente', 6),

-- Projeto 7 (Auditoria Logística)
('Diagnóstico de Gestão de Stock', 'Inventário e cálculo de taxa de rotação', '2026-08-15', 'Pendente', 7),
('Proposta de Reorganização de Armazém', 'Desenho de layout de picking acelerado', '2026-09-30', 'Pendente', 7),

-- Projeto 8 (App Mobile)
('Especificação Técnica e Wireframes', 'Fluxos de utilizador e arquitetura mobile', '2026-09-15', 'Pendente', 8),
('Prototipagem Interativa', 'Validação com stakeholders', '2026-10-30', 'Pendente', 8),

-- Projeto 9 (Catálogo Mobiliário - Concluído)
('Sessão Fotográfica de Produtos', 'Fotografia profissional em estúdio', '2026-04-20', 'Concluída', 9),
('Diagramação e Edição Digital', 'Formatação de catálogo interativo em PDF/Web', '2026-06-30', 'Concluída', 9),

-- Projeto 10 (Cancelado)
('Auditoria Prévia de Plataforma Legada', 'Levantamento de débitos técnicos', '2026-04-20', 'Concluída', 10);

-- ============================================================================
-- 7. Inserir Responsáveis por Tarefas (Atribuições N:M)
-- ============================================================================
INSERT INTO tarefa_responsavel (tarefa_id, membro_id, data_atribuicao) VALUES
-- Projeto 1 (tarefas atribuídas à Diana e Gonçalo, compatível com a Transação 2)
(1, 6, '2026-03-05'),  -- Francisca
(2, 4, '2026-04-01'),  -- Diana
(2, 7, '2026-04-01'),  -- Gonçalo (tarefa partilhada)
(3, 18, '2026-04-15'), -- Ana
(4, 6, '2026-05-01'),  -- Francisca

-- Projeto 2
(5, 5, '2026-04-20'),  -- Eduardo
(5, 4, '2026-04-20'),  -- Diana
(6, 5, '2026-05-10'),  -- Eduardo
(7, 16, '2026-06-01'), -- Sofia
(7, 5, '2026-06-01'),  -- Eduardo
(8, 5, '2026-07-01'),  -- Eduardo

-- Projeto 3
(9, 6, '2026-01-15'),  -- Francisca
(10, 14, '2026-02-01'),-- Rita
(11, 6, '2026-04-01'), -- Francisca

-- Projeto 4
(12, 11, '2026-05-05'),-- Hugo
(13, 13, '2026-05-15'),-- Pedro
(13, 11, '2026-05-15'),-- Hugo
(14, 5, '2026-06-01'), -- Eduardo
(15, 16, '2026-06-15'),-- Sofia

-- Projeto 5
(16, 14, '2026-02-05'),-- Rita
(17, 6, '2026-02-15'), -- Francisca
(17, 14, '2026-02-15'),-- Rita

-- Projeto 6
(18, 13, '2026-06-05'),-- Pedro
(19, 11, '2026-06-10'),-- Hugo
(20, 18, '2026-06-20'),-- Ana
(20, 13, '2026-06-20'),-- Pedro
(21, 17, '2026-07-01'),-- Vasco

-- Projeto 7
(22, 12, '2026-07-05'),-- Mariana
(23, 15, '2026-07-10'),-- Tiago

-- Projeto 8
(24, 4, '2026-08-05'),  -- Diana
(25, 13, '2026-08-10'), -- Pedro

-- Projeto 9
(26, 14, '2026-03-25'), -- Rita
(27, 6, '2026-04-01'),  -- Francisca

-- Projeto 10
(28, 15, '2026-04-05'); -- Tiago