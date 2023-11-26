CREATE DATABASE SistemaUniversidade;

CREATE TABLE IF NOT EXISTS Aluno(
id_aluno int primary key auto_increment,
id_curso_aluno int,
nome_aluno varchar(80) not null,
sobrenome_aluno varchar(80) not null,
email_aluno varchar(50) unique,
matriculado boolean default false,
FOREIGN KEY (id_curso_aluno) references Curso(id_curso)
);

CREATE TABLE IF NOT EXISTS Curso(
id_curso int primary key auto_increment,
nome_curso varchar(90) not null,
area_curso varchar(20) not null 
);


-- CRIANDO PROCEDURE SIMPLES DE INSERIR CURSO (checando se ele existe antes)

DELIMITER $ 

CREATE PROCEDURE inserirCurso(IN nome_curso_adicionar varchar(90), in area_curso_adicionar varchar(20))
BEGIN

DECLARE existe int;
SELECT COUNT(*) INTO existe FROM Curso WHERE nome_curso_adicionar = nome_curso AND area_curso_adicionar = area_curso;

IF existe = 0 THEN
INSERT INTO Curso (nome_curso,area_curso) values (nome_curso_adicionar,area_curso_adicionar);
end if;

END $




-- CRIANDO UMA PROCEDURE QUE BUSCA O CURSO POR ID (checando se ele existe antes)

DELIMITER $

CREATE PROCEDURE buscarCurso(IN id INT)
BEGIN
  DECLARE existe INT;
  SELECT COUNT(*) INTO existe FROM Curso WHERE id_curso = id;

  IF existe != 0 THEN
    SELECT nome_curso AS Nome_Curso FROM Curso WHERE id_curso = id;
  END IF;
END $




-- FUNÇÃO QUE RETORNA O ID DO CURSO

DELIMITER $

CREATE FUNCTION rertornarIdCurso(pesquisa_nome_curso VARCHAR(90), pesquisa_area_curso VARCHAR(20))
RETURNS INT

BEGIN
  DECLARE curso_id INT;
  SELECT id_curso INTO curso_id FROM Curso WHERE nome_curso = pesquisa_nome_curso AND area_curso = pesquisa_area_curso LIMIT 1;
  RETURN IFNULL(curso_id, -1);
END $

DELIMITER ;



-- PROCEDURE QUE CRIA UM ALUNO E JA GERA O EMAIL AUTOMATICAMENTE 

DELIMITER $ 

CREATE PROCEDURE inserirAluno(nome varchar (50), sobrenome varchar (50))

BEGIN 

DECLARE contador int ;
DECLARE email varchar(100);
SELECT Count(*) into contador from Aluno where nome = nome_aluno and sobrenome = sobrenome_aluno;
if contador = 0 THEN
SET email = concat (nome,'.',sobrenome,'@facens.br');
ELSE 
SET email = concat (nome,'.',sobrenome,contador,'@facens.br');
END IF;

INSERT INTO Aluno (nome_aluno, sobrenome_aluno,email_aluno) values (nome,sobrenome,email);
END$



-- CRIANDO PROCEDURE PARA MATRICULAR O ALUNO A UM CURSO

DELIMITER $

CREATE PROCEDURE matricularAluno(IN m_id_aluno INT, IN m_id_curso INT)
BEGIN 
  DECLARE matriculado BOOLEAN;

  SELECT matriculado INTO matriculado FROM Aluno WHERE id_aluno = m_id_aluno;

  IF NOT matriculado THEN
    UPDATE Aluno SET id_curso = m_id_curso, matriculado = true WHERE id_aluno = m_id_aluno;
  END IF;
END $





