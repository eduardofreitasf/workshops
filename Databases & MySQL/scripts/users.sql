-- ==================================
-- Criar esquema da base de dados
-- ==================================

CREATE DATABASE IF NOT EXISTS star_projetos;
USE star_projetos; 

-- ================================================================
-- 1. CRIAR UTILIZADORES
-- Sintaxe: CREATE USER 'username'@'host' IDENTIFIED BY 'password';
-- ================================================================

-- A. Administrador (Acesso total)
CREATE USER 'admin_star'@'localhost' IDENTIFIED BY 'AdminStar2026!';

-- B. Diretor / Project Manager (Leitura, Inserção e Atualização)
CREATE USER 'gestor_projetos'@'%' IDENTIFIED BY 'GestorStar#2026';

-- C. Consultor / Membro (Apenas leitura/consulta)
CREATE USER 'consultor_star'@'%' IDENTIFIED BY 'ConsultorStar2026*';

-- D. Backend / Aplicação Web (Acesso DML padrão)
CREATE USER 'app_backend'@'localhost' IDENTIFIED BY 'AppSecurePass2026%';

-- ==========================================================
-- 2. ATRIBUIR PRIVILÉGIOS (GRANT)
-- ==========================================================

-- A. Administrador: Todos os privilégios
GRANT ALL PRIVILEGES ON star_projetos.* TO 'admin_star'@'localhost';

-- B. Gestor de Projetos: Pode ler, criar e editar registos (sem permissão de apagar tabelas)
GRANT SELECT, INSERT, UPDATE ON star_projetos.* TO 'gestor_projetos'@'%';

-- C. Consultor Júnior: Apenas permissão de consulta (SELECT)
GRANT SELECT ON star_projetos.* TO 'consultor_star'@'%';

-- D. Aplicação: Permissões de CRUD sobre todas as tabelas
GRANT SELECT, INSERT, UPDATE, DELETE ON star_projetos.* TO 'app_backend'@'localhost';

-- ==========================================================
-- 3. APLICAR E VALIDAR PRIVILÉGIOS
-- ==========================================================

-- Recarregar tabelas de permissões do MySQL
FLUSH PRIVILEGES;

-- Verificar permissões atribuídas a um utilizador específico
SHOW GRANTS FOR 'consultor_star'@'%';

-- ==========================================================
-- 4. Gestão e Revogação
-- ==========================================================

-- Revogar permissão de UPDATE ao Gestor
REVOKE UPDATE ON star_projetos.* FROM 'gestor_projetos'@'%';

-- Eliminar um utilizador que saiu da STAR
DROP USER IF EXISTS 'consultor_star'@'%';
