{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    alsa-utils
    brightnessctl
    feh
    google-chrome
    playerctl
    rxvt-unicode
    speedcrunch
    touchegg
    xbindkeys
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
        sessionCommands = "

        ${pkgs.xorg.xmodmap}/bin/xmodmap ${pkgs.writeText "xkb-layout" ''
                  remove Mod4 = Super_L
                  add Control = Super_L
                ''}

        ${pkgs.xbindkeys}/bin/xbindkeys -f ${pkgs.writeText "xbindkeys-config" ''
                  "xdotool key --clearmodifiers ctrl+shift+Tab"
                    Release+Control+Shift + bracketleft
                  "xdotool key --clearmodifiers ctrl+Tab"
                    Release+Control+Shift + bracketright
                ''}
        ";
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

      touchpad = {
        disableWhileTyping = true;
        naturalScrolling = true;
      };
    };

    blueman.enable = true;
    pulseaudio.enable = false;
    touchegg.enable = true;
  };
}
