Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab3GOLia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 07:38:30 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49812 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672Ab3GOLi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 07:38:29 -0400
Date: Mon, 15 Jul 2013 12:38:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>
Message-ID: <20130715113805.GD11538@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZJcv+A0YCCLh2VIg"
Content-Disposition: inline
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] SPI updates for v3.11
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZJcv+A0YCCLh2VIg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3.11-rc1

for you to fetch changes up to 70f092a58520b26ef6222ae1b42bd08732fdf6b9:

  Merge remote-tracking branch 'spi/fix/xilinx' into spi-linus (2013-07-15 11:46:16 +0100)

----------------------------------------------------------------

spi: Fixes for v3.11

A couple of things missed during the v3.11 work here:

 - The spi-bitbang core requires a setup() function even if it does
   nothing which caused breakage when some empty setup functions were
   removed after their contents were factored out into the core.  While
   this is clearly silly and will be fixed for v3.12 for now we just
   restore the functions.

 - A missing case handled in the s3c64xx driver.

----------------------------------------------------------------
Girish K S (1):
      spi: s3c64xx: add missing check for polling mode

Mark Brown (3):
      Merge remote-tracking branch 'spi/fix/s3c64xx' into spi-linus
      Merge remote-tracking branch 'spi/fix/setup' into spi-linus
      Merge remote-tracking branch 'spi/fix/xilinx' into spi-linus

Michal Simek (1):
      spi/xilinx: Revert master->setup function removal

Stephen Warren (1):
      spi: revert master->setup function removal for altera and nuc900

 drivers/spi/spi-altera.c  | 12 ++++++++++++
 drivers/spi/spi-nuc900.c  | 13 +++++++++++++
 drivers/spi/spi-s3c64xx.c |  3 +++
 drivers/spi/spi-xilinx.c  | 16 ++++++++++++++++
 4 files changed, 44 insertions(+)

--ZJcv+A0YCCLh2VIg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR498aAAoJELSic+t+oim9qm4P/A4a1rF/RukrSaqEQDnEirgy
UY5JLyLHROVgpEG6yQzHmlOw8E52yNVFBSSQNsIBXZyoCaKG3Gi+DldpkIohav5T
XGAPL+UdCx77sungLt2QOWcxNuIOppwiLTszwGjNOK5XaU7JGqUai2CNKZO6nNC/
/SkXlQ/W5TBeTqiVspB31L9B/7CZN7cHEw1WHrbsrB/bgTMlopxBBZ9yfNAFUzuv
0oUO1KxWMhcQRAptgikDA86piF68RpIm2JuNc6BfNreweXN28xpp21MwXAp6stPP
q2Q36j5oXstW/hde+su3oZg3wOOOx4INE60mZAa0ImiXstvJcjGTxtsvA43jspVG
0TP6vml2lSfGOvxnxq2NZa6oAqk916raYVoBT3TJd5m9PSGCYLC29gz/omFmbvCa
94RKK9dADyFrgtn0+QSeJZpclw/bmkbjfajX5huVVc2negmgAi/vHnrifWW/DD8+
YiH7iKhkDTV9R9Koixfesckv7Vsc9ruEbKExpYBymo37ls6CnTIOAOB9pZRPkOFz
SG4aERaU0eDvhu3WNU1ZiVusSAAeJjeCN7Rh0FR32Tr3+EmRmRkXXFSAelv5UcsJ
U1ve9aIRSWZUNwiP/GJMjNE5IesHrc9agT10u2B/3CczVewT0/Ou8kF3vHZxMOuV
a3tN7aX9hNBs3PrynOcJ
=1RSC
-----END PGP SIGNATURE-----

--ZJcv+A0YCCLh2VIg--
