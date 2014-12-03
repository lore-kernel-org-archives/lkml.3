Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751134AbaLCS3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 13:29:46 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47354 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaLCS3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 13:29:44 -0500
Date: Wed, 3 Dec 2014 18:29:18 +0000
From: Mark Brown <broonie@kernel.org>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lgirdwood@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Message-ID: <20141203182918.GH7712@sirena.org.uk>
References: <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <547DC19B.5080302@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4A79KfPqnT9qCbac"
Content-Disposition: inline
In-Reply-To: <547DC19B.5080302@users.sourceforge.net>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] ASoC: fsi: Deletion of unnecessary checks before the
 function call "clk_disable"
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4A79KfPqnT9qCbac
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 02, 2014 at 02:41:47PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 2 Dec 2014 14:34:30 +0100
>=20
> The clk_disable() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.

Applied, thanks.

--4A79KfPqnT9qCbac
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUf1Z9AAoJECTWi3JdVIfQuJwH/ikDBQtMU7vue/j0KBYF+E5D
ETRJtPZTvAqYxBT2qAQ21xW/gtrP+HKNrkHIVm8+z/cWIl8+u1Tc1cHP+M/5FxPf
ezb0c1Eu/W7GgY/86+n8o/p/DzkMadUKCwmj3aD2/WyPZMHEtNnRQqahixaC8LJB
45+0ETFvnmseetn2kn4qcZiDTwrrndaF+ILKmflhktRKs7YMSz30nPV0bJu7Navo
+bIRQhwJHMBkvrtOxQNYbGV+Ag+OSGni7TbkLbsqp8xkA1FownW3mcxMKjdDm0M4
YRaIyM9nRUYPF2O8t9o4MHxFTWXNYOJeqVnY2MUZf2h+3Ni/MQcAslLyxJOVQhM=
=oX5d
-----END PGP SIGNATURE-----

--4A79KfPqnT9qCbac--
