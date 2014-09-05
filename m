Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbaIEKaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:30:20 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51378 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478AbaIEKaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:30:19 -0400
Date: Fri, 5 Sep 2014 11:30:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140905103001.GB29327@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zF+zMOaY3GLhGz1l"
Content-Disposition: inline
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator fixes for v3.17
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zF+zMOaY3GLhGz1l
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The following changes since commit 69e273c0b0a3c337a521d083374c918dc52c666f:

  Linux 3.17-rc3 (2014-08-31 18:23:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/=
regulator-v3.17-rc3

for you to fetch changes up to a65c86630632c534e9dd3cf76c1c5a5c98970873:

  Merge remote-tracking branches 'regulator/fix/doc' and 'regulator/fix/tps=
65090' into regulator-linus (2014-09-05 10:53:18 +0100)

----------------------------------------------------------------
regulator: Documentation fixes for v3.17

All the fixes people have found for the regulator API have been
documentation fixes, avoiding warnings while building the kerneldoc,
fixing some errors in one of the DT bindings documents and fixing some
typos in the header.

----------------------------------------------------------------
Andreas F=E4rber (1):
      regulator: tps65090: Fix tps65090 typos in example

Geert Uytterhoeven (1):
      regulator: Proofread documentation

Mark Brown (1):
      Merge remote-tracking branches 'regulator/fix/doc' and 'regulator/fix=
/tps65090' into regulator-linus

Randy Dunlap (1):
      regulator: fix kernel-doc warnings in header files

 Documentation/devicetree/bindings/regulator/tps65090.txt | 4 ++--
 Documentation/power/regulator/consumer.txt               | 7 ++++---
 Documentation/power/regulator/design.txt                 | 8 ++++----
 Documentation/power/regulator/machine.txt                | 4 ++--
 Documentation/power/regulator/overview.txt               | 6 +++---
 Documentation/power/regulator/regulator.txt              | 6 +++---
 include/linux/regulator/driver.h                         | 2 ++
 include/linux/regulator/machine.h                        | 1 +
 8 files changed, 21 insertions(+), 17 deletions(-)

--zF+zMOaY3GLhGz1l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUCZCmAAoJELSic+t+oim9l+oQAIS5Bfoj5P3oN34YnJhVO/i6
O0SjOxPg4iW5gdXqKznqqTs9XUbxAggZ1RJtQ/jABmuGxvCbDHQJJ+NdSP8FzwrO
PVa7+QbPWptgHNGx7RPDpKFc7Y9U6JetAzxPiuwj9Twb8TjSKwzUWM2rpifIYx3o
zVwef8JBuDWDDby+x6jqB7gzLy9ksrwXZ+TWZpxyPZ5moYoJxk3BUvy5AcZ+JwcW
P7XsUtOyVlSFerqtSL+E9ffU1BqPiqQr1RvL49nIJaTbxae+DlZmxoWOfAFjAyZF
/ATINodClfLFWyujn+itf8EREtW5DqVXsdWqv0gm/eZ9nxtbQ4z+THuxI91e91RR
Omqnug2T39WWY5xqBDPcEi35JohoOhrGQqxqrZVA9M9LYii2/ia367iDdG1eK07l
9A5iiFcbm5LfDi+woYXto4y9LnqZLnzts16SHVnWp/VLQO8LGcgcy68AE7dmv6xO
wxu0hzObKPhpm3ylnaev68nh/FN6kzuRY5Ojg8BPj1xAeh6aOLgnmF0mVSr/Hmdc
gwm0Ftqxby8XHqMynYwDfd1Z73EtRAt/3gNSQ4/BI4HBsxVRrWU/gxDoD26ZFD3u
Py7J4VU5cRFLBOPsurZveLunlItUfimjTQE3pA45MIKrigSg7gYO0pubyJbfOtXd
gw7FKgRLArlpYEjMhKKD
=prTW
-----END PGP SIGNATURE-----

--zF+zMOaY3GLhGz1l--
