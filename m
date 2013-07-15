Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab3GOLjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 07:39:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49830 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab3GOLjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 07:39:12 -0400
Date: Mon, 15 Jul 2013 12:39:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20130715113909.GE11538@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IU5/I01NYhRvwH70"
Content-Disposition: inline
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regmap updates for v3.11
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IU5/I01NYhRvwH70
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 8bb495e3f02401ee6f76d1b1d77f3ac9f079e376:

  Linux 3.10 (2013-06-30 15:13:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-v3.11-rc1

for you to fetch changes up to f2e055e7c9c6084bfbaa68701e52562acf96419e:

  regmap: cache: bail in regmap_async_complete() for bus-less maps (2013-07-04 13:54:44 +0100)

----------------------------------------------------------------
regmap: Fix crash for async operation on busless maps

This fixes a crash if something tries to do an asynchronous operation on
busless maps which was introduced during the merge window.

----------------------------------------------------------------
Daniel Mack (1):
      regmap: cache: bail in regmap_async_complete() for bus-less maps

 drivers/base/regmap/regmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--IU5/I01NYhRvwH70
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR499aAAoJELSic+t+oim9Fh4P/RsNA5EH+HO/WMrt2hIY38Vj
x+Cifzi9TG1j1xIzNo8yx+0PJsVpNjt12BY+lNxOsaxc4tkT8+8VAbU5hWWhBp4L
HIbiRbr9danwgSiSOzN0qdTQCOSNShkTgqHOLI/9Z8wT7Q9pO2GDqiDQxgPuZj1X
NrGSQpaofGtGgqiP2IKW1OnEKOJzuz6TF4pZ77Z5Sm5pV+SJsQRzu3+Vnir9gr+/
q9KQsHvhEbzU1g+mEEyLy9nGp4TEtsIAOUZCDscXJefJnYOi6ITcGFVlzd9+nyBz
zQaUkzDX0L3DQ4fr/uaKBdGhhqZ6uPJykNtEeuPLthpp3HjShqe+ZeJs6LiwAYjy
qNXhKn3RT/m5hIW8vUdVYl2pYoWIE32XaR/vC0OdnzG1LGErP2Q3vJPV2X0oLk0V
pqSlYq8amDxhVVd9L/hbYCrV0qxip8o+EqTMzgMOBq0Czgar/SN3ysU+0ts4VWKr
NatSrTqsNSM1u0uk9IIAUCoSFoJ4UeEou2qg0yWNTNFrHaJYt08BKUo/R2dS0eUK
gZLyNFaszvHqouOyOZBQnm6Zq4PbKqvzocGKUacbjPxih7qtNHAVAppd8uGnICFD
CR0wG7VsozU90BKIa76TAnmR/3UCkUXpXpxtWZq5JljtKgR5XYVXsXmTdxkVEndL
npLGEGfHytH0g4LQW4Hl
=Vho1
-----END PGP SIGNATURE-----

--IU5/I01NYhRvwH70--
