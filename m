Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbaAHSGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 13:06:52 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48857 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaAHSGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 13:06:50 -0500
Date: Wed, 8 Jan 2014 18:06:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        kuninori.morimoto.gx@renesas.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Message-ID: <20140108180638.GS31886@sirena.org.uk>
References: <1389164556-2728-1-git-send-email-Li.Xiubo@freescale.com>
 <1389164556-2728-3-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fxRVKzQA1vU7LXPu"
Content-Disposition: inline
In-Reply-To: <1389164556-2728-3-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/4] ASoC: fsl: Add VF610 simple audio card widgets
 driver.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fxRVKzQA1vU7LXPu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 08, 2014 at 03:02:35PM +0800, Xiubo Li wrote:
> This is the SGTL5000 codec based off-CODEC widgets supports.
>=20
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  sound/soc/fsl/Kconfig                     | 25 ++++++++++++++++++
>  sound/soc/fsl/Makefile                    |  3 +++
>  sound/soc/fsl/snd-soc-simple-card-vf610.c | 44 +++++++++++++++++++++++++=
++++++

If we're needing to add explict code for a simple audio card that seems
to defeat the point of using the simple audio card - we may as well just
have an explicit machine driver.

--fxRVKzQA1vU7LXPu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzZOqAAoJELSic+t+oim9AMEP+gOTno/3kRg86B9X/GutOMiZ
tM3hIh61ss2mkgIIDrqrtwKEvNWUziaHF/Pb0fdf1mT2zASdc2iq18ziYgnijUUG
9EK1RyEMmsWs7EDfXSDGw8W9rBvWd+GtGvnJzQfmA5WHpwLYbgJSjEYHU/MvZdGp
T1ZedJ6hpW/Vud4FsM/2MV0DD/Z2+ioZAYzuasaiSGiBebSVYBa/FhNRaclSQfGh
iD8j7xBSoVfW0bLHMq/KKe4GH6Lu+FF0KFgNoNuzDClpOBhHb/i9x7eHWKJSsfSU
qwgD2t1/fFnjMZ1HhMlxvlUGJrjmP3ev+ZWZyzHI5lruHj0uEP9z8F9TGq3hubCg
VsiLFPL1azTFa+8LzGNv+AlZodq6+gpl9xnXDps3FvyoxiXrzxwOme7nv4iByS1P
1chJgFWyk7QYp671VhWUtAo9lJzSlwH4vn66tVWeCaZZO//MWUFaTVq9koH1y8Ek
7bUKTpD2ZI5XnVULy0lLdkcQEF74E6OmOYW585OLG0qZ4NW2vH6PPBjQOnq/shpp
yfOd/g0/J1yY/JltSMgTeH+a0NwBVXEauSfp97/QTrKplOj8dziH5/wUd9UKIdnO
rR/VqAnIqnv/Ud6aYdPwUY3jL9gycjEVUlC9n3qUeekkUNrQO2Ndyv1IkRSZNPG8
LhbDaGdmWSyhsmoqP2vN
=XK6P
-----END PGP SIGNATURE-----

--fxRVKzQA1vU7LXPu--
