USE star_projetos;

-- ============================================================================
-- CONSULTAS INTRODUTÓRIAS E PROGRESSIVAS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Query 1: Visão Geral de Projetos Ativos e Clientes
-- ----------------------------------------------------------------------------
-- Contexto de Negócio:
--   A direção executiva da STAR necessita de um relatório rápido de todos os
--   projetos atualmente em desenvolvimento, identificando o respetivo cliente
--   contratante e o valor orçamentado, ordenados do maior para o menor montante.
-- Conceitos Técnicos Demonstrados:
--   - Junção interna (INNER JOIN) entre 'projeto' e 'cliente'.
--   - Aliases de tabelas ('p' e 'c') para código legível e limpo.
--   - Filtro de restrição com WHERE sobre colunas do tipo ENUM.
--   - Ordenação decrescente com ORDER BY ... DESC.
-- ----------------------------------------------------------------------------
SELECT 
    p.nome AS projeto,
    c.nome_empresa AS cliente,
    p.data_inicio,
    p.orcamento,
    p.estado
FROM projeto p
INNER JOIN cliente c ON p.cliente_id = c.id
WHERE p.estado = 'Em Curso'
ORDER BY p.orcamento DESC;


-- ----------------------------------------------------------------------------
-- Query 2: Métricas de Faturação e Volume por Cliente
-- ----------------------------------------------------------------------------
-- Contexto de Negócio:
--   O departamento comercial precisa de avaliar o valor de ciclo de vida (LTV)
--   e a concentração de receita por cliente, apurando o total de projetos já
--   adjudicados, a faturação acumulada e o orçamento médio por contrato.
-- Conceitos Técnicos Demonstrados:
--   - Agregação de dados com GROUP BY baseado na chave primária do cliente.
--   - Funções agregadoras: COUNT() para volume, SUM() para total e AVG() para média.
--   - Arredondamento numérico com ROUND(..., 2).
--   - Filtro pós-agregação com HAVING (filtragem sobre grupos consolidados).
-- ----------------------------------------------------------------------------
SELECT 
    c.nome_empresa AS cliente,
    COUNT(p.id) AS total_projetos,
    SUM(p.orcamento) AS volume_total,
    ROUND(AVG(p.orcamento), 2) AS orcamento_medio
FROM cliente c
INNER JOIN projeto p ON c.id = p.cliente_id
GROUP BY c.id, c.nome_empresa
HAVING total_projetos >= 1
ORDER BY volume_total DESC;


-- ----------------------------------------------------------------------------
-- Query 3: Auditoria de Alocação de Consultores
-- ----------------------------------------------------------------------------
-- Contexto de Negócio:
--   Os Recursos Humanos precisam de auditar a taxa de ocupação dos membros da
--   Júnior Empresa. É imperativo que membros recém-admitidos ou sem projetos
--   atribuídos continuem visíveis no relatório com a contagem '0', o que falharia
--   caso fosse utilizado um INNER JOIN convencional.
-- Conceitos Técnicos Demonstrados:
--   - Junção externa à esquerda (LEFT JOIN) para preservar registos sem par.
--   - Combinação de INNER JOIN (departamento obrigatório) com LEFT JOIN (alocação opcional).
--   - Resolução da tabela associativa N:M 'equipa_projeto'.
--   - Contagem precisa de chaves estrangeiras com COUNT(ep.projeto_id).
-- ----------------------------------------------------------------------------
SELECT 
    m.nome AS consultor,
    d.sigla AS departamento,
    m.cargo,
    COUNT(ep.projeto_id) AS total_projetos_alocados
FROM membro m
INNER JOIN departamento d ON m.departamento_id = d.id
LEFT JOIN equipa_projeto ep ON m.id = ep.membro_id
GROUP BY m.id, m.nome, d.sigla, m.cargo
ORDER BY total_projetos_alocados DESC, m.nome ASC;


