{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  # Swap fn key behavior.
  boot.extraModprobeConfig = "options hid_apple fnmode=2";

  environment.systemPackages = with pkgs; [
    alsa-utils
    brightnessctl
    feh
    google-chrome
    playerctl
    rxvt-unicode
    speedcrunch
    touchegg
    xdotool
    xidlehook
    xsel
    xss-lock
  ];

  services = {
    xserver = {
      enable = true;

      displayManager = {
        lightdm.enable = true;
        sessionCommands =
          "${pkgs.xorg.xmodmap}/bin/xmodmap ${pkgs.writeText "xkb-layout" ''
            remove Mod4 = Super_L
            add Control = Super_L
          ''}";
      };

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu
          i3status
        ];
      };
    };

    libinput = {
      enable = true;
      touchpad.disableWhileTyping = true;
      touchpad.naturalScrolling = true;
    };

    blueman.enable = true;
    pulseaudio.enable = false;
    touchegg.enable = true;
  };
}
