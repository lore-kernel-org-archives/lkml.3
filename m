Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab3GMGil (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 02:38:41 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:61460 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab3GMGij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 02:38:39 -0400
Date: Fri, 12 Jul 2013 23:38:36 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.11-rc0
Message-ID: <20130713063836.GA6173@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive 2nd round of updates for the input subsystem. You will get an
update to Elantech driver to support hardware v7, fix to the new cyttsp4
driver to use proper addressing, ads7846 git device tree support and
nspire-keypad got a small cleanup.

Changelog:
---------

Daniel Mack (1):
      Input: ads7846 - add device tree bindings

Daniel Tang (1):
      Input: nspire-keypad - replace magic offset with define

Dmitry Torokhov (1):
      Input: ads7846 - make sure we do not change platform data

Ferruh Yigit (1):
      Input: cyttsp4 - use 16bit address for I2C/SPI communication

Matteo Delfino (1):
      Input: elantech - fix for newer hardware versions (v7)


Diffstat:
--------

 .../devicetree/bindings/input/ads7846.txt          |  91 +++++++++++++++
 drivers/input/keyboard/nspire-keypad.c             |   2 +-
 drivers/input/mouse/elantech.c                     |  17 +--
 drivers/input/touchscreen/ads7846.c                | 123 +++++++++++++++++=
+---
 drivers/input/touchscreen/cyttsp4_core.h           |  12 +-
 drivers/input/touchscreen/cyttsp4_spi.c            |  20 ++--
 drivers/input/touchscreen/cyttsp_core.h            |   8 +-
 drivers/input/touchscreen/cyttsp_i2c_common.c      |  30 +++--
 drivers/input/touchscreen/cyttsp_spi.c             |   6 +-
 9 files changed, 253 insertions(+), 56 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/ads7846.txt

--=20
Dmitry


--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJR4PXsAAoJEH70+W8r6ZYq7WYP/jQero2YNjefi93CvsG56zHy
5A2upuIIEq5NBaia3OamRaYdgcRq25I//qg2NZSwMD2bVIjwhOR3IZA75YwA7RfG
gbfRCLyOOu3WgC4Qk5XaNKJ1J0Vf0UUOkKs57emSbjwzCAXY3AoyRc3Qm+wUvmIk
IuJ6785cg3N12IcM+JDXz9IK9DmYw1EDchF0eQxyvkiXBnYVO6Ez+46wWCCk3ZWg
6OdANcpZBqHbXcB79Txv0NTmHQbXXqFmoPD5wg+zstTjvpV2SNiPWofmS/IiJoUW
8s4jMsjo7Y9FFrUydY2Vej/Izi+bU8ArcO/uWl7jHiPzCQM41jnB4nWtPy+S1iRQ
Z8bqUS4XA5/G3zC4F3exRKG0gCBL8niI+LXv/KlnIKnbwf98GcgkjJmQlOjbsJtd
ZeQdQ0B8iomZLZzcGGm2FMCe1cbV03sAugmpdMGDu8OIhj8GYMyCm0IlAkPBqVtY
587+d0YpZzUJQgHigwPPYuvIg/z4//t0d1H7JQYzxI3Tf21I/mPNJfVue/paOV/8
pZ4QJnSGu9QUqpznNrCtlGvvxLDpzDzS9FaxQfwE/OUjLPDD+1qZXkvZK2/ILL2x
dtV5O4Yzji8oV0qmv6pN5pXiZ1e95yj7EThg5y5TDsrs3MrxtgNQ9gAw6kEGRctf
GdJYs5Ydm+KcUp4W3bdw
=aIkz
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
