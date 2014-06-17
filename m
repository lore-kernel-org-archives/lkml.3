Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402AbaFQL32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 07:29:28 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45499 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaFQL31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 07:29:27 -0400
Date: Tue, 17 Jun 2014 12:29:06 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140617112906.GN5099@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iTrWFMUu8wG1LMqc"
Content-Disposition: inline
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] SPI fix for v3.16
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iTrWFMUu8wG1LMqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 69e25c755722056b57892bebeb1892e3a6fe8774:

  Merge remote-tracking branch 'spi/topic/workqueue' into spi-next (2014-06-02 17:08:43 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3.16-rc1

for you to fetch changes up to 01d7aafb3fbaafe2403780ef9ed497b3289ab1b9:

  spi/pxa2xx: change default supported DMA burst size to 1 (2014-06-06 10:52:46 +0100)

----------------------------------------------------------------
spi: Fix for v3.16

A single bugfix from the merge window, fixing an issue with DMA at slow
speeds on Intel hardware.

----------------------------------------------------------------
Chew, Chiau Ee (1):
      spi/pxa2xx: change default supported DMA burst size to 1

 drivers/spi/spi-pxa2xx-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--iTrWFMUu8wG1LMqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJToCZ/AAoJELSic+t+oim99u4QAIHnpYe3K/n/lOIaKOpozy9V
g61/jZNBHLVzFc2TePRm7Fff5XL6svqvWJQtXMN0hEV3dj6ASNdxk5wWYd3HM2IS
8ZJg9FYluZRm6RufbFVehYcsasehkDgayPrQ3dR4n/slNhKar5wnnVDht652bb+C
cph85dXFsRIZCuQwT2IVsekDhF/C327KGcZsaaye6ACL63IQo+fPb/vihoL3cmmU
dBOgY/XqdsGU9O7Y8W6AqT31YZwKtt3gA1KBiOU6cLfKEysPs3S0M306nHI0ArZh
aaX6Tb5kGe7OXTGdU93lLcUUxVsyaDjhuaUztOZaWCbIrGQ++bQS+brV9zteBjd9
pnAt3Ij/vBKpxDuJbL8oDdV4mlAZ7WYfOxjPQypQhO8q/SB7K9uyOlvuF5CVzvEq
jp+1xsew1oa9/tQU0LgO3YrOUBbuWPcsAYPPqmA+Prn4DO+pPGkg953ew+DPUyf5
NMVljEaiSGNu94OmO7YczFK6GQZRlfD9hl3SQWPRd+1Mic4RG25C49sjUbbDLl+A
OlEjc0/J/tFFnZJ1r5riNkHx2pxO6/VUiTpRqQn1Z+oNIBWBvAVOzkgiYeHHzunF
97LAZMDmiHh0SzETqrZCxbp3+8pK0WEC64UbruzVxBr+5yLuCWtGEWCDqYYevN9O
oMBlytmp1jAk+GJPIzNE
=OAQi
-----END PGP SIGNATURE-----

--iTrWFMUu8wG1LMqc--
