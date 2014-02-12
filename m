Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaBLLbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:31:53 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40707 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbaBLLbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:31:52 -0500
Date: Wed, 12 Feb 2014 11:31:45 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140212113145.GE28112@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jCrbxBqMcLqd4mOl"
Content-Disposition: inline
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] spi fixes for v3.14
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jCrbxBqMcLqd4mOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed:

  Linux 3.14-rc2 (2014-02-09 18:15:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3.14-rc2

for you to fetch changes up to cf20662db4dfade737015036fa9c63e888350c82:

  Merge remote-tracking branches 'spi/fix/doc', 'spi/fix/nuc900' and 'spi/fix/rspi' into spi-linus (2014-02-11 12:08:27 +0000)

----------------------------------------------------------------

spi: Fixes for v3.14

A few driver and documentation fixes, plus a fix for double error
handling which had crept in due to the confusing documentation - it
wasn't clear if the core or the driver was responsible for cleanup
in error cases so both tried to do it with unfortunate results.

----------------------------------------------------------------
Axel Lin (1):
      spi: nuc900: Set SPI_LSB_FIRST for master->mode_bits if hw->pdata->lsb is true

Baruch Siach (3):
      spi: spi.h: clarify the documentation of transfer_one
      spi: document the transfer_one spi_master callback
      spi: correct the transfer_one_message documentation wording

Geert Uytterhoeven (2):
      spi: Fix crash with double message finalisation on error handling
      spi: rspi: Document support for Renesas QSPI in Kconfig

Mark Brown (2):
      Merge remote-tracking branch 'spi/fix/core' into spi-linus
      Merge remote-tracking branches 'spi/fix/doc', 'spi/fix/nuc900' and 'spi/fix/rspi' into spi-linus

 Documentation/spi/spi-summary | 17 ++++++++++++++++-
 drivers/spi/Kconfig           |  4 ++--
 drivers/spi/spi-nuc900.c      |  2 ++
 drivers/spi/spi.c             |  4 +---
 include/linux/spi/spi.h       |  7 +++++--
 5 files changed, 26 insertions(+), 8 deletions(-)

--jCrbxBqMcLqd4mOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+1ueAAoJELSic+t+oim9N+oQAIm4W2OmkX64sTBH/CjlFgW7
/S/AeTqekrz3yHIFCvLJaKAMkVqijP/3S4MJpGR45DMolXO+fc7trdAb4l/Rq18H
st9Bq1N/v6kdwo8YaRy1f5j0YxJnwzXEso6HXE70Ss0B7UCqluouFo15E4rREZAz
h1KYNUI/JMsG+SFUSOx9PPHa+bjSdKGPwhzEQckTxwQUQWbPsGOYQn7tko2ZSIuq
YM7i4B6WTnJTNnUzVbKZJQXarYlzrbfCHFjiYhsdw7UxC/ivHhAZDdBv1K/ijseE
caN+4pLYVIP0rYT7vhf7n55kAqeNXDGnUIFkbwNdUglts7/qzwwF0+RFgHrNkEUs
Voj4kRHC/WYMgukTqxjcGwEoEbx/BrK4Xtcc4ZMkuzdiskcDtJgMiH13vNXzVGNn
EmOpBDDG5Jj2beIkJObK2suIhDhc5tkGM5618OXyfcQx56hdjNRDwvPb8EMSXmg2
IS8MIcKIgPzACaDKxe1Vc5GgBXsqk1xp56XFevH0VZgLy83wPtBYcmxeS66mUabP
JzEq84r2ScMGCZwObL1S71z1w/0ZXApb34II97mH1yX3aFv+EkvkUhfPS3FYiSRw
/R9IXGr1UZv3CijJyrq4MY31IHgBdF1c0DtOIthWfzIJLgoDUwKVNgdAYijnLwRP
y3pPqWLmBiEB+YrQj5yI
=RZu/
-----END PGP SIGNATURE-----

--jCrbxBqMcLqd4mOl--