-- ----------------------------------------------------------------------------
-- Query 4: Carga de Trabalho e Classificação de Ocupação
-- ----------------------------------------------------------------------------
-- Contexto de Negócio:
--   Para apoiar o planeamento de novos projetos, a coordenação operacional quer
--   classificar a disponibilidade de cada consultor segundo o número de tarefas
--   ativas (pendentes ou em curso) que tem em mãos ('Disponível', 'Carga Normal',
--   ou 'Carga Elevada').
-- Conceitos Técnicos Demonstrados:
--   - Múltiplos LEFT JOIN através de tabelas associativas ('tarefa_responsavel' e 'tarefa').
--   - Condição booleana extra diretamente no predicado do JOIN (t.estado != 'Concluída').
--   - Transformação e categorização dinâmica de dados com a cláusula CASE WHEN ... THEN ... ELSE ... END.
-- ----------------------------------------------------------------------------
SELECT 
    m.nome AS consultor,
    COUNT(t.id) AS tarefas_ativas,
    CASE 
        WHEN COUNT(t.id) = 0 THEN 'Disponível'
        WHEN COUNT(t.id) = 1 THEN 'Carga Normal'
        ELSE 'Carga Elevada'
    END AS estado_ocupacao
FROM membro m
LEFT JOIN tarefa_responsavel tr ON m.id = tr.membro_id
LEFT JOIN tarefa t ON tr.tarefa_id = t.id AND t.estado != 'Concluída'
GROUP BY m.id, m.nome
ORDER BY tarefas_ativas DESC, m.nome ASC;


-- ============================================================================
-- CONSULTAS ANALÍTICAS E RELATÓRIOS DE GESTÃO
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Query 5: Dashboard Global de Progresso e Percentagem de Conclusão de Projetos
-- ----------------------------------------------------------------------------
-- Contexto de Negócio:
--   A Direção da STAR exige uma visão 360º de cada projeto em curso ou concluído:
--   cliente, gestor direto (PM), orientador docente/institucional, dimensão
--   da equipa afeta, volume total de tarefas e a respetiva taxa de conclusão.
-- Conceitos Técnicos Demonstrados:
--   - Múltiplas junções à mesma tabela de origem: 'membro pm' e 'membro orientador'.
--   - Contagens distintas com COUNT(DISTINCT ...) para evitar duplicações por produto cartesiano.
--   - Cálculo condicional de tarefas concluídas com SUM(CASE WHEN ... THEN 1 ELSE 0 END).
--   - Tratamento de divisão por zero através de NULLIF(divisor, 0).
-- ----------------------------------------------------------------------------
SELECT 
    p.id AS projeto_id,
    p.nome AS projeto,
    c.nome_empresa AS cliente,
    pm.nome AS project_manager,
    orientador.nome AS diretor_orientador,
    COUNT(DISTINCT ep.membro_id) AS total_membros_equipa,
    COUNT(DISTINCT t.id) AS total_tarefas,
    SUM(CASE WHEN t.estado = 'Concluída' THEN 1 ELSE 0 END) AS tarefas_concluidas,
    ROUND(
        (SUM(CASE WHEN t.estado = 'Concluída' THEN 1 ELSE 0 END) / NULLIF(COUNT(DISTINCT t.id), 0)) * 100, 
        1
    ) AS percentagem_concluida
FROM projeto p
INNER JOIN cliente c ON p.cliente_id = c.id
INNER JOIN membro pm ON p.pm_id = pm.id
INNER JOIN membro orientador ON p.orientador_id = orientador.id
LEFT JOIN equipa_projeto ep ON p.id = ep.projeto_id
LEFT JOIN tarefa t ON p.id = t.projeto_id
GROUP BY p.id, p.nome, c.nome_empresa, pm.nome, orientador.nome;


-- ----------------------------------------------------------------------------
-- Query 6: Alocação Semanal de RH e Listagem de Projetos Ativos por Consultor
-- ----------------------------------------------------------------------------
-- Contexto de Negócio:
--   O departamento de Recursos Humanos quer acompanhar a dedicação semanal em
--   horas de cada membro da organização em projetos em curso, exibindo em simultâneo
--   uma lista textual com o nome de todos os projetos a que está associado.
-- Conceitos Técnicos Demonstrados:
--   - Agregação por membro e departamento.
--   - Tratamento de nulos com COALESCE() para devolver '0' horas e 'Sem alocação'.
--   - Concatenação de registos múltiplos numa única string com GROUP_CONCAT(DISTINCT ... SEPARATOR ' | ').
--   - Filtragem seletiva de projetos ativos na própria cláusula ON do JOIN.
-- ----------------------------------------------------------------------------
SELECT 
    m.id AS membro_id,
    m.nome AS consultor,
    d.sigla AS departamento,
    m.cargo,
    COALESCE(SUM(ep.horas_semanais), 0) AS total_horas_semanais,
    COALESCE(GROUP_CONCAT(DISTINCT p.nome ORDER BY p.nome SEPARATOR ' | '), 'Sem alocação') AS projetos_ativos
