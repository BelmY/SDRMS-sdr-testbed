# SDR Testbed Docker image
#
# Copyright (C) 2019 Libre Space Foundation <https://libre.space/>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

FROM debian:buster
MAINTAINER Vasilis Tsiligiannis <acinonyx@openwrt.gr>

RUN apt-get update \
	&& apt-get install -y curl gpg \
	&& apt-key adv --fetch-keys "http://download.opensuse.org/repositories/home:/librespace:/satnogs/Debian_10/Release.key" \
	&& echo "deb http://download.opensuse.org/repositories/home:/librespace:/satnogs/Debian_10 ./" > /etc/apt/sources.list.d/satnogs.list \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		gnuradio \
		python3-pip \
	&& rm -rf /var/lib/apt/lists/*
