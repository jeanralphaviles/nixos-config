{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  nixpkgs.config.allowUnfree = true;

  # Swap fn key behavior on Apple keyboards.
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
                  "xdotool sleep 0.25 key Tab"
                    Control+Shift + bracketleft
                  "xdotool sleep 0.25 keyup Shift key Tab keydown Shift"
                    Control+Shift + bracketright
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
