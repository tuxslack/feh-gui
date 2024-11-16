#!/bin/bash
#
# --------------------------------------------------------------
# Projeto	: feh-gui
# Arquivo	: install-feh-gui.sh
# Descrição : Script de instalação para o feh-gui
# Versão	: 1.0
# Data		: 16/11/2024 as 02:57:41
# Autor		: Fernando Souza - https://www.youtube.com/@fernandosuporte/
# --------------------------------------------------------------

# Baseado no: https://github.com/SobDex/biblia-offline/blob/main/install.sh

# https://kinsta.com/pt/base-de-conhecimento/extrair-descompactar-arquivos-tar-gz-linux-windows/


# URL do repositório Git

REPO_URL="https://github.com/tuxslack/feh-gui.git"


# Arquivos do programa

    DESKTOP_FILE="$HOME/.local/share/applications/feh-gui.desktop"
    config_FILE="$HOME/.config/feh-gui.conf"
    programa="/usr/local/bin/feh-gui.py"


clear


# ----------------------------------------------------------------------------------------

        # Não roda esse script neste computador

        if [ "$HOSTNAME" == "kurumin" ] ; then

            echo -e "\nErro: Esse script não pode ser executado neste computador: $HOSTNAME\n"

            exit 1

        fi

# ----------------------------------------------------------------------------------------



# Função de instalação

install() {

    clear


# ----------------------------------------------------------------------------------------

    echo "Instalando o feh-gui..."

    # Verificar se as dependências estão instaladas

    for cmd in git curl unzip tar ping notify-send; do
        if ! command -v "$cmd" &> /dev/null; then
            echo "Erro: o pacote $cmd não está instalado. Instale-o e tente novamente."
            exit 1
        fi
    done


# ----------------------------------------------------------------------------------------

echo "
Testando se a conexão com a internet está ativa...
"


ping  -c 1 www.google.com.br 2>&1 >/dev/null


if [ $? = 0 ]; then


                     notify-send -t 100000 -i /usr/share/icons/hicolor/scalable/apps/nm-device-wired.svg  'Atenção!' "Você esta com acesso à internet..."
                     
else


# Falso positivo:
#
# Conexão de internet sobrecarregada
# Conexão com à internet muito lenta

                     notify-send --urgency=critical -t 100000 -i /usr/share/icons/hicolor/scalable/apps/nm-no-connection.svg 'Atenção!'  "Ocorreu um problema de rede, você está \nsem acesso à internet..."

                     exit 2
fi

# ----------------------------------------------------------------------------------------



    # Criar diretório oculto na home do usuário

    INSTALL_DIR="$HOME/feh-gui"
    mkdir -p "$INSTALL_DIR"


    # Clonar o repositório se o diretório não existir

    if [ ! -d "$INSTALL_DIR/.git" ]; then
        echo "Clonando o repositório..."
        git clone "$REPO_URL" "$INSTALL_DIR" || { echo "Erro ao clonar o repositório."; exit 1; }
    fi

    # Ir para o diretório de instalação

    cd "$INSTALL_DIR" || { echo "Erro ao acessar o diretório de instalação."; exit 1; }


# ----------------------------------------------------------------------------------------

    # Verificar se o arquivo feh-gui.tar.gz existe no diretório

     echo "Verificando se feh-gui.tar.gz existe..."

    if [ -f "feh-gui.tar.gz" ]; then

        echo "Arquivo feh-gui.tar.gz encontrado. Descompactando..."

        # unzip -oq feh-gui.zip -d "$INSTALL_DIR/feh-gui"

        tar -xf feh-gui.tar.gz  # -C "$INSTALL_DIR/feh-gui"

        # Remover o arquivo compactado
        # rm feh-gui.tar.gz

    else
        echo "Erro: O arquivo feh-gui.tar.gz não foi encontrado no repositório."
        exit 1
    fi

# ----------------------------------------------------------------------------------------


    # Verificar se o diretório $HOME/.local/share/applications existe, se não, criar e avisar o usuário

    if [ ! -d "$HOME/.local/share/applications" ]; then

        echo "O diretório $HOME/.local/share/applications não existe. Criando agora..."

        mkdir -p "$HOME/.local/share/applications"
    fi

# ----------------------------------------------------------------------------------------


    echo "Instalando..."

    cp .local  ~/
    cp .config ~/

    echo -e "\nInforme a senha do usuário Root agora:\n"

    su -c "cp usr /"


    # Verificar se a instalação foi concluída

    echo "Checando instalação..."


    if [ -d "$INSTALL_DIR" ] && [ -f "$DESKTOP_FILE" ] && [ -f "$config_FILE" ] && [ -f "$programa" ]; then

        echo -e "\nInstalação concluída! O programa feh-gui pode ser encontrado no menu de aplicativos do sistema."
        echo "Para executar o programa através da linha de comando, use:"
        echo "python $INSTALL_DIR/usr/local/bin/feh-gui.py"

    else

        echo "Erro: A instalação não foi concluída corretamente."
        echo "Execute o script de instalação novamente e escolha a opção Desinstalar"
        echo "Ou, se preferir, remova o diretório $HOME/feh-gui, $programa, $config_FILE e o arquivo $DESKTOP_FILE"
        
        exit 1
    fi

# ----------------------------------------------------------------------------------------


}




# Função de desinstalação

uninstall() {

    clear

# ----------------------------------------------------------------------------------------

    echo "Checando a instalação do feh-gui..."

    # Remover o diretório de instalação, se existir
    # if [ -d "$HOME/feh-gui" ]; then
    #     echo "Removendo diretório $HOME/feh-gui..."
    #     rm -rf "$HOME/feh-gui"
    # else
    #     echo "O diretório $HOME/feh-gui não foi encontrado."
    # fi



    # Remover o arquivo .py, se existir

     if [ -f "$programa" ]; then
         echo "Removendo o arquivo .py $programa..."
         su -c "rm $programa"
     else
         echo "O arquivo .py não foi encontrado."
     fi


    # Remover o arquivo .conf, se existir

     if [ -f "$config_FILE" ]; then
         echo "Removendo o arquivo .conf $config_FILE..."
         rm "$config_FILE"
     else
         echo "O arquivo .conf não foi encontrado."
     fi


    # Remover o arquivo .desktop, se existir

     if [ -f "$DESKTOP_FILE" ]; then
         echo "Removendo o arquivo .desktop $DESKTOP_FILE..."
         rm "$DESKTOP_FILE"
     else
         echo "O arquivo .desktop não foi encontrado."
     fi


    echo "Desinstalação concluída!"

# ----------------------------------------------------------------------------------------


}



# ----------------------------------------------------------------------------------------


# Função principal com case para selecionar as opções

menu() {
    echo "Escolha uma opção:"
    echo "1) Instalar"
    echo "2) Desinstalar"
    echo "3) Sair"
    read -rp "Opção: " option

    case $option in
        1) install ;;
        2) uninstall ;;
        3) clear && exit 1 ;;
        *) clear && echo "Opção inválida." ;;
    esac
}


# Executar menu

menu

# ----------------------------------------------------------------------------------------

exit 0

