(define-module (config home-environments shared packages)
  #:use-module (gnu packages)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages disk)
  #:use-module (gnu packages dns)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages hunspell)
  #:use-module (gnu packages kde-graphics)
  #:use-module (gnu packages kde-plasma)
  #:use-module (gnu packages kde-utils)
  #:use-module (gnu packages libreoffice)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages music)
  #:use-module (gnu packages pdf)
  #:use-module (gnu packages shellutils)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages rust-apps)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages text-editors)
  #:use-module (gnu packages tmux)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages video)
  #:use-module (gnu packages web)
  #:use-module (gnu packages window-management)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xfce)
  #:use-module (gnu packages xorg)

  #:use-module (nongnu packages password-utils)

  #:use-module (config packages terminals)
  #:use-module (config packages xdisorg)

  #:use-module ((rosenthal packages shellutils)
                #:prefix ros:)

  #:use-module (saayix packages binaries)

  #:export (cli
            desktop
            development
            fonts))

(define cli
  (list
    #|disk      |# yazi
    #|rust-apps |# fd ripgrep zoxide
    #|shellutils|# direnv ros:stinkpot
    #|terminals |# fzf
    #|xdisorg   |# carapace-bin wl-clipboard

    ;; For yazi
    #|compression|# 7zip
    #|pdf        |# poppler
    #|video      |# ffmpeg
    #|web        |# jq))

(define desktop
  (list
    ;; TODO: Get easyeffects updated
    #|audio            |# #;easyeffects
    #|dns              |# avahi
    #|freedesktop      |# xdg-desktop-portal-gtk
    #|gnome            |# xdg-desktop-portal-gnome gnome-keyring libsecret (specification->package "gcr@3") dconf
    #|hunspell         |# hunspell hunspell-dict-en-us
    #|kde-graphics     |# gwenview
    #|kde-plasma       |# polkit-kde-agent
    #|kde-utils        |# kate
    #|libreoffice      |# libreoffice
    #|linux            |# brightnessctl
    #|music            |# playerctl
    #|password-utils   |# bitwarden-desktop
    #|pdf              |# zathura
    #|saayix binaries  |# zen-browser-bin
    #|terminals        |# foot
    #|video            |# mpv
    #|window-management|# mako niri swaylock swayidle waybar
    #|xdisorg          |# dex fuzzel rofi rofi-themes-collection-git
    #|xfce             |# thunar
    #|xorg             |# xwayland-satellite))

(define development
  (list
    #|gnupg          |# gnupg
    #|ssh            |# openssh
    #|text-editors   |# helix
    #|tmux           |# tmux
    #|version-control|# git jujutsu))

(define fonts
  (list
    font-adobe-source-sans
    font-adobe-source-serif
    font-fira-mono
    font-google-noto
    font-google-noto-emoji
    font-nerd-symbols))
