# Run with sudo, or Make won't be able to stat the cert files
# to know whether they have been generated or not, or to check
# their dates.

.PHONY: all owners perms test certinstall

all: owners perms $(ucerts)

cert = /etc/letsencrypt/live/unifi.gquad.space/cert.pem
chain = /etc/letsencrypt/live/unifi.gquad.space/chain.pem 
privkey = /etc/letsencrypt/live/unifi.gquad.space/privkey.pem 
certs = $(cert) $(chain) $(privkey)

ucert = unifi/cert/cert.pem
uchain = unifi/cert/chain.pem 
uprivkey = unifi/cert/privkey.pem 
ucerts = $(ucert) $(uchain) $(uprivkey)

uname := $(shell whoami)

owners:
	$(info $(uname))
	sudo groupadd --gid 999 unifi; \
		sudo useradd --gid 999 --uid 999 -M unifi; \
		sudo adduser $(uname) unifi

perms:
	sudo chmod -R g+rwX unifi

certbot-auto: ./certbot-auto
	wget https://dl.eff.org/certbot-auto
	chmod 0755 ./certbot-auto

renew: certbot-auto
	./certbot-auto certonly --manual \
		--preferred-challenges dns \
		-d unifi.gquad.space

certinstall: $(certs)
	sudo cp $(cert) $(ucert)
	sudo cp $(chain) $(uchain)
	sudo cp $(privkey) $(uprivkey)
