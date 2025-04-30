#!/bin/bash

# ---------------------------------------
# Script Interativo de Pós-Instalação para Ubuntu
# Autor: Vitório Santos
# ---------------------------------------

confirmar() {
  read -p "$1 (s/n): " escolha
  [[ "$escolha" =~ ^[Ss]$ ]]
}

echo "===> Script de Pós-Instalação para Ubuntu <==="

# Atualização do sistema
if confirmar "Deseja atualizar o sistema?"; then
  sudo apt update -y && sudo apt upgrade -y
fi

# Instalação de pacotes essenciais
if confirmar "Deseja instalar os pacotes essenciais para desenvolvimento?"; then
  sudo apt install -y \
    git curl wget build-essential dkms perl \
    gcc make default-libmysqlclient-dev libssl-dev \
    zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
    llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev \
    libffi-dev liblzma-dev python3-openssl
fi

# Instalação do Zsh e plugins
if confirmar "Deseja instalar e configurar o Zsh com Oh My Zsh e plugins?"; then
  sudo apt install -y zsh
  chsh -s /bin/zsh

  echo "Instalando Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  echo "Instalando plugin zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

  echo "Instalando plugin zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

  echo -e "\nLembre-se de editar ~/.zshrc e adicionar:"
  echo "  plugins=(git zsh-autosuggestions zsh-syntax-highlighting)"
  echo "E ao final do arquivo, adicione:"
  echo "  source \$ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Personalização da Dock
if confirmar "Deseja personalizar a barra Dock do GNOME?"; then
  gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
  gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
  gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'FIXED'
  gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 48
  gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0.25
  gsettings set org.gnome.shell.extensions.dash-to-dock isolate-workspaces false
  gsettings set org.gnome.shell.extensions.dash-to-dock custom-theme-shrink true
  gsettings set org.gnome.shell.extensions.dash-to-dock running-indicator-style 'DOTS'
  gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
  gsettings set org.gnome.desktop.interface monospace-font-name 'Monospace 18'
fi

echo -e "\nConcluído! Reinicie o terminal para aplicar todas as mudanças."
