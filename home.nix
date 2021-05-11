{ pkgs, lib, ... }:

let
  new-sh = pkgs.callPackage ./new-sh {};
in {
  home.packages = [ new-sh ];

  programs.direnv  = {
    enable = true;
    enableNixDirenvIntegration = true;
  };

  programs.git = {
    enable = true;
    userEmail = "mwg2202@yahoo.com";
    userName = "mwg2202";
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-airline-themes
      vim-surround
      vim-fugitive
      vim-gitgutter
      tender-vim
      vim-commentary
      vim-nix
      rust-vim
    ];
    extraConfig = ''
	  set number relativenumber       " set line-numbers to be relative
	  set nohlsearch                  " no highlight search
      syntax enable                   " enable syntax highlighting
      set mouse=a                     " recognize and enable mouse

      filetype plugin indent on       " automatic indention from file recognition
      set tabstop=4                   " show existing tab with 4 spaces width
      set shiftwidth=4                " when indenting with '>', use 4 spaces width
      set expandtab                   " on pressing tab, insert 4 spaces

      set termguicolors               " use terminal colors
      let g:airline_powerlin_fonts=1  " set airline theme
      colorscheme tender              " change the colorscheme
      let g:airline_theme = 'tender'  " change the colorscheme used by airline
    '';
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh.enable = true;
    oh-my-zsh.plugins = ["git"];
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./p10k-config;
        file = "p10k.zsh";
      }
    ];
    initExtra = ''
      unsetopt BEEP
      export DISPLAY=$(cat /etc/resolv.conf | awk '/nameserver/ {print $2}'):0
    '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    NIXPKGS_ALLOW_UNFREE = 1;
  };
  
  programs.home-manager.enable = true;
}
