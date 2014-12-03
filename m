Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbaLCSaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 13:30:25 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47362 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaLCSaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 13:30:23 -0500
Date: Wed, 3 Dec 2014 18:30:01 +0000
From: Mark Brown <broonie@kernel.org>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lgirdwood@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Message-ID: <20141203183001.GI7712@sirena.org.uk>
References: <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <547DEB6B.5000105@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LuKV14TtiCd0uvID"
Content-Disposition: inline
In-Reply-To: <547DEB6B.5000105@users.sourceforge.net>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] ASoC: mop500: Deletion of unnecessary checks before
 the function call "of_node_put"
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LuKV14TtiCd0uvID
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 02, 2014 at 05:40:11PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 2 Dec 2014 17:15:11 +0100
>=20
> The of_node_put() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.

This doesn't apply against current code, please check and resend.

--LuKV14TtiCd0uvID
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUf1aoAAoJECTWi3JdVIfQ2hIH/2Tk66vsqCXfOVroTBBU7WvP
zz1SsK64cg0LEaJ1+Z6KGFNtYmj99IgCMNksJkGlpMM/4wQv4cGeST+i8RI7rmbj
I2sw+o60fAxBc3FY0JvQvgKph6LJUCFPnBjJS00ggFiA4pUwqnFOKGyssxZuvKo8
MX1IitDnK7ybKT54X2t0Vma+tjaUGMUi6AkmfDfC0DLHjxeNiBqKc8ryrRBCYZkz
YDvozJjbWZ2pXIs6VZzwbQh1FX3ctzMll0sY7RO3607dycIf+u0tMy+JhWDmJpJk
neCymXy/KY8drs5mPrItfSqaUHZ7oHp2WUzPSFFKFw0EHMCMm29hgQasoqzvK6M=
=SIU2
-----END PGP SIGNATURE-----

--LuKV14TtiCd0uvID--
