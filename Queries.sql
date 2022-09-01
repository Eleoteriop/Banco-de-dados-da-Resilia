--                 Consultas obrigatórias!!
-- Selecionar a quantidade total de estudantes cadastrados no banco.
select count(id_aluno) as qtd_alunos from alunos;
-- Separados por curso
select count(id_aluno), cursos.curso from alunos
    inner join turma 
        on alunos.id_turma = turma.id_turma
    inner join cursos 
        on turma.id_curso =  cursos.id_curso
group by cursos.id_curso;


-- Selecionar todos os estudantes com os respectivos cursos que eles estão cadastrados.
select concat(nome, ' ', sobrenome) as nome, cursos.curso from alunos
    inner join turma 
        on turma.id_turma = alunos.id_turma
    inner join cursos 
        on turma.id_curso =  cursos.id_curso
    order by cursos.curso;

--Selecionar quais pessoas facilitadoras atuam em mais de uma turma.
select funcionarios.nome_funcionario, count(turma.id_funcionario) 
as qtd_turmas_de_atuacao from turma
    inner join funcionarios
        on turma.id_funcionario = funcionarios.id_funcionario
where status = 'EM ANDAMENTO' 
group by funcionarios.nome_funcionario
    having count(turma.id_funcionario) > 1
order by count(turma.id_funcionario) desc
;



--                  Consultas escolhidas pelo squad
-- Alunos que concluiram o curso e estão devendo o pagamento.
select nome,formacao_aluno.situacao_financeira, turma.status from alunos 
    inner join formacao_aluno 
        on formacao_aluno.id_aluno = alunos.id_aluno
    inner join turma 
        on alunos.id_turma = turma.id_turma
where formacao_aluno.situacao_financeira = 'DEVEDOR' 
and turma.status = 'CONCLUIDO';



-- O que as turmas em andamento estão aprendendo no atual modulo.
select turma.nome_turma,cursos.curso,ementa.modulo, ementa.descricao from modulo 
    inner join ementa 
        on ementa.id_ementa = modulo.id_ementa
    inner join turma 
        on turma.id_turma = modulo.id_turma
    inner join cursos 
        on turma.id_curso = cursos.id_curso
where data_inicio between '30-07-2022' and '01-09-2022';



-- View dos Facilitadores Soft.
create view FacilitadoresSoft as
select funcionarios.id_funcionario as id_facilitador_soft,
    concat(funcionarios.nome_funcionario, ' ', funcionarios.sobrenome_funcionario) as nome,
    departamentos.nome_departamento
from departamentos
    inner join funcionarios
        on departamentos.id_departamento = funcionarios.id_departamento
where departamentos.nome_departamento = 'FACILITAÇÃO SOFT';


-- Contagem de turmas que facilitadores já deram aula.
select turma.id_funcionario ,facilitadoressoft.nome, count(turma.id_turma) as qtd_turmas from turma
    left join facilitadoressoft
        on turma.id_funcionario = facilitadoressoft.id_facilitador_soft
group by turma.id_funcionario, facilitadoressoft.nome
order by id_funcionario
;
