#!/usr/bin/env -S just --justfile

clone:
    @echo "Clonando o repositório outside-bringup"
    vcs import < bringup.repos
    @echo "Repositório outside-bringup clonado com sucesso!"

    @echo "Importando demais repositórios dentro de outside-bringup/src..."
    vcs import outside-bringup/src < outside.repos --recursive
    @echo "Configuração inicial concluída!"

