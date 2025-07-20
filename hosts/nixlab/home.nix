{ config, pkgs, ... }:

{
  imports = [
    ../../users/vqphd/default.nix
    ../../modules/home/zsh.nix
    # Add more home-manager modules as needed
  ];

  home.username = "vqphd";
  home.homeDirectory = "/home/vqphd";
  home.stateVersion = "23.11";
}
