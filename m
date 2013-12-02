Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab3LBNgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:36:49 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41879 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab3LBNgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:36:46 -0500
Date: Mon, 2 Dec 2013 13:36:23 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org
Message-ID: <20131202133623.GG27568@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GuLbEtPckrXUekoe"
Content-Disposition: inline
X-Cookie: Boycott meat -- suck your thumb.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] SPI updates for v3.13
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GuLbEtPckrXUekoe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3.13-rc2

for you to fetch changes up to c18158f1fdad0de6be5386291189580484e459cf:

  Merge remote-tracking branches 'spi/fix/bcm2835', 'spi/fix/bcm63xx', 'spi/fix/mpc512x-psc', 'spi/fix/mxs', 'spi/fix/pxa2xx', 'spi/fix/qspi', 'spi/fix/rspi' and 'spi/fix/txx9' into spi-linus (2013-11-28 11:31:35 +0000)

----------------------------------------------------------------

spi: Fixes for v3.13

A smattering of driver specific fixes here, including a bunch for a
long standing common pattern in the error handling paths, and a fix for
an embarrassing thinko in the new devm master registration code.

----------------------------------------------------------------
Chew, Chiau Ee (1):
      spi/pxa2xx: Restore private register bits.

Mark Brown (2):
      Merge remote-tracking branch 'spi/fix/core' into spi-linus
      Merge remote-tracking branches 'spi/fix/bcm2835', 'spi/fix/bcm63xx', 'spi/fix/mpc512x-psc', 'spi/fix/mxs', 'spi/fix/pxa2xx', 'spi/fix/qspi', 'spi/fix/rspi' and 'spi/fix/txx9' into spi-linus

Mika Westerberg (1):
      spi/pxa2xx: add new ACPI IDs

Sourav Poddar (2):
      spi/qspi: cleanup pm_runtime error check.
      spi/qspi: Fix qspi remove path.

Stephen Warren (1):
      spi: core: invert success test in devm_spi_register_master

Wei Yongjun (7):
      spi: bcm2835: fix reference leak to master in bcm2835_spi_remove()
      spi: rspi: use platform drvdata correctly in rspi_remove()
      spi: mpc512x: fix reference leak to master in mpc512x_psc_spi_do_remove()
      spi: txx9: fix reference leak to master in txx9spi_remove()
      spi: bcm63xx: fix reference leak to master in bcm63xx_spi_remove()
      spi: spi-mxs: fix reference leak to master in mxs_spi_remove()
      spi/qspi: set correct platform drvdata in ti_qspi_probe()

 drivers/spi/spi-bcm2835.c     |  2 +-
 drivers/spi/spi-bcm63xx.c     |  2 +-
 drivers/spi/spi-mpc512x-psc.c |  2 +-
 drivers/spi/spi-mxs.c         |  2 +-
 drivers/spi/spi-pxa2xx.c      |  5 +++++
 drivers/spi/spi-rspi.c        |  3 +--
 drivers/spi/spi-ti-qspi.c     | 23 +++++++++++++++++++----
 drivers/spi/spi-txx9.c        |  2 +-
 drivers/spi/spi.c             |  2 +-
 9 files changed, 31 insertions(+), 12 deletions(-)

--GuLbEtPckrXUekoe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnIzUAAoJELSic+t+oim9PTkP/j8NUO2+LYh5AIb5mPTDFBOe
ZMedJ1XYSvX47KI/ut8U5wox5A2XALdzA1/cfUnYgxZb3Ua1PCeXJNNf3Ry5bFsU
KdfptYa0kZ5/eKRvpiaeBH3GEWsUlhpD8oLySo2YmbNe9dDQpYm3utmxFtiJgzP4
AC5xEO30yK5LEwrEy5pAkLB3DGQMo7IdHaQsBTj89wzkEpy5Fpds8Z3XIRoJIMju
W6rhzN+49rUzk+3RxW3VQuvYrJR3w83DSQc038J3rMlHRU82tCHBCsuFSx+d4ynH
B789y7bOBpxlbHD/VlIW4o8YuTLHipGgsTnBZTdCzNOnu4WaVquoG789R6dN39KW
qrMWQW/czJkim6AjeHaB9bghYNhxAAlUGAkqeN3ZsdhafltXfCz8+iq5cFRWw7zH
vvfxnaDOM7rNfmxRJpfBeWNTds1fCF1qyGjz2ABCSHXAAWS6ZcH7UtDJB83iCdqm
JeNx8fBz7yggbnnzcFJlW/Afugu2qa7s5MDiI7HxTPHGTsd6QVVElTuKgT9fDCZ/
/sLaDZPVxBN9evRGETClpr46MpcVdq5V07EQ0iic+YO5d/dumm9cI5QzkmnmVG3u
0oNNClRRUuFznh0RV9jN/VFmKsvO4zPb0prXBu7gUQJPB0rmVEKDHw8BvlT9p7FQ
eslBi5wPwJiU8Ox+OR0c
=Id4e
-----END PGP SIGNATURE-----

--GuLbEtPckrXUekoe--
