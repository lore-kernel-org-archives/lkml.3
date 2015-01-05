Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbbAETDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 14:03:08 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36659 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbbAETDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 14:03:06 -0500
Date: Mon, 5 Jan 2015 19:02:44 +0000
From: Mark Brown <broonie@kernel.org>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lgirdwood@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Message-ID: <20150105190244.GD2634@sirena.org.uk>
References: <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <54A9355F.4050102@users.sourceforge.net>
 <54A93B5A.9050504@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PHCdUe6m4AxPMzOu"
Content-Disposition: inline
In-Reply-To: <54A93B5A.9050504@users.sourceforge.net>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 6/13] ASoC: Intel: Delete an unnecessary check before the
 function call "sst_dma_free"
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PHCdUe6m4AxPMzOu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 04, 2015 at 02:08:42PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 3 Jan 2015 19:03:55 +0100
>=20
> The sst_dma_free() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.

Applied, thanks.

--PHCdUe6m4AxPMzOu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUqt/UAAoJECTWi3JdVIfQbzEH/2AfD0z7SEF1hyaG2XpkbGwp
3iLOAbTCG053WAJ9C0fJuwkewVKS0SrmiP6aiKW16k8OEG+sebPgaOtWKGU5w9xY
aWon59S/QUgGBXJL44W46S/pTLuj3DVMKuzRbYpVNdxyYQl0xJqg/1/fsDitIY4A
3ULmylY77/2zK9AOJ5tquCmiXbIpyD9DbGuBbeQPyyxWhf3PUmJUi8VeekfzSckk
zPImyBDWHEajvRwR4xHag3AD3x0eSmPhpfFWwAqztS6GnGHspVmagQLRxQJRGxBm
C6//ImuyKc4H5gessBwByApMpSL8MikA9wfAyPEd/RjhCGuKLu/Z2APKvo34aN8=
=gKx4
-----END PGP SIGNATURE-----

--PHCdUe6m4AxPMzOu--
