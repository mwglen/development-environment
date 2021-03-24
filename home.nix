{ pkgs, lib, ... }:

{
  home.packages = [
    pkgs.htop
    pkgs.fortune
  ];

  programs.git.enable = true;

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
    ];
    extraConfig = ''
	  set number relativenumber
	  set nohlsearch
      set tabstop=4
      set shiftwidth=4
      set expandtab

      let g:airline_powerlin_fonts=1
      set termguicolors
      syntax enable
      colorscheme tender
      let g:airline_theme = 'tender'
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
  };
  
  
  programs.home-manager.enable = true;
}
