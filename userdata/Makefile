

../user-data.txt:
	cat user-data.txt >$@
	cat kube-init.sh      | awk -v file=/usr/local/bin/kube-init  -f inline.awk >>$@
	cat kube-provision.sh | awk -v file=/usr/local/bin/kube-provision  -f inline.awk >>$@
	cat acme-config.sh    | awk -v file=/usr/local/bin/acme-config -f inline.awk >>$@
	cat traefik.toml      | awk -v file=/usr/local/etc/traefik.toml -f inline.awk >>$@
	cat traefik.service   | awk -v file=/usr/local/etc/traefik.service -f inline.awk >>$@
	cat traefik.yaml      | awk -v file=/usr/local/etc/traefik.yaml -f inline.awk >>$@
	cat sample.yaml       | awk -v file=/usr/local/etc/sample.yaml -f inline.awk >>$@

force:
	rm ../user-data.txt
	$(MAKE) ../user-data.txt
