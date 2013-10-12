Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab3JLGU6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 02:20:58 -0400
Received: from sauhun.de ([89.238.76.85]:49834 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393Ab3JLGU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 02:20:57 -0400
Date: Sat, 12 Oct 2013 08:20:51 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.12
Message-ID: <20131012062046.GA3227@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Linus,

we had various reports of problems with deferred probing in the I2C
subsystem, so this pull requst is a little bigger than usual. Most
issues should be addressed now so devices will be found correctly. A few
ususal driver bugfixes are in here, too. Please pull.

Thanks,

   Wolfram


The following changes since commit d0e639c9e06d44e713170031fe05fb60ebe680af:

  Linux 3.12-rc4 (2013-10-06 14:00:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-current

for you to fetch changes up to 2737de460e33df89461a59b247d3bfd477101785:

  i2c: i2c-mux-pinctrl: use deferred probe when adapter not found (2013-10-10 10:22:35 +0200)

----------------------------------------------------------------
Ionut Nicu (2):
      i2c: i2c-mux-gpio: don't ignore of_get_named_gpio errors
      i2c: i2c-mux-gpio: use deferred probing

Jean Delvare (1):
      i2c: Not all adapters have a parent

Taras Kondratiuk (1):
      i2c: omap: Clear ARDY bit twice

Wolfram Sang (6):
      i2c: i2c-designware-platdrv: replace platform_driver_probe to support deferred probing
      i2c: i2c-imx: replace platform_driver_probe to support deferred probing
      i2c: i2c-mxs: replace platform_driver_probe to support deferred probing
      i2c: i2c-stu300: replace platform_driver_probe to support deferred probing
      i2c: i2c-arb-gpio-challenge: use deferred probe when adapter not found
      i2c: i2c-mux-pinctrl: use deferred probe when adapter not found

 drivers/i2c/busses/i2c-designware-platdrv.c |  5 +++--
 drivers/i2c/busses/i2c-imx.c                | 11 ++++++-----
 drivers/i2c/busses/i2c-mxs.c                |  3 ++-
 drivers/i2c/busses/i2c-omap.c               |  3 +++
 drivers/i2c/busses/i2c-stu300.c             | 11 +++++------
 drivers/i2c/i2c-core.c                      |  3 +++
 drivers/i2c/muxes/i2c-arb-gpio-challenge.c  |  2 +-
 drivers/i2c/muxes/i2c-mux-gpio.c            | 14 +++++++++-----
 drivers/i2c/muxes/i2c-mux-pinctrl.c         |  4 ++--
 9 files changed, 34 insertions(+), 22 deletions(-)

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSWOo+AAoJEBQN5MwUoCm2ifIP/1gWndg2dEeoCTARCrcK8Iyc
z4YP0FFtNOw766LH8I3geP35ZwelBzjZX2C6natHIFWJvh7KitOf/5NYrz6fxErl
RZZmTEkso7jA4K1S1tkHZmEW1stfeYW4pd2bUfkVZzbbrVUIM14/7+hvJ54WOwGf
Vj9sFpBAwfpmeN0o9tQNrU9MXURjIvqmu9jY7mx4+VX9O+vEkbK3xMaWjBC4Z4s4
fGon7Wa3FnfoNQqtF3KSkgKqc0RMYIUkgxisIbKaFCCbu+yo1NgkiJw4eFmOpul7
9ShOG61GUZY5A0wKdrmD5Nxb3rV7NUs9wmzSySPZxasU0DgIYoDYnUwz3r7Kj1eL
1MXkHnQGiv5Dqzc9PyV+AQndVZv3ZoRpMFuPFZ4YZJ1/yemLDv75jHXfL9deBWeu
mnTiYGqiFLEi06Cw8SjFUs8tJMSlgWE/29y4264OYeqaWmiJQgCowyS/sycoRNrB
P/HjUJjpCcBlPoIi0dqtEzkj6hBFGL8rFjCEhXQp57f7f+pbdx/ntHPqvd7BNues
MxrstH93X4L5BVNzEwwvH4biLpaVAIoOWEGjuHMpYdH+mL7AgYdlgfdZ/8UMp289
xqGGGdrSfPweWh5upY6cdWxYcP+xPfZYnxeAlEKEbBWGVcXyu7GNnLIvzfuphMl7
e8z7kwuD7nk4BeDp59Id
=Toxc
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
