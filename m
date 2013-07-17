Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab3GQMO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 08:14:58 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54669 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab3GQMO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 08:14:56 -0400
Date: Wed, 17 Jul 2013 13:14:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Message-ID: <20130717121436.GS22506@sirena.org.uk>
References: <1374060037-18527-1-git-send-email-broonie@kernel.org>
 <20130717115249.GE3336@laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MrYn40gufhvT+RW4"
Content-Disposition: inline
In-Reply-To: <20130717115249.GE3336@laptop>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] mfd: wm8994: Remove duplicate check for active
 JACKDET
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MrYn40gufhvT+RW4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 17, 2013 at 12:52:49PM +0100, Lee Jones wrote:

> I don't see the duplicate?

It seems Samuel already applied this but git did the wrong thing during
rebase and discarded the subsequent commit which removed the
non-duplicate copy rather than the first commit which had been applied.
The content of the patches is identical.

--MrYn40gufhvT+RW4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5oqoAAoJELSic+t+oim9BXMP/jlCkSYf+ZCuQK+SsHcf0Uel
Vp//zic//zubhRzXeRDYfZRzEUBv5DbwUUAo1nP6gF1VMtvT5ncbKvqxB5gmd8aT
P3NVH+nQtIA0NK2e9F5dlLq4knNqY36Qvaj0Osb7g30DxkS+KGT+9sH4E+MFmbfa
mi/ADvCimw76EPoQj22ZlfiThYUjCQEqjsPcdOzrgHKJaO7sNoDKbqygslBGGLr2
EvP3FCPe7P968fh0BKc3dlK2uSodhnaCmq0X7mLfzetYKZ9+mfwaOvgJMWbgn5cr
lYXJh6sbfUnz8GUY5ZHQibrUz0HEbkuINjVksVfwHSebRwSa97cXGA93ABkLc861
hZXkZbOOVD+x8wI7wKS25lg9iC+ODE4eN7NQP8kXLw6te4cCLTXa6UWDM6iAvAmI
Ev1UT78chFcu2+OLTrDWNQXuypQEg9APd89fdhlOR6U1iPUpB6F/14Jsud7Xa39w
zsOqnAgMxesPBXMq46lZYI8Jm6pGks96xiJiT6jiWbUkiexlR7GmS9gXq0GR+kDq
pkcPbR1vjuMWIHdTSFms+oGnA0fm/U1ViSVHw1DdxVLQizqKarZ0U+9gz2vk8Lif
04V3bmDW17DggrKta3bdov2SaWIRp2MFm/RScW8MYA2gbFOS1BjOlakd9g71dKUZ
uItB03Wo/C4pLO+GabGB
=Alea
-----END PGP SIGNATURE-----

--MrYn40gufhvT+RW4--
