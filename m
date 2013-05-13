Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab3EMOlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 10:41:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40763 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab3EMOlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 10:41:04 -0400
Date: Mon, 13 May 2013 18:40:39 +0400
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Grant Likely <grant.likely@linaro.org>
Message-ID: <20130513144039.GD16673@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0/kgSOzhNoDC5T3a"
Content-Disposition: inline
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.247.243.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] SPI updates for v3.10
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0/kgSOzhNoDC5T3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3.10-rc1

for you to fetch changes up to 88b0357dde1c2721a64268e4601d1c2dec1158b0:

  Merge remote-tracking branch 'spi/fix/grant' into spi-linus (2013-05-13 18:27:18 +0400)

----------------------------------------------------------------

spi: Updates for v3.10

A few driver specific fixes plus improved error handling in the generic
DT GPIO chipselect handling - not exciting but useful.

----------------------------------------------------------------
Andreas Larsson (2):
      spi: Initialize cs_gpio and cs_gpios with -ENOENT
      spi: Return error from of_spi_register_master on bad "cs-gpios" property

Joachim Eastwood (1):
      spi/atmel: fix speed_hz check in atmel_spi_transfer()

Manjunathappa, Prakash (1):
      spi/davinci: fix module build error

Mark Brown (3):
      Merge branch 'spi/merge' of git://git.secretlab.ca/git/linux into spi-fix-grant
      Merge remote-tracking branch 'spi/fix/atmel' into spi-linus
      Merge remote-tracking branch 'spi/fix/grant' into spi-linus

Richard Genoud (1):
      spi/spi-atmel: BUG: fix doesn' support 16 bits transfers using PIO

 drivers/spi/spi-atmel.c   |   51 +++++++++++++++++++++++++++++++++++----------
 drivers/spi/spi-davinci.c |    2 +-
 drivers/spi/spi.c         |    9 +++++---
 include/linux/spi/spi.h   |    4 ++--
 4 files changed, 49 insertions(+), 17 deletions(-)

--0/kgSOzhNoDC5T3a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRkPtkAAoJELSic+t+oim9QOwP/32M1CQjC4d9ihVYuyWyjTTh
2uxI37JjtOEiDLzF3csiZyhbNHhrqKXqhiQ3eUWoK6szWmeVEdSiQGhj0f9yaPtc
t0h34v6ZL82INEVh41Cc85eR3p/V2AwemhHNi/SFUYXDhCe/DXkmN68kPJLiNcgL
H7LaKmhr7bUAOjFsqqLCLqHVdHd2xU8xoQLWv7p3Xa5h412gavPywbw2TwDwO9ND
e44qASdJtmTs0VEcf/EWvSmudqGyBfAdw6WB5YmRWo881ax4S+l1dRrwH5XPmcGD
SeBgLzap2ISaOB99tRSFPmvsQY76uRrr7pT/7Rtp6l/hAocPby/7a3AwCoC6tUjH
OuVYKbDh7zpBD6QtbPAfvnQFh7OLTBvq7Nn+7FezsCSWevTV9FEnkbl4fQTP2n++
VMKaYuPv+n0VVquUGRbXgDP685z2oe4mA/DLDwRaAfydgvnMqKJF3alD6cp8J0mY
BKodoLAKqMVuEn16uq90eF74vbb6Gqu8c0g2m5mhrPuh7lagw7j3VQPjfcx6O373
4MfDFJI9lCPfGQy2bEomXc63rT1SdtXEb/ee/kWM4HtQrlNTsu4J2ZSyoj5v70dg
I56BpYy8Jke0QVAI/LVSu+ajmon75GONCTrfhvIu5ix3LTRQR3gNyppFOP1vvw4n
qQJNESZ0J22LO4by2s4b
=E11b
-----END PGP SIGNATURE-----

--0/kgSOzhNoDC5T3a--
