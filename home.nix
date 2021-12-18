{ pkgs, lib, ... }:

let
  new-sh = pkgs.callPackage ./new-sh {};
  
  # Used to link with drivers
  # drivers = [
    # pkgs.linuxKernel.packages.linux_zen.nvidia_x11_beta
    # pkgs.linuxKernel.packages.linux_zen.nvidia_x11_vulkan_beta
  # ];
in {
  home.packages = with pkgs; [ 
    new-sh 
    pipenv
    # swaylock
    # swayidle
    # wl-clipboard
    # mako
    # alacritty
    # dmenu
    # mpv
    # pipewire
    # ncpamixer
    # alsaPlugins
    # ecdsautils
  ];
  
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    NIXPKGS_ALLOW_UNFREE = 1;

    # OpenGL support
    # LIBGL_DRIVERS_PATH = lib.makeSearchPathOutput "lib" "lib/dri" drivers;
    # LD_LIBRARY_PATH = lib.makeLibraryPath drivers;
    # LOCALE_ARCHIVE = "/usr/lib/locale/locale-archive";
  };
  
  # Audio Support
  # home.file.".asoundrc".text = ''
  #   pcm_type.pulse {
      # libs.native = "${pkgs.alsaPlugins}/lib/alsa-lib/libasound_module_pcm_pulse.so";
      # libs.32Bit = "${pkgs.pkgsi686Linux.alsaPlugins}/lib/alsa-lib/libasound_module_pcm_pulse.so";
    # }
    
    # ctl_type.pulse {
      # libs.native = "${pkgs.alsaPlugins}/lib/alsa-lib/libasound_module_ctl_pulse.so";
      # libs.32Bit = "${pkgs.pkgsi686Linux.alsaPlugins}/lib/alsa-lib/libasound_module_ctl_pulse.so";
    # }
    
    # pcm_type.jack {
      # libs.native = "${pkgs.alsaPlugins}/lib/alsa-lib/libasound_module_pcm_jack.so";
      # libs.32Bit = "${pkgs.pkgsi686Linux.alsaPlugins}/lib/alsa-lib/libasound_module_pcm_jack.so";
    # }
  # '';

  
  # Applications

  programs.direnv  = {
    enable = true;
    enableNixDirenvIntegration = true;
  };

  programs.git = {
    enable = true;
    userEmail = "mwg2202@yahoo.com";
    userName = "mwglen";
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
      emmet-vim
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
      if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi

      # if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
      #  	exec sway --my-next-gpu-wont-be-nvidia
      # fi

      unsetopt BEEP

      # eval "$(/home/mwglen/anaconda3/bin/conda shell.zsh hook)"
      
      # export LLVMENV_RUST_BINDING=1
      # source <(llvmenv zsh)

    '';
  };

  # wayland.windowManager.sway = {
  #   enable = true;
  #   wrapperFeatures.gtk = true;
  # };

  programs.home-manager.enable = true;
}