FROM membro m
INNER JOIN departamento d ON m.departamento_id = d.id
LEFT JOIN equipa_projeto ep ON m.id = ep.membro_id
LEFT JOIN projeto p ON ep.projeto_id = p.id AND p.estado = 'Em Curso'
GROUP BY m.id, m.nome, d.sigla, m.cargo
ORDER BY total_horas_semanais DESC;


-- ----------------------------------------------------------------------------
-- Query 7: Gestão de Risco Operacional — Projetos com Prazos Iminentes
-- ----------------------------------------------------------------------------
-- Contexto de Negócio:
--   Identificar ativamente projetos em curso que possuam entregáveis pendentes
--   com data limite já ultrapassada ou que expire nos próximos 3 dias, permitindo
--   à equipa priorizar os projetos de maior orçamento em risco de incumprimento.
-- Conceitos Técnicos Demonstrados:
--   - Aritmética de datas com CURRENT_DATE e DATE_ADD(..., INTERVAL 3 DAY).
--   - Cálculo do diferencial de dias com DATEDIFF(prazo, CURRENT_DATE).
--   - Filtro conjunto sobre estados de projeto e estados de tarefa.
--   - Ordenação prioritária por orçamento decrescente e urgência temporal crescente.
-- ----------------------------------------------------------------------------
SELECT DISTINCT
    p.id AS projeto_id,
    p.nome AS projeto,
    p.orcamento,
    t.titulo AS tarefa_em_risco,
    t.prazo,
    DATEDIFF(t.prazo, CURRENT_DATE) AS dias_restantes
FROM projeto p
INNER JOIN tarefa t ON p.id = t.projeto_id
WHERE p.estado = 'Em Curso'
  AND t.estado != 'Concluída'
  AND t.prazo <= DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY)
ORDER BY p.orcamento DESC, t.prazo ASC;


-- ============================================================================
-- TRANSAÇÕES ATÓMICAS (PROPRIEDADES ACID)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Transaction 1: Conclusão Atómica de Projeto e Tarefas Associadas
-- ----------------------------------------------------------------------------
-- Contexto de Negócio:
--   Quando um projeto é formalmente aceite pelo cliente, todas as tarefas
--   associadas ainda pendentes devem transitar imediatamente para 'Concluída'
--   e o projeto deve ser marcado como 'Concluído' com a data atual.
--   Caso ocorra uma falha técnica a meio, nada deve ser alterado (Atomicidade).
-- Conceitos Técnicos Demonstrados:
--   - Abertura de bloco transacional com START TRANSACTION.
--   - Múltiplas instruções DML de UPDATE encadeadas e dependentes.
--   - Confirmação definitiva e durável com COMMIT.
-- ----------------------------------------------------------------------------
START TRANSACTION;

UPDATE tarefa 
SET estado = 'Concluída' 
WHERE projeto_id = 1 AND estado != 'Concluída';

UPDATE projeto 
SET estado = 'Concluído', 
    data_fim = CURRENT_DATE 
WHERE id = 1;

COMMIT;


-- ----------------------------------------------------------------------------
-- Transaction 2: Substituição Atómica de Project Manager (PM)
-- ----------------------------------------------------------------------------
-- Contexto de Negócio:
--   Um Project Manager (ex.: Diana, ID 4) sai da Júnior Empresa a meio do projeto.
--   É necessário reatribuir a liderança formal ao novo PM (ex.: Eduardo, ID 5),
--   garantir que ele está inscrito na equipa do projeto e transferir todas as
--   tarefas que estavam sob responsabilidade do líder anterior num único passo atómico.
-- Conceitos Técnicos Demonstrados:
--   - Salvaguarda de consistência multi-tabela (projeto, equipa_projeto, tarefa_responsavel).
--   - INSERT IGNORE para prevenir duplicações de chave primária na equipa.
--   - UPDATE com INNER JOIN entre tabela associativa e tabela de tarefas.
-- ----------------------------------------------------------------------------
START TRANSACTION;

-- 1. Altera o gestor na ficha do projeto
UPDATE projeto 
SET pm_id = 5 
WHERE id = 1 AND pm_id = 4;

-- 2. Insere o novo PM na equipa do projeto (se já não constar)
INSERT IGNORE INTO equipa_projeto (projeto_id, membro_id, horas_semanais)
VALUES (1, 5, 15);

