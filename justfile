#!/usr/bin/env -S just --justfile

clone-and-setup:
    @echo "Clonando o repositório outside-bringup"
    vcs import < bringup.repos
    @echo "Repositório outside-bringup clonado com sucesso!"

    @echo "Importando submódulos de outside.repos dentro de outside-bringup/src..."
    vcs import outside-bringup/src < outside.repos
    @echo "Configuração inicial concluída!"

