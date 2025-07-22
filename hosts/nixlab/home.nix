{ config, pkgs, ... }:

{
  imports = [
    ../../users/vqphd/default.nix
    ../../modules/home/zsh.nix
    # Add more home-manager modules as needed
  ];

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 22;
  };

  home.username = "vqphd";
  home.homeDirectory = "/home/vqphd";
  home.stateVersion = "23.11";
}
