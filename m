Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbaF1Ner (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 09:34:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34382 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaF1Nep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 09:34:45 -0400
Date: Sat, 28 Jun 2014 14:19:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140628131932.GU2520@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5FNPeqk0egs0iuvD"
Content-Disposition: inline
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.248.217
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] SPI fixes for v3.16
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5FNPeqk0egs0iuvD
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee:

  Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3=
=2E16-rc2

for you to fetch changes up to 7216a4183947853f359b41ba1edb5db9b3091acc:

  Merge remote-tracking branches 'spi/fix/pxa2xx', 'spi/fix/qup' and 'spi/f=
ix/sh-sci' into spi-linus (2014-06-28 14:01:23 +0100)

----------------------------------------------------------------

spi: Fixes for v3.16

A few driver specific fixes, the biggest one being a fix for the newly
added Qualcomm SPI controller driver to make it not use its internal
chip select due to hardware bugs, replacing it with GPIOs.

----------------------------------------------------------------
Andy Gross (2):
      spi: qup: Fix order of spi_register_master
      spi: qup: Remove chip select function

Chew, Chiau Ee (1):
      spi/pxa2xx: fix incorrect SW mode chipselect setting for BayTrail LPS=
S SPI

J=FCrg Billeter (1):
      spi: sh-sci: fix use-after-free in sh_sci_spi_remove()

Mark Brown (1):
      Merge remote-tracking branches 'spi/fix/pxa2xx', 'spi/fix/qup' and 's=
pi/fix/sh-sci' into spi-linus

 .../devicetree/bindings/spi/qcom,spi-qup.txt       |  6 +++
 drivers/spi/spi-pxa2xx.c                           |  8 +++-
 drivers/spi/spi-qup.c                              | 44 +++++++-----------=
----
 drivers/spi/spi-sh-sci.c                           |  4 +-
 4 files changed, 27 insertions(+), 35 deletions(-)

--5FNPeqk0egs0iuvD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTrsDhAAoJELSic+t+oim9sIEQAIV4ahU3nkNQTtdAZcBiAKHJ
3KBNiw0fQew9ABJOML8N+P0ibS1JN+tarOoFvcdlzt0gWsb0JbdxoQqYt6rE0HOy
CjSdWaPLdZI2XqtKAHMEE1/sSQPmlhWJO2QbG3nGzdgvaUm4phrPP9J6bmTLWm4v
KY8xJ8HMgGN548NrpWFoem8dgq8KxUd808bl1UTIlscQ3kJceOoQsoYwDnCzMmrM
RNOO8rqLkDRHLk451B548uZGtd1TtWI4VZxCVRdlO/9A+rjeb36MXUZisDPOXSwB
4LXniXnK437QoFVbnbUY6PISMMpO1k9nD5/3lu7QMX/vjsRqLnVCyJ5VVcYGzXuQ
6BRQ9qK0dJLnjTUwOYnOfvgzczeKVhTB48fuK+yM33b5BSdG0zMjS2UjzQTRpffk
XFoBnLpUEuUgRJanRpVm6w7WVqJIk9ef/2d4FzBPJqQKL/XJOB+k7tsgsEej3zOf
xm9h7veobl3CulccMScb2oaYHjoP0mj7DfOLMiBKURsTs/qMHgFfShIwDzpc0j41
3jJj3z/jarelcEQp9sSH86G9UNUN9FWULh0vI6VWuE6LD1IIGfzeCWLtr3JGl/+s
4qxmrp+bLtBdIfG99YRBP5KKjE1UsRmuopGGArzJnkVhnUIiTBH3xjFsHUpeXxTb
Quk72yjT+WrbgrVG/cmq
=Br6r
-----END PGP SIGNATURE-----

--5FNPeqk0egs0iuvD--
