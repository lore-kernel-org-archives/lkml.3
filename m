Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab3JILEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 07:04:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54098 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab3JILEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 07:04:41 -0400
Date: Wed, 9 Oct 2013 12:04:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20131009110434.GK21581@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liZWpUHqzTS6Vbk9"
Content-Disposition: inline
X-Cookie: Penalty for private use.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] SPI updates for v3.12
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liZWpUHqzTS6Vbk9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit d0e639c9e06d44e713170031fe05fb60ebe680af:

  Linux 3.12-rc4 (2013-10-06 14:00:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3.12-rc4

for you to fetch changes up to ac9fdc88641cf68b1077afb0b5cd7ed87fe4a5c2:

  Merge remote-tracking branch 'spi/fix/s3c64xx' into spi-linus (2013-10-07 14:51:59 +0100)

----------------------------------------------------------------

spi: Fixes for v3.12

This is all driver updates, mostly fixes for error handling paths except
for the s3c64xx and hspi fixes for trying to use runtime PM before it is
enabled and the pxa2xx fix for interactions between power management and
interrupt handling.

----------------------------------------------------------------
Axel Lin (1):
      spi: clps711x: Don't call kfree() after spi_master_put/spi_unregister_master

Kuninori Morimoto (1):
      spi/hspi: fixup Runtime PM enable timing

Mark Brown (7):
      spi/s3c64xx: Ensure runtime PM is enabled prior to registration
      Merge remote-tracking branch 'spi/fix/clps711x' into spi-linus
      Merge remote-tracking branch 'spi/fix/dspi' into spi-linus
      Merge remote-tracking branch 'spi/fix/hspi' into spi-linus
      Merge remote-tracking branch 'spi/fix/mpc512x' into spi-linus
      Merge remote-tracking branch 'spi/fix/pxa' into spi-linus
      Merge remote-tracking branch 'spi/fix/s3c64xx' into spi-linus

Mika Westerberg (1):
      spi/pxa2xx: check status register as well to determine if the device is off

Sachin Kamat (1):
      spi: atmel: Fix incorrect error path

Wei Yongjun (3):
      spi: mpc512x: fix error return code in mpc512x_psc_spi_do_probe()
      spi: fix return value check in dspi_probe()
      spi/clps711x: drop clk_put for devm_clk_get in spi_clps711x_probe()

 drivers/spi/spi-atmel.c       |  3 ++-
 drivers/spi/spi-clps711x.c    |  3 ---
 drivers/spi/spi-fsl-dspi.c    | 10 ++--------
 drivers/spi/spi-mpc512x-psc.c |  4 +++-
 drivers/spi/spi-pxa2xx.c      | 11 ++++++++++-
 drivers/spi/spi-s3c64xx.c     |  4 ++--
 drivers/spi/spi-sh-hspi.c     |  4 ++--
 7 files changed, 21 insertions(+), 18 deletions(-)

--liZWpUHqzTS6Vbk9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSVTg/AAoJELSic+t+oim9sWwP/izg2lsURhx+3X5Jx0UXgGgs
BQbz25LuRcKPpA/2/f0CpPZPZHWwlLYuwIC+sAbqpGH91KMoE7NXC49pVQIE9xM1
H3NUX1uR3Z10vToqDYC+iMQk6QTD8RClXERLVqgPEqpOGkYTZb00p0Oerx9jNcni
2gizi0gm/iiQpAmjBJUlkDQodHwhLxzZROpIWo0xd+I5DuLxZnpIDLRUS96CsSig
Et+zy9AUOm2Iya+9vIKZtbfvIibSsKgHluUtUobNLa9bcwjZLjcNA6G/chK9Xbp5
xh6Tbd1WHoDsxVFFCQMFswrZz5Bsi3yO29Ye3YVByKRnViJs5dxSeb/WyPEaqAA8
sxmFZxKUdzL3KWfO6n4DWvHxtbDCTQb1QwTkEYkyLiev1pXYsXkufsxh+4k97wZi
tJKQerVIGfhC5CYns96oxmKcC6JKHn195z7CRp+S6qTcpMcBqN7SfsYH7d7eoLjO
6+2bwnH/xjNt1CTFWvfgbSt7w78p4tjq/sjD2OsE6AqYeExyT1ivjXCCzW5PVtW5
jnOZlpW4ZWGmY3b2XGQ/pmeo1w3Uc2W5jxjMsjEt32AlwUPgRbYOnW8uo6JD8Z/U
gNGZX5Gx9OLDmRf/GSBxbrC8kbFqL/kZhioR0hG8pOKBRDW0x/yMzdU3HemMeLXT
wq3G5GbtP/xsGrg+qeb0
=QdyJ
-----END PGP SIGNATURE-----

--liZWpUHqzTS6Vbk9--
