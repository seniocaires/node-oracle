#!bin/bash

  echo "Clonando o repositorio "${GITHUB_NODE_ORACLE_REPOSITORY_NAME}"..."
  rm -rf /tmp/node-oracle
  url_repositorio="https://"${GITHUB_USER_NAME}:${GITHUB_PASSWORD}@github.com/${GITHUB_USER_NAME}/${GITHUB_NODE_ORACLE_REPOSITORY_NAME}".git"
  cd /tmp
  git clone ${url_repositorio} node-oracle
  echo "Repositorio clonado em /tmp/node-oracle!"

  echo "Executando scraper"
  ./scraper.sh

  cd /tmp/node-oracle
  echo "Configurando git (autor) ..."
  git config user.name ${GIT_CONFIG_USER_NAME}
  git config user.email ${GIT_CONFIG_USER_EMAIL}
  echo "Adicionando para Stage Area ..."
  git add .
  echo "Commit ..."
  git commit -m "Alteracao do arquivo last_check_date_file"
  echo "Push ..."
  git push ${url_repositorio} --all