-- 3. Transfere a titularidade de tarefas exclusivas do gestor cessante
UPDATE tarefa_responsavel tr
INNER JOIN tarefa t ON tr.tarefa_id = t.id
SET tr.membro_id = 5
WHERE t.projeto_id = 1 AND tr.membro_id = 4;

COMMIT;


-- ============================================================================
-- PROCEDURES DE NEGÓCIO (LÓGICA PROCEDURAL NO SGBD)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Procedure 1: sp_criar_novo_projeto
-- ----------------------------------------------------------------------------
-- Contexto de Negócio:
--   Os estatutos internos da STAR exigem que o Orientador de qualquer projeto
--   de consultoria seja obrigatoriamente um membro da Direção ou o Presidente.
--   Esta procedure encapsula a validação dessa regra de negócio no próprio motor,
--   rejeitando inserções ilegítimas antes de criar o projeto.
-- Conceitos Técnicos Demonstrados:
--   - Declaração de variáveis locais (DECLARE v_cargo VARCHAR).
--   - Controlo de fluxo condicional com IF ... ELSE ... END IF.
--   - Lançamento de erros customizados com SIGNAL SQLSTATE '45000'.
--   - Obtenção do ID gerado automaticamente via LAST_INSERT_ID().
-- ----------------------------------------------------------------------------
DELIMITER $$

CREATE PROCEDURE sp_criar_novo_projeto (
    IN p_nome VARCHAR(150),
    IN p_data_inicio DATE,
    IN p_orcamento DECIMAL(10,2),
    IN p_cliente_id INT,
    IN p_pm_id INT,
    IN p_orientador_id INT
)
BEGIN
    DECLARE v_cargo VARCHAR(50);

    SELECT cargo INTO v_cargo 
    FROM membro 
    WHERE id = p_orientador_id;

    IF v_cargo NOT IN ('Diretor', 'Presidente') OR v_cargo IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro de Governação: O orientador do projeto deve ter o cargo de Diretor ou Presidente.';
    ELSE
        INSERT INTO projeto (nome, data_inicio, orcamento, estado, cliente_id, pm_id, orientador_id)
        VALUES (p_nome, p_data_inicio, p_orcamento, 'Em Planeamento', p_cliente_id, p_pm_id, p_orientador_id);
        
        SELECT LAST_INSERT_ID() AS novo_projeto_id;
    END IF;
END$$

DELIMITER ;


-- ----------------------------------------------------------------------------
-- Procedure 2: sp_resumo_consultor
-- ----------------------------------------------------------------------------
-- Contexto de Negócio:
--   Permite a sistemas externos (ex.: painel de perfil do membro ou API backend)
--   extrair rapidamente métricas individuais de um consultor específico
--   através de parâmetros de saída (OUT).
-- Conceitos Técnicos Demonstrados:
--   - Utilização de parâmetros de saída OUT para devolver valores escalares.
--   - Cláusula SELECT ... INTO para povoar variáveis de retorno.
--   - Separação de contagens agregadas em consultas simples e otimizadas.
-- ----------------------------------------------------------------------------
DELIMITER $$

CREATE PROCEDURE sp_resumo_consultor (
    IN p_membro_id INT,
    OUT p_total_projetos INT,
    OUT p_tarefas_concluidas INT
)
BEGIN
    -- Total de projetos em que participou
    SELECT COUNT(DISTINCT projeto_id) INTO p_total_projetos
    FROM equipa_projeto
    WHERE membro_id = p_membro_id;

    -- Total de tarefas que concluiu com sucesso
    SELECT COUNT(DISTINCT tr.tarefa_id) INTO p_tarefas_concluidas
    FROM tarefa_responsavel tr
    INNER JOIN tarefa t ON tr.tarefa_id = t.id
    WHERE tr.membro_id = p_membro_id AND t.estado = 'Concluída';
END$$

DELIMITER ;


-- ----------------------------------------------------------------------------
-- Procedure 3: sp_concluir_projeto_transacional
-- ----------------------------------------------------------------------------
-- Contexto de Negócio:
--   Procedimento administrativo seguro para encerramento de projetos. Garante
--   que se qualquer exceção SQL ocorrer durante a atualização do projeto ou das
--   tarefas, o sistema executa automaticamente ROLLBACK e devolve uma mensagem
--   de erro amigável, prevenindo estados inconsistentes.
-- Conceitos Técnicos Demonstrados:
--   - Gestor de exceções transacionais: DECLARE EXIT HANDLER FOR SQLEXCEPTION.
--   - Transação totalmente encapsulada no corpo do procedimento.
--   - Retorno de status formatado com CONCAT().
-- ----------------------------------------------------------------------------
DELIMITER $$

