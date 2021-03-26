.PHONY : all wheel deb clean test

version = $(shell python3 setup.py --version)
wheel = rse-$(version)-py2-none-any.whl
deb_rse = rse_$(version)_all.deb
deb_pyrse = python3-rse_$(version)_all.deb
fpm_pyopts = -f -s python -t deb --depends python3 \
             --python-bin python3 --python-package-name-prefix python3 --python-pip /usr/bin/pip3 --python-disable-dependency pyyaml

all : wheel deb

builddeps :
	cat deps/build.apt.txt | xargs apt install -y
	cat deps/build.gem.txt | xargs gem install --user-install

wheel :
	python3 setup.py bdist_wheel

deb_deps :
	fpm $(fpm_pyopts) newrelic
	fpm $(fpm_pyopts) moecache
	mv -v *.deb *.gz dist

deb : 
	mkdir -p dist
	fpm $(fpm_pyopts) \
		-d python3-yaml \
		-d python3-newrelic \
		--python-install-data /etc \
		setup.py
	mv -v *.deb dist
	# ls -t dist/*.deb | head -n1 | xargs dpkg --info

test :
	pylint -E src
	pytest-3

cov :
	pytest-3 --cov src --cov-report term-missing

clean :
	-rm -rf build dist src/*.egg-info .tox
