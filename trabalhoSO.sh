#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "Este script deve ser executado como root."
    exit 1
fi

check_cpu() {
    echo "=============================="
    echo "          USO DA CPU          "
    echo "=============================="
    mpstat | grep "all"
}

check_memory() {
    echo "=============================="
    echo "        USO DA MEMÓRIA         "
    echo "=============================="
    free -h
}

check_disk() {
    echo "=============================="
    echo "        ESPAÇO EM DISCO        "
    echo "=============================="
    df -h /
}

check_top_processes() {
    echo "=============================="
    echo "    PROCESSOS MAIS PESADOS     "
    echo "=============================="
    ps aux --sort=-%mem | head -n 10
}

check_uptime() {
    echo "=============================="
    echo "         TEMPO DE ATIVIDADE    "
    echo "=============================="
    uptime
}

show_menu() {
    echo "===================================="
    echo "   Monitoramento do Sistema"
    echo "===================================="
    echo "1. Verificar uso da CPU"
    echo "2. Verificar uso da memória"
    echo "3. Verificar espaço em disco"
    echo "4. Listar processos mais pesados"
    echo "5. Verificar tempo de atividade"
    echo "6. Sair"
    echo "===================================="
}

while true; do
    show_menu
    read -p "Escolha uma opção [1-7]: " OPTION
    case $OPTION in
        1)
            check_cpu
            ;;
        2)
            check_memory
            ;;
        3)
            check_disk
            ;;
        4)
            check_top_processes
            ;;
        5)
            check_uptime
            ;;
        6)
            echo "Saindo..."
            exit 0
            ;;
        *)
            echo "Opção inválida. Tente novamente."
            ;;
    esac
done
