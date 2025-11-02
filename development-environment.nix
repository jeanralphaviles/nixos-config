{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
in
{
  imports = [ (import "${home-manager}/nixos") ];

  home-manager.users.jraviles =
    { lib, ... }:
    {

      programs = {
        home-manager.enable = true;

        git = {
          enable = true;
          userEmail = "jeanralph.aviles@gmail.com";
          userName = "jeanralphaviles";
          extraConfig = {
            safe.directory = "/etc/nixos";
          };
        };
      };

      home = {
        stateVersion = "25.05";

        packages = with pkgs; [
          git
          htop
          python314
        ];

        activation = {
          installDotfiles = lib.hm.dag.entryAfter [ "installPackages" ] ''
            if [ ! -e "${config.users.users.jraviles.home}/.dotfiles" ]; then
              export PATH="${
                lib.makeBinPath (
                  with pkgs;
                  [
                    git
                    python314
                  ]
                )
              }:$PATH"
              run git clone "https://github.com/jeanralphaviles/dotfiles" "${config.users.users.jraviles.home}/.dotfiles"
              run "${config.users.users.jraviles.home}/.dotfiles/install"
            fi
          '';

          installVundle = lib.hm.dag.entryAfter [ "installPackages" ] ''
            if [ ! -e "${config.users.users.jraviles.home}/.vim/bundle/Vundle.vim" ]; then
              export PATH="${
                lib.makeBinPath (
                  with pkgs;
                  [
                    git
                    vim
                  ]
                )
              }:$PATH"
              run git clone "https://github.com/VundleVim/Vundle.vim.git" "${config.users.users.jraviles.home}/.vim/bundle/Vundle.vim"
            fi
          '';
        };

        file.".config/touchegg/touchegg.conf".text = ''
          <touchégg>
            <settings>
              <property name="animation_delay">150</property>
              <property name="action_execute_threshold">20</property>
            </settings>
            <application name="All">
              <gesture type="PINCH" fingers="2" direction="IN">
                <action type="SEND_KEYS">
                  <repeat>true</repeat>
                  <modifiers>Control_L</modifiers>
                  <keys>KP_Subtract</keys>
                </action>
              </gesture>
              <gesture type="PINCH" fingers="2" direction="OUT">
                <action type="SEND_KEYS">
                  <repeat>true</repeat>
                  <modifiers>Control_L</modifiers>
                  <keys>KP_Add</keys>
                </action>
              </gesture>
              <gesture type="SWIPE" fingers="3" direction="LEFT">
                <action type="MOUSE_CLICK">
                  <button>9</button>
                </action>
              </gesture>
              <gesture type="SWIPE" fingers="3" direction="RIGHT">
                <action type="MOUSE_CLICK">
                  <button>8</button>
                </action>
              </gesture>
            </application>
          </touchégg>
        '';
      };
    };

  programs.zsh.enable = true;
  users.users.jraviles.shell = pkgs.zsh;
}
