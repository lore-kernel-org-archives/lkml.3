Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbbAETDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 14:03:25 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36668 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbbAETDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 14:03:23 -0500
Date: Mon, 5 Jan 2015 19:03:09 +0000
From: Mark Brown <broonie@kernel.org>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Message-ID: <20150105190309.GE2634@sirena.org.uk>
References: <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <54A9355F.4050102@users.sourceforge.net>
 <54A93C1E.4050200@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+SfteS7bOf3dGlBC"
Content-Disposition: inline
In-Reply-To: <54A93C1E.4050200@users.sourceforge.net>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 7/13] ASoC: fsi: Deletion of unnecessary checks before
 the function call "clk_enable"
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+SfteS7bOf3dGlBC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 04, 2015 at 02:11:58PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 3 Jan 2015 19:25:55 +0100
>=20
> The clk_enable() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.

Applied, thanks.

--+SfteS7bOf3dGlBC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUqt/sAAoJECTWi3JdVIfQ4BMH+gOEfpud37K2w9bgPPi3DsU4
F51MAqdABOeSYRBq3RKqyHfgmYkpnUt8uMDBZ7w+cu3ip2uEK1487LKNxaRBBxiv
zaGOKYi8tx3Nvi5VDRl1NjyqMc4GwFbExkKgUL75xIG6+ZmykZ5bQRrCVrsH9gf5
Gk9vjcGnIclSjfSO5Qmpch7ghvLZQfvfMOKUNl8gC4FdgECAdOqqDcl8uQHvuRxn
j7GFVr8C2ljwEVHcRBW54rG+/RB17wij9t8x9raVAs5MhcjPugBjce1HcmqtO0kN
VhZPvuVVO3NsOuNRzmb0lCXhRrIirsRLKR9iixl5YpKm0Ou8n4LAPTTXPm65i4g=
=9k4d
-----END PGP SIGNATURE-----

--+SfteS7bOf3dGlBC--
