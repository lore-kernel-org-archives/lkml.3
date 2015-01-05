Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149AbbAETDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 14:03:55 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36676 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108AbbAETDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 14:03:53 -0500
Date: Mon, 5 Jan 2015 19:03:42 +0000
From: Mark Brown <broonie@kernel.org>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Message-ID: <20150105190342.GF2634@sirena.org.uk>
References: <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <54A9355F.4050102@users.sourceforge.net>
 <54A93CBD.7090905@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bqc0IY4JZZt50bUr"
Content-Disposition: inline
In-Reply-To: <54A93CBD.7090905@users.sourceforge.net>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 8/13] ASoC: Intel: Delete an unnecessary check before the
 function call "release_firmware"
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bqc0IY4JZZt50bUr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 04, 2015 at 02:14:37PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 3 Jan 2015 19:49:37 +0100
>=20
> The release_firmware() function tests whether its argument is NULL and th=
en
> returns immediately. Thus the test around the call is not needed.

Applied, thanks.

--Bqc0IY4JZZt50bUr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUquANAAoJECTWi3JdVIfQoIsH/il6Riqg4/bu/Px1DnuAmXlK
10ykewzO52f0ueOR9J3ICUCw2wCXY2pPoR2/v2M8j0WSeWYVMZA4KaXI8ND/3I5m
jZVIXvly07VZYpRMffGQgn3SVrfPIpi4YQwiCGNstt1RO4qALzuAfJ9wMTTjuukG
lknqljkPfrEbgTBAVsV0IWa6PMCfbSjNbZg5YWrHH5OSKKNFhHvsppgg31ok3R3v
YahRJbG7Y30Ct43/fOju0/pIwrHYVP6asUUp+wt6ZrQ6CNgDsyeT4H9D5H8FhbiV
gSNf9vlLlgw+FIZD+KyuKr0bCdV5/k2/HY2EFc/39878JQtns7n1/WErXnl8QUo=
=UoSb
-----END PGP SIGNATURE-----

--Bqc0IY4JZZt50bUr--
