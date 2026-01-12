## Enable with eselect-repository
```
eselect repository add prosperouspotato-overlay git https://github.com/ProsperousPotato/prosperouspotato-overlay.git
```

## Enable manually
```
# cat > /etc/portage/repos.conf/prosperouspotato-overlay.conf << EOF
[prosperouspotato-overlay]
location = /var/db/repos/prosperouspotato-overlay
sync-type = git
sync-uri = https://github.com/ProsperousPotato/prosperouspotato-overlay.git
EOF
# emerge --sync prosperouspotato-overlay
```
