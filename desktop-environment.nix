{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    alsa-utils
    autorandr
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
                  # Chrome tab switching
                  "xdotool key --clearmodifiers ctrl+Page_Up"
                    Release+Control+Shift + bracketleft
                  "xdotool key --clearmodifiers ctrl+Page_Down"
                    Release+Control+Shift + bracketright
                  # Natural word navigation with Alt.
                  "xdotool key --clearmodifiers ctrl+BackSpace"
                    Release+Alt+BackSpace
                  "xdotool key --clearmodifiers ctrl+Left"
                    Release+Alt+Left
                  "xdotool key --clearmodifiers ctrl+Right"
                    Release+Alt+Right
                  # Page Up/Down
                  "xdotool key --clearmodifiers Page_Down"
                    Release+Alt+Down
                  "xdotool key --clearmodifiers Page_Up"
                    Release+Alt+Up
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
