Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab3GVACX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 20:02:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37410 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab3GVACW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 20:02:22 -0400
Date: Mon, 22 Jul 2013 01:01:58 +0100
From: Mark Brown <broonie@kernel.org>
To: "Felipe F. Tonello" <eu@felipetonello.com>
Cc: alsa-devel@alsa-project.org, LiamGirdwoodlgirdwood@gmail.com,
        JaroslavKyselaperex@perex.cz, TakashiIwaitiwai@suse.de,
        linux-kernel@vger.kernel.org,
        "Felipe F. Tonello" <ftonello@cercacor.com>
Message-ID: <20130722000157.GI9858@sirena.org.uk>
References: <1374281962-3786-1-git-send-email-eu@felipetonello.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/T+UM55GOh1Yge7W"
Content-Disposition: inline
In-Reply-To: <1374281962-3786-1-git-send-email-eu@felipetonello.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ALSA: SoC: Added jack detection kcontrol support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/T+UM55GOh1Yge7W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 19, 2013 at 05:59:22PM -0700, Felipe F. Tonello wrote:
> From: "Felipe F. Tonello" <ftonello@cercacor.com>
>=20
> It adds soc jack support for alsa kcontrol.
>=20
> This support is necessary since the new kcontrol is used by user-space
> daemons, such as PulseAudio(>=3D2.0), to do jack detection.
>=20
> Signed-off-by: Felipe F. Tonello <ftonello@cercacor.com>
> ---
>  include/sound/soc.h  |  1 +
>  sound/soc/Kconfig    |  1 +
>  sound/soc/soc-jack.c | 22 ++++++++++++++++++++++
>  3 files changed, 24 insertions(+)

No, this makes no sense at all as an ASoC specific feature - it should
be a standard feature of ALSA jacks.  The whole point of having ALSA
core infrastructure for jacks is to avoid having to go round doing make
work stuff like this.

The fact that the kcontrols were introduced as a HDA-specific feature at
all is of course a problem here...

--/T+UM55GOh1Yge7W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7HZyAAoJELSic+t+oim9p64QAIk6TzGC5VjswvUl4yH1c7DT
XmJlJ4xAIyDBNcQp528rnVv8tYKwGNbJRg7JVhEsx1FRBmosHj/UU0be/geLHLj9
RROiBu9AhPw8blQAXfh6UKfu3HA+74uk/rdNxX33FMsGQvHdbtcbAt0C5fa7fY9I
FCSAAzUEEr3+cBWmuHYIkM6dCHMC3Sgj1U57kUkDTTMiI+cDfrWazm6e4fgu+Cto
CxIVAgpRMKwKZHIfilMDts4MlfNBdUNyKNiJb1hJbVFvWl4a3YqB5xuWdlMPiKvy
zOfkiQZv4WXxEyIly6JU+GJFxH3IZIkPG8kKM74wWfuBvyfOdCLEFbqQEQCuiK/0
YGhZ/drhcOSUKX+6HgMVY/cYC14lyqyDDtUoPUtTIFoYG10PNSvkSwkKdki++G/F
mXBiLVd9DIOPkiniD1be7UVyw9BAZngMIqKgioUBqyK3aNLDyLjJh3cr/KYMQuU4
H3qlKpJ7fLUpsOjPWhpcMK0Fwb5Q4bQ4nHH8SJwqgmzwZSq6CsWIMm3K6eu+HJR9
wwqor5KqNSoXvxH6UMTgMLBj1Ebz8/06FPt0hrHira0FfQLwhhCiITsykchISYae
ncHppJpPsunEEeVB+2SihS5EbeLncnB6gKd7eCtiD1tm6HnTVLlXLl3m0Lc0WYHH
HrqcLVJuimsRvdmCrfjy
=4ZRK
-----END PGP SIGNATURE-----

--/T+UM55GOh1Yge7W--
