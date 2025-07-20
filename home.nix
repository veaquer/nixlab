{ config, pkgs, lib,inputs, system, ... }:

let
  dotfilesDir = ./dotfiles;

  # Recursively collects all relative file paths in dotfiles/
  collectFiles = path:
    let
      fullPath = "${dotfilesDir}/${path}";
      entries = builtins.readDir fullPath;
    in
      lib.concatMapAttrs (name: type:
        let
          relPath = "${path}/${name}";
        in
        if type == "directory" then
          collectFiles relPath
        else
          {
            "${relPath}" = {
              source = "${dotfilesDir}/${relPath}";
              # Mark `bspwmrc` and `sxhkdrc` executable
              executable = lib.elem name [ "bspwmrc" "sxhkdrc" ];
            };
          }
      ) entries;

  # Merge all results under `home.file`
  flatSymlinks = collectFiles ".";
in {
  home.username = "vqphd";
  home.homeDirectory = "/home/vqphd";

  # Your other home-manager config here
  home.packages = with pkgs; [
    inputs.zen-browser.packages."${system}".default
  ];

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "";
      plugins = [ "git" "z" "sudo" "extract" ];
    };

    initContent = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      if [ -f ${config.home.homeDirectory}/.zshrc_custom ]; then
        source ${config.home.homeDirectory}/.zshrc_custom
      fi

      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
    '';
    };

  # programs.tmux = {
  #   enable = true;
  #
  #          plugins = with pkgs.tmuxPlugins; [
  #   yank
  #   {
  #     plugin = dracula;
  #   }
  #         ];
  # };

  gtk.enable = true;
  
  gtk.theme.name = "Catppuccin-Dark";

  home.file = flatSymlinks;

  home.sessionVariables = {
  GTK_THEME = "Catppuccin-Dark";
  }; 
  programs.git = {
    enable = true;
    userName = "vqphd";
    userEmail = "veaquer@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}

