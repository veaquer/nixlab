{ config, pkgs, lib,inputs, system, ... }:

let
  dotfilesDir = builtins.filterSource (path: type: true) ./dotfiles;

  collectFiles = path:
    let
      fullPath = "${dotfilesDir}/${path}";
      entries = builtins.readDir fullPath;
    in
      lib.concatMapAttrs (name: type:
        let
          relPath = "${path}/${name}";
          homePath = lib.removePrefix "./" relPath;
        in
          if type == "directory" then
            collectFiles relPath
          else {
            "${homePath}" = {
              source = "${dotfilesDir}/${relPath}";
              executable = builtins.elem name [ "bspwmrc" "sxhkdrc" ];
            };
          }
      ) entries;

  flatSymlinks = collectFiles "";
in {
  home.username = "vqphd";
  home.homeDirectory = "/home/vqphd";

  # Your other home-manager config here
  home.packages = with pkgs; [
    inputs.zen-browser.packages."${system}".default
  ];

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


  programs.home-manager.enable = true;
}


