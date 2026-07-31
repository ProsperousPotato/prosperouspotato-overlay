## Enable with eselect-repository
```
eselect repository add prosperouspotato-overlay git git://git.adamsucks.me/prosperouspotato-overlay

emerge --sync prosperouspotato-overlay
```

## Enable manually
```
cat > /etc/portage/repos.conf/prosperouspotato-overlay.conf << EOF
[prosperouspotato-overlay]
location = /var/db/repos/prosperouspotato-overlay
sync-type = git
sync-uri = git://git.adamsucks.me/prosperouspotato-overlay
EOF
emerge --sync prosperouspotato-overlay
```
