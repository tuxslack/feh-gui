#!/usr/bin/python3
#
#
# Interface gráfica para feh (Wallpapers)
#
# Por:        SobDex
# Data:       Março de 2023
# Atualizado: Fernando Souza - https://www.youtube.com/@fernandosuporte/
# Homepage:   https://github.com/tuxslack/Python
# Data da atualização: 12/11/2024 as 04:17:10
# Licença:    GPL
# 
# https://plus.diolinux.com.br/t/interface-grafica-para-feh-bg-scale-wallpapers/52052
#
# 
# 
# 
# 
# 
# Quem usa gerenciadores de janela em seus sistemas precisa de algum programa para definir 
# os papéis de parede. Sei que o nitrogen é bastante popular e completo, mas por questão 
# pessoal, sempre usei o feh na linha de comando mesmo.
# 
# Eu estava num daqueles dias que não tinha nada para fazer, então resolvi escrever esse 
# código para otimizar mais ainda o processo de setar os wallpapers com o feh (nem sei se 
# realmente precisava hahahah).
# 
# Dependências: tkinter, pillow ou PIL (Python Imaging Library).
#
# opcionais: Fonte Awesome e Fonte Inter (Caso não deseje usá-las é só mudar as fontes no 
# código).
# 
# 
# $ ./feh-gui.py 
# Traceback (most recent call last):
#   File "/home/fernando/shell_scripts/./feh-gui.py", line 38, in <module>
#     from tkinter import *
# ModuleNotFoundError: No module named 'tkinter'
# 
# No Void Linux:
#
# xbps-install -y python3-tkinter
# xbps-install -y python3-Pillow
# 
# 
# 
# Para funcionar, informe o caminho da pasta com wallpapers na variável "images_path" e 
# mude a palavra "user" para o nome do seu usuário lá na variável "fehbg" . A variável 
# fehbg também precisa de um caminho para salvar um arquivo de texto com o nome do 
# wallpaper extraído de do arquivo ${HOME}/.fehbg, por padrão ela cria um arquivo oculto 
# .default-img.txt na /tmp. Como usei fontes específicas (Awesome) também pode ser necessário 
# alterálas ou até mesmo o nome dos botões.
# 
# Quem tiver alguma idéia de melhorar o código ou dar alguma outra sugestão, fique à vontade.
# 
# 
# Segue abaixo uma imagem do programa.
# 
# https://plus.diolinux.com.br/uploads/default/original/3X/d/3/d35ae92fb4e5b60f9f93a26d680bcc80a4251721.jpeg
# 
# https://askubuntu.com/questions/890415/why-couldnt-i-use-instead-of-home-username-when-giving-the-file-pat
# https://www.hashtagtreinamentos.com/print-no-python


from tkinter import *
from PIL import ImageTk, Image

# importa modulo de operações do SO

import os




os.system(f"clear")


# Verifica se a fonte esta instalada no sistema

# fc-list | grep Awesome

# os.system(f"fc-list | grep Awesome")

# https://fontawesome.com/v5/download



# HOME = os.path.expanduser("~/")


# Define a lista de imagens

images_path = os.path.expanduser("~/Imagens")


print('Pasta padrão para os papéis de parede:', images_path) 

# print(images_path)

# print(HOME)

images = os.listdir(images_path)
current_image = -1  # Define -1 como valor padrão

# Define a função para mudar o papel de parede
def change_wallpaper(image_path):
    os.system(f"feh --bg-scale {image_path}")

# Define a função para exibir a imagem atual na label
def show_image(update_wallpaper=True):  # Adiciona parâmetro update_wallpaper
    global current_image
    if current_image >= 0:  # Verifica se já foi selecionada alguma imagem
        image_path = os.path.join(images_path, images[current_image])
        img = Image.open(image_path)
        img = img.resize((500, 300), Image.LANCZOS)
        img_tk = ImageTk.PhotoImage(img)
        label.config(image=img_tk)
        label.image = img_tk
        if update_wallpaper:  # Verifica se o papel de parede deve ser atualizado
            change_wallpaper(image_path)
        # Atualiza a legenda
        label_num.config(text=f"Imagem {current_image+1}/{len(images)}")

# Define a função para avançar para a próxima imagem
def next_image():
    global current_image
    current_image = (current_image + 1) % len(images)
    show_image()

# Define a função para voltar para a imagem anterior
def prev_image():
    global current_image
    current_image = (current_image - 1) % len(images)
    show_image()

# Define a função para exibir a imagem selecionada pelo usuário
def select_image():
    global current_image
    try:
        index = int(entry.get()) - 1
        if index >= 0 and index < len(images):
            current_image = index
            show_image()
    except ValueError:
        pass

# Cria a janela principal
root = Tk()
root.title("FehPy")
root.geometry('500x430')
root.minsize(500, 430)
root.maxsize(500, 430)
root.config(bg='#2B313C')

# Define a imagem padrão baseada no arquivo ${HOME}/.fehbg
fehbg = os.system('cat $HOME/.fehbg | grep ^feh | cut -c 27- > /tmp/.default-img.txt')
with open('/tmp/.default-img.txt', 'r') as feh_path:
    default_feh = feh_path.readlines()[0]
    actual_image = default_feh.replace('\n', '')
    imagem = actual_image.replace("'", "")
    img = imagem.replace(' ', '')
default_image_path = img

# Cria a label para exibir a imagem
label = Label(root, width=500, height=300)
label.pack()

# Cria a legenda para a imagem
label_num = Label(root, text="Imagem 0/0", bg='#2B313C', fg='#FFF', font=('Inter', 10))
label_num.pack()

# Cria a entrada para selecionar a imagem
entry = Entry(root, width=3, bg='#1A202B', fg='#FFF', font=('Inter', 10), insertbackground='#FFF')
entry.pack(pady=5)

# Cria o botão para exibir a imagem selecionada pelo usuário
button_select = Button(root, text="Selecionar", bg='#2B313C', fg='#FFF', font=('Inter', 10), command=select_image)
button_select.pack()

# Cria o botão para avançar para a próxima imagem
button_next = Button(root, text="", bg='#2B313C', fg='#FFF', font=('Awesome', 15), command=next_image)
button_next.pack(padx=5, pady=5, side=RIGHT)

# Cria o botão para voltar para a imagem anterior
button_prev = Button(root, text="", bg='#2B313C', fg='#FFF', font=('Awesome', 15), command=prev_image)
button_prev.pack(padx=5, pady=5, side=LEFT)

# Exibe a imagem padrão na label
img = Image.open(default_image_path)
img = img.resize((500, 300), Image.LANCZOS)
img_tk = ImageTk.PhotoImage(img)
label.config(image=img_tk)
label.image = img_tk

# Inicia o loop da interface gráfica
root.mainloop()