CREATE PROCEDURE sp_concluir_projeto_transacional (
    IN p_projeto_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Erro Crítico: A transação falhou e todas as alterações foram revertidas (ROLLBACK).' AS status;
    END;

    START TRANSACTION;

        -- 1. Conclui as tarefas pendentes
        UPDATE tarefa 
        SET estado = 'Concluída' 
        WHERE projeto_id = p_projeto_id AND estado != 'Concluída';

        -- 2. Conclui o projeto
        UPDATE projeto 
        SET estado = 'Concluído', 
            data_fim = CURRENT_DATE 
        WHERE id = p_projeto_id;

    COMMIT;

    SELECT CONCAT('Sucesso: Projeto ', p_projeto_id, ' e respetivas tarefas concluídos com sucesso!') AS status;
END$$

DELIMITER ;


-- ============================================================================
-- TRIGGERS (AUTOMAÇÃO E INTEGRIDADE POR EVENTOS)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Trigger 1: trg_validar_sobrecarga_membro
-- ----------------------------------------------------------------------------
-- Contexto de Negócio:
--   Regra de bem-estar e qualidade: nenhum membro pode estar alocado a mais de
--   3 projetos ativos ('Em Curso') em simultâneo. Este gatilho é executado antes
--   de qualquer nova alocação e bloqueia a operação se o limite for atingido.
-- Conceitos Técnicos Demonstrados:
--   - Gatilho prévio (BEFORE INSERT) para atuar como barreira impeditiva.
--   - Leitura de novos valores a ser inseridos através da pseudo-tabela 'NEW'.
--   - Bloqueio imediato com SIGNAL SQLSTATE.
-- ----------------------------------------------------------------------------
DELIMITER $$

CREATE TRIGGER trg_validar_sobrecarga_membro
BEFORE INSERT ON equipa_projeto
FOR EACH ROW
BEGIN
    DECLARE v_projetos_ativos INT;

    SELECT COUNT(*) INTO v_projetos_ativos
    FROM equipa_projeto ep
    INNER JOIN projeto p ON ep.projeto_id = p.id
    WHERE ep.membro_id = NEW.membro_id AND p.estado = 'Em Curso';

    IF v_projetos_ativos >= 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro de Alocação: O membro já se encontra no limite máximo de 3 projetos ativos em simultâneo.';
    END IF;
END$$

DELIMITER ;


-- ----------------------------------------------------------------------------
-- Trigger 2: trg_cancelar_tarefas_projeto
-- ----------------------------------------------------------------------------
-- Contexto de Negócio:
--   Quando um cliente cancela um contrato e o estado do projeto passa para 'Cancelado',
--   o sistema deve limpar as tarefas operacionais pendentes desse projeto,
--   marcando-as como 'Concluída' para não impactarem alertas e métricas futuras.
-- Conceitos Técnicos Demonstrados:
--   - Gatilho reativo (AFTER UPDATE) executado linha a linha (FOR EACH ROW).
--   - Comparação do estado anterior ('OLD.estado') com o novo estado ('NEW.estado').
--   - Propagação automática de alterações entre tabelas dependentes.
-- ----------------------------------------------------------------------------
DELIMITER $$

CREATE TRIGGER trg_cancelar_tarefas_projeto
AFTER UPDATE ON projeto
FOR EACH ROW
BEGIN
    IF NEW.estado = 'Cancelado' AND OLD.estado != 'Cancelado' THEN
        UPDATE tarefa 
        SET estado = 'Concluída' 
        WHERE projeto_id = NEW.id AND estado != 'Concluída';
    END IF;
END$$

DELIMITER ;


-- ============================================================================
-- EXECUÇÕES E TESTES DE PROCEDURES
-- ============================================================================

-- Teste da procedure transacional para conclusão dos projetos 1 e 2
CALL sp_concluir_projeto_transacional(1);
CALL sp_concluir_projeto_transacional(2);

-- Teste da procedure com parâmetros OUT para inspeção do membro 5 (Eduardo Matos)
-- SET @projetos = 0;
-- SET @tarefas = 0;
-- CALL sp_resumo_consultor(5, @projetos, @tarefas);
-- SELECT @projetos AS total_projetos, @tarefas AS tarefas_concluidas;
