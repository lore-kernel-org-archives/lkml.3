Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbaCDH1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 02:27:53 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55193 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132AbaCDH1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 02:27:52 -0500
Date: Tue, 4 Mar 2014 15:27:39 +0800
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundato.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140304072739.GC13126@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eRtJSFbw+EEWtPj3"
Content-Disposition: inline
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator fixes for v3.14
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eRtJSFbw+EEWtPj3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit acc3d5cec84f82ebea535fa0bd9500ac3df2aee9:

  regulator: core: Change dummy supplies error message to a warning (2014-02-21 08:35:31 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.14-rc5

for you to fetch changes up to 66fda75f47dc583f1c187556e9a2c082dd64f8c6:

  regulator: core: Replace direct ops->disable usage (2014-02-25 10:31:45 +0900)

----------------------------------------------------------------
regulator: Fixes for v3.14-rc5

A couple of fixes here which ensure that regulators using the core
support for GPIO enables work in all cases by ensuring that helpers are
used consistently rather than open coding in places and hence not having
GPIO support in some of them.

----------------------------------------------------------------
Markus Pargmann (2):
      regulator: core: Replace direct ops->enable usage
      regulator: core: Replace direct ops->disable usage

 drivers/regulator/core.c | 48 ++++++++++++++++++++----------------------------
 1 file changed, 20 insertions(+), 28 deletions(-)

--eRtJSFbw+EEWtPj3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTFYBoAAoJELSic+t+oim90HEP/1w5VaqjVJu/VSZwC066v1sw
lO5LLEnIGrMkM+zerIfA4JA78cvyV6HnuME5XI2P7PLUmSM0gUG7jUrNRxDGmA6f
1XZN0ILBW+eujD/+j7TSKKc23+CJAzIl8eiIivPAi54AgC6DNk1KAOfVfpeFeSOH
9xJqHzxlkSzv4O9+ZrE0diRCIQEL3tJXAs95Je3fk1JyjK0lksfXSmsScg7l8z9K
Ma1xnbe7frUjcobGLPfMb+tUXpmaCpeue6w47ChrDzqGD7yXRpWOY2PyC8XAqfct
+Vs+aiOFF6D9UxHzA+Nuz0ToFOP5ySzzMjcNC1OYfxDdD3eeAGxY/MzL6D+FuQrB
RjWN1rYQyi9E7TOMgy22OgLOzHryxMZG+Tw7GV+qbYCkYZqJRzWPT9Zit2slf1sH
GDX3T/VQ5ZHL/z41a/CipkVNRZ5MePqYRHEC00g1JdDuhb+69mKrUPXd4jvn+Qre
bmVxQ5xB5PV8plQUm0IFmoTfs4fAUovkbl028GROQ91RVFC7T95GADzZb4zJ2A+v
4K19ILnREJk6xXpm9BsN/yjzcxvuUJF1p1+WWZ8btCQLAk1+6EGEaT+5aazvtWV7
Gh7U+1+bE5DRNSQeg1V/064HGoqC/CSRD8gmvntDmAmMy2shWuVOvTuFfqRRPtuE
Z6xSc7gihnpTYA19fG8M
=iob6
-----END PGP SIGNATURE-----

--eRtJSFbw+EEWtPj3--
