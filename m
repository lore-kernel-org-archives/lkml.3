Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbaLATZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:25:59 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45351 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174AbaLATZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:25:56 -0500
Date: Mon, 1 Dec 2014 19:25:40 +0000
From: Mark Brown <broonie@kernel.org>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-spi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Message-ID: <20141201192540.GM7712@sirena.org.uk>
References: <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <547A050C.5040906@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3dMOQFbIPOCGfYdm"
Content-Disposition: inline
In-Reply-To: <547A050C.5040906@users.sourceforge.net>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] SPI-txx9: Deletion of an unnecessary check before
 the function call "clk_disable"
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3dMOQFbIPOCGfYdm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 29, 2014 at 06:40:28PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 29 Nov 2014 18:34:20 +0100
>=20
> The clk_disable() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.

Applied, but please do try to use subject lines matching the style for
the subsystem.

--3dMOQFbIPOCGfYdm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUfMCzAAoJECTWi3JdVIfQ0T4H/0xhWZpQIq2arup2m4KilsRg
zwchhHnOwmPcomLlJMa/6evEBP2drBpJkpzPs5vwpPI+0/ctiNFuxyq9f4OWlGJ8
hrnCL0N/Qz6B9Y5GnJDSQL+sZwr1GFkM5T0nba72dc32HTuibwqvjPwhbZsekw2A
+ekjRnL0qk0jfS2VNHNFzR+0WN8TX0B2GfVWNRhpLlGIsN7z5+ociFKLZvC57vsN
BKebhg2bzf1nWepTcSa9NIJEXG7TB8X8F1z7WBuJmot8NxP3o0yWdIhyicP1H2tk
3eXMIy17TM192FNyPv1fbeIeYjYZ3zM6XOylZlZPtsw0NRUId+miywL7Vb8/jgM=
=wFaD
-----END PGP SIGNATURE-----

--3dMOQFbIPOCGfYdm--
