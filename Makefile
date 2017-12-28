.PHONY: all

all: perms
	@read -r -p "End user: " END_USER; \
		groupadd --gid 999 unifi; \
		useradd --gid 999 --uid 999 -M unifi; \
		adduser $$END_USER unifi

perms:
	chmod -R g+rwX unifi/
