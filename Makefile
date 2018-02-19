.PHONY: all owners perms certs test

all: owners perms $(ucerts)

cert = /etc/letsencrypt/live/unifi.gquad.space/cert.pem
chain = /etc/letsencrypt/live/unifi.gquad.space/chain.pem 
privkey = /etc/letsencrypt/live/unifi.gquad.space/privkey.pem 
certs = $(cert) $(chain) $(privkey)

ucert = unifi/cert/cert.pem
uchain = unifi/cert/chain.pem 
uprivkey = unifi/cert/privkey.pem 
ucerts = $(ucert) $(uchain) $(uprivkey)

userid := $(shell id -u)
uname := $(shell whoami)

owners:
ifeq ($(userid),0)
	groupadd --gid 999 unifi;
	useradd --gid 999 --uid 999 -M unifi;
	adduser $(uname) unifi
else
	@echo "This target requires root."
endif

perms:
ifeq ($(userid),0)
	chmod -R g+rwX unifi
else
	@echo "This target requires root."
endif

certbot-auto:
	wget https://dl.eff.org/certbot-auto
	chmod 0755 ./certbot-auto

certs: $(ucerts)

$(certs): certbot-auto
	./certbot-auto certonly --manual \
		--preferred-challenges dns \
		-d unifi.gquad.space

$(ucerts): $(certs)
ifeq ($(userid),0)
	cp $(cert) $(ucert)
	cp $(chain) $(uchain)
	cp $(privkey) $(uprivkey)
else
	@echo "This target requires root."
endif
