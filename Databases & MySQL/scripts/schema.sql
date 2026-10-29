USE star_projetos;

-- 1. Tabela de Departamentos
CREATE TABLE departamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sigla VARCHAR(10) NOT NULL UNIQUE
);

-- 2. Tabela de Membros
CREATE TABLE membro (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    cargo ENUM('Membro', 'Diretor', 'Presidente') NOT NULL DEFAULT 'Membro',
    departamento_id INT NOT NULL,

    FOREIGN KEY (departamento_id) REFERENCES departamento(id)
);

-- 3. Tabela de Clientes
CREATE TABLE cliente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_empresa VARCHAR(150) NOT NULL,
    nif VARCHAR(20) NOT NULL UNIQUE,
    email_contacto VARCHAR(120) NOT NULL
);

-- 4. Tabela de Projetos
CREATE TABLE projeto (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE,
    orcamento DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    estado ENUM('Em Planeamento', 'Em Curso', 'Concluído', 'Cancelado')
		NOT NULL DEFAULT 'Em Planeamento',
	cliente_id INT NOT NULL,
    pm_id INT NOT NULL,
    orientador_id INT NOT NULL,
    
    FOREIGN KEY (cliente_id) REFERENCES cliente(id),
    FOREIGN KEY (pm_id) REFERENCES membro(id),
    FOREIGN KEY (orientador_id) REFERENCES membro(id)
);

-- 5. Tabela da Equipa do Projeto
CREATE TABLE equipa_projeto (
    projeto_id INT NOT NULL,
    membro_id INT NOT NULL,
    data_alocacao DATE NOT NULL DEFAULT (CURRENT_DATE),
    horas_semanais INT DEFAULT 10,

    PRIMARY KEY (projeto_id, membro_id),
    FOREIGN KEY (projeto_id) REFERENCES projeto(id) ON DELETE CASCADE,
    FOREIGN KEY (membro_id) REFERENCES membro(id) ON DELETE CASCADE
);

-- 6. Tabela de Tarefas
CREATE TABLE tarefa (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descricao TEXT,
    prazo DATE NOT NULL,
    estado ENUM('Pendente', 'A Decorrer', 'Concluída')
    	NOT NULL DEFAULT 'Pendente',
    projeto_id INT NOT NULL,

    FOREIGN KEY (projeto_id) REFERENCES projeto(id) ON DELETE CASCADE
);

-- 7. Tabela de Responsáveis por Tarefa
CREATE TABLE tarefa_responsavel (
    tarefa_id INT NOT NULL,
    membro_id INT NOT NULL,
    data_atribuicao DATE NOT NULL DEFAULT (CURRENT_DATE),

    PRIMARY KEY (tarefa_id, membro_id),
    FOREIGN KEY (tarefa_id) REFERENCES tarefa(id) ON DELETE CASCADE,
    FOREIGN KEY (membro_id) REFERENCES membro(id) ON DELETE CASCADE
);
