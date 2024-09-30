#!/bin/bash


# Função para verificar e instalar o pacote dialog, se necessário
check_dependencies() {
    if ! command -v dialog &> /dev/null; then
        echo "O pacote 'dialog' não está instalado. Instalando..."
        sudo apt-get update && sudo apt-get install -y dialog
    fi
}

# Array para armazenar os alunos cadastrados
declare -a ALUNOS

# Função para cadastrar um novo aluno
cadastrar_aluno() {
    while true; do
        NOME=$(dialog --inputbox "Digite o nome do aluno:" 8 40 3>&1 1>&2 2>&3 3>&-)
        if [[ -n "$NOME" ]]; then
            break
        else
            dialog --msgbox "Nome não pode ser vazio. Tente novamente." 6 40
        fi
    done

    while true; do
        IDADE=$(dialog --inputbox "Digite a idade do aluno:" 8 40 3>&1 1>&2 2>&3 3>&-)
        if [[ "$IDADE" =~ ^[0-9]+$ ]]; then
            break
        else
            dialog --msgbox "Idade deve ser um número. Tente novamente." 6 40
        fi
    done

    while true; do
        MATRICULA=$(dialog --inputbox "Digite a matrícula do aluno:" 8 40 3>&1 1>&2 2>&3 3>&-)
        if [[ -n "$MATRICULA" ]]; then
            break
        else
            dialog --msgbox "Matrícula não pode ser vazia. Tente novamente." 6 40
        fi
    done

    ALUNOS+=("$NOME, $IDADE anos, Matrícula: $MATRICULA")
    dialog --msgbox "Aluno cadastrado com sucesso!" 6 40
}

# Função para listar alunos
listar_alunos() {
    if [ ${#ALUNOS[@]} -eq 0 ]; then
        dialog --msgbox "Nenhum aluno cadastrado." 6 40
    else
        ALUNOS_LISTAGEM=""
        for ALUNO in "${ALUNOS[@]}"; do
            ALUNOS_LISTAGEM+="$ALUNO\n"
        done
        dialog --msgbox "Alunos cadastrados:\n\n$ALUNOS_LISTAGEM" 20 50
    fi
}

# Função para exibir o menu principal
menu() {
    while true; do
        ESCOLHA=$(dialog --menu "Escolha uma opção:" 15 50 4 \
            1 "Cadastrar Aluno" \
            2 "Listar Alunos" \
            3 "Sair" 3>&1 1>&2 2>&3 3>&-)
        
        EXIT_STATUS=$?
        
        if [ $EXIT_STATUS -ne 0 ]; then
            break
        fi

        case $ESCOLHA in
            1)
                cadastrar_aluno
                ;;
            2)
                listar_alunos
                ;;
            3)
                break
                ;;
            *)
                dialog --msgbox "Opção inválida!" 6 40
                ;;
        esac
    done
}

# Função para exibir o resumo e ajuda do sistema
exibir_ajuda() {
    dialog --msgbox "Projeto de Cadastro de Alunos\n\nEquipe: Alan Santos Cerqueira e Herbert Brandão Gentil\n\nEste projeto cadastra alunos e lista os alunos cadastrados, usando o 'dialog' para interação com o usuário.\n\nPara executar:\n./projeto.sh" 15 50
}

# Função principal
main() {
    if [[ $1 == "h" ]]; then
        exibir_ajuda
    else
        check_dependencies
        menu
    fi
}

# Executa a função principal com o parâmetro de entrada
main "$1"
