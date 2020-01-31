# Overview

This project is vim setting on linux for personal use.

# How to start

1. Clone this project
Access permission to clone may needed.

  `$ git clone git@github.com:tehloo/vim.git`
    
2. Change vim dir as hidden and make a link for vimrc
  ```
  $ mv ~/vim ~/.vim
  $ ln -s ~/.vim/.vimrc ~/.vimrc
  ```

3. Clone Vundle plugin

  `$ git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/vundle`
  
4. Start vim and install bundles using Vundle

  `:VundleInstall`
  
5. Enjoy ;D
