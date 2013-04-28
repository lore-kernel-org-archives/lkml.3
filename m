Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab3D1BIr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 21:08:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51887 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab3D1BIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 21:08:46 -0400
Date: Sun, 28 Apr 2013 02:08:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Chiwoong Byun <woong.byun@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130428010838.GA20197@sirena.org.uk>
References: <1367050696.20145.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <1367050696.20145.1.camel@phoenix>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: max77686: Don't update max77686->opmode if
 update register fails
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 27, 2013 at 04:18:16PM +0800, Axel Lin wrote:
> Ensure max77686->opmode always has correct status.

Applied, thanks.

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRfHaTAAoJELSic+t+oim9dmwP/jLM99dXr0W0rf1KOkRj1fVr
Ts0mvgSZW0n3fFoWYIz6WdYl4rPiRGgaShJDjsqdae49+kh5DPr9TRcawENu22Pd
vRZk5ONaznfSna5UjoqsJQOIxKqOfUP8jcH87Z6hvfrcThK+DO2X6MhmJqpigjaO
xxLzrYbGvIfvedPOz4LusMe/OIbIDZn02v7ritHK1QOXlqcv4V3Z9yCCJPECqONf
npynYdhvaca1bUcIpJaqcbImaQq8xKzG2kL8NE29a0ct/oWWoQhpAC0Y5CSco5ew
YxdlsRGtNvJWJFsweJvXdj9i+pZG8up5wOdokEmspsS7oe9WH03WjoUq7fw7bg8u
2jY4GaDgMpsFemkHAyNDRrgXfl6ofQ7hdiPTuFSfB/EYtjyA2W9cpOvgGhjoQEhj
e6KwB8av4hJzLU2deImYeXhPaTivswUtW7igsopNEuIS2B/f5Bc4Kr/DksLe2yXZ
Z4VKzt9OtuUqdDEGLQY/Mu4WYkJmh4vEEhLPjgPf0kGj1symsabmNcBN7OIm+SJz
0yqwfe9dSERpa1qdV7Tz5cVqxKWw248Gux6yzmyuks8z+rOU0RZKKtXpAiVG3xbL
PWc44Jhm3kgyvkIo9s13LsDo/MC7sfvSW4/r0/BBpV7+RNkL5kcT1PuGbzYXbu3C
Z1U3x2EWPVFEE+rL/p3j
=B/Rc
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
