{ config, pkgs, lib, inputs, system, ... }:

let
  dotfilesDir = "/home/vqphd/Projects/nixlab/users/vqphd/dotfiles";
  outOfStore = config.lib.file.mkOutOfStoreSymlink;

  mkDotfiles = files:
    lib.listToAttrs (map (file: {
      name = file;
      value = { source = outOfStore "${dotfilesDir}/${file}"; };
    }) files);
in {
  home.username = "vqphd";
  home.homeDirectory = "/home/vqphd";

  # Your other home-manager config here
  home.packages = with pkgs; [
    inputs.zen-browser.packages."${system}".default
    lua
    postman
    anki-bin
    zathura
  ];

  xdg.enable = true;
  gtk.enable = true;

  gtk.theme.name = "Catppuccin-Dark";

  home.file = mkDotfiles [
    ".p10k.zsh"
    ".alacritty.toml"
    "dracula.toml"
    ".tmux.conf"
    ".config/nvim"
    ".config/bspwm"
    ".config/sxhkd"
    ".config/polybar"
    ".config/picom"
    ".config/zathura"
    ".zshrc_custom"
    ".themes"
    ".local/share/fcitx5"
    "fcitx5"
    "wallpapers"
    ".local/share/themes/Catppuccin-Dark"
  ];

  home.sessionVariables = { GTK_THEME = "Catppuccin-Dark"; };
  programs.git = {
    enable = true;
    userName = "vqphd";
    userEmail = "veaquer@gmail.com";
    extraConfig = { init.defaultBranch = "main"; };
  };

  programs.home-manager.enable = true;
}
