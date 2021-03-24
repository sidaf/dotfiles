# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew recipes need Homebrew/Linuxbrew instaled." && return 1

repos=(
  sidaf/pentest
)
brew_tap_repos

# Common recipes
recipes=(
  arp-scan
  brew-pip
  nmap
  perl
  python
  python3
  wget
)
brew_install_recipes

# OSX specific recipes
if is_osx ; then
  recipes=(
    bash-completion
  )
  brew_install_recipes
fi

# Linux specific recipes
if is_linux ; then
  recipes=(
    jdk
  )
  brew_install_recipes
fi

echo ""
echo "Install penetration testing related recipies?  (y/n)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  # Pentest recipes
  recipes=(
    exploitdb
    hydra
    ike-scan
    masscan
    mysql
    ophcrack
    p0f
    postgresql
    # Information gathering
    sidaf/pentest/cewl
    sidaf/pentest/dnsrecon
    sidaf/pentest/enum4linux
    sidaf/pentest/netdiscover
    sidaf/pentest/polenum
    sidaf/pentest/praeda
    sidaf/pentest/recon-ng
    sidaf/pentest/ridenum
    sidaf/pentest/scrape_dns
    sidaf/pentest/simply_email
    sidaf/pentest/snmpcheck
    sidaf/pentest/the_harvester
    sidaf/pentest/wafw00f
    sidaf/pentest/wig
    # Vulnerability analysis
    #sidaf/pentest/aircrack-ng
    sidaf/pentest/iker
    sidaf/pentest/header_check
    sidaf/pentest/nfsshell
    sidaf/pentest/nopc
    sidaf/pentest/rdp-sec-check
    sidaf/pentest/serializekiller
    sidaf/pentest/sslscan-static
    sidaf/pentest/ssl-cipher-suite-enum
    sidaf/pentest/testssl-static
    sidaf/pentest/vfeed
    sidaf/pentest/wfuzz
    sidaf/pentest/windows-exploit-suggester
    sidaf/pentest/wpscan
    sidaf/pentest/yasuo
    # Exploitation
    sidaf/pentest/armitage
    sidaf/pentest/bettercap
    sidaf/pentest/crackmapexec
    sidaf/pentest/clusterd
    sidaf/pentest/commix
    sidaf/pentest/frogger
    sidaf/pentest/ikeforce
    sidaf/pentest/impacket
    sidaf/pentest/inception
    sidaf/pentest/metasploit-framework
    sidaf/pentest/mitmf
    sidaf/pentest/odat
    sidaf/pentest/panoptic
    sidaf/pentest/responder
    sidaf/pentest/sqlmap-extra
    sidaf/pentest/wifite
    sidaf/pentest/ysoserial
    # Post exploitation
    sidaf/pentest/babel-sf
    sidaf/pentest/egressbuster
    sidaf/pentest/empire
    sidaf/pentest/laudanum
    sidaf/pentest/nishang
    sidaf/pentest/posh-secmod
    sidaf/pentest/powersploit
    sidaf/pentest/pykek
    sidaf/pentest/tater
    sidaf/pentest/unicorn
    # Password recovery
    sidaf/pentest/cowpatty
    sidaf/pentest/crunch
    sidaf/pentest/hashcat-legacy
    sidaf/pentest/hashcat-utils
    sidaf/pentest/hashid
    sidaf/pentest/john-jumbo
    # Wordlists
    sidaf/pentest/fuzzdb
    sidaf/pentest/sec_lists
    sidaf/pentest/robots_disallowed
  )
  brew_install_recipes
fi
