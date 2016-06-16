
VERSION=v${version}

v%:
	-git tag -a $@ -m "Release $@"
	git push origin $@

pkgdir: $(VERSION)
	mkdir -p turbo-happiness-${version}

tarball: pkgdir
	wget -O- https://www.github.com/grumps/turbo-happiness/tarball/$(VERSION) \
			 > turbo-happiness-${version}/turbo-happiness_${version}.orig.tar.gz	
	tar -C turbo-happiness-${version} -xf turbo-happiness-${version}/turbo-happiness_${version}.orig.tar.gz --strip-components=1
	cd turbo-happiness-${version} && dch --newversion ${version} "Release ${version}"

builddeb: tarball
	rm turbo-happiness-${version}/Makefile
	cd turbo-happiness-${version} && debuild -us -uc -b

addtorepo: builddeb
	aptly --config=/home/$(USER)/.aptly.conf repo add mjr turbo-happiness_${version}_amd64.deb
	aptly --config=/home/$(USER)/.aptly.conf snapshot create mjr-${version} from repo mjr

publish: addtorepo
	# add aws creds to env and publish
	. /home/$(USER)/.aws.sh && aptly --config=/home/$(USER)/.aptly.conf publish --gpg-key="97D14D14" switch squeeze s3:repo.resnick.li: mjr-${version}

release: publish
	@echo "package pushed."
