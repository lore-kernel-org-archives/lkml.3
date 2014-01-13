Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaAMLZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 06:25:57 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53448 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaAMLZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 06:25:54 -0500
Date: Mon, 13 Jan 2014 11:25:45 +0000
From: Mark Brown <broonie@kernel.org>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Cc: Jean-Francois Moine <moinejf@free.fr>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>
Message-ID: <20140113112545.GG29039@sirena.org.uk>
References: <20140110081729.035ce46f@armhf>
 <4ff4c32fbad64d90b0839a7a43642adb@BY2PR03MB505.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gJgGjUUWrnN4mpen"
Content-Disposition: inline
In-Reply-To: <4ff4c32fbad64d90b0839a7a43642adb@BY2PR03MB505.namprd03.prod.outlook.com>
X-Cookie: May I ask a question?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] ASoC: simple-card: fix one bug to writing
 to the platform data
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gJgGjUUWrnN4mpen
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 13, 2014 at 09:09:43AM +0000, Li.Xiubo@freescale.com wrote:

> @Mark, Since what Jean-Francios is concerned by is another issue apart from
> this patch itself and being discussed, can you apply the patch?

I thought I'd already applied it but if I didn't you'll need to resend.

--gJgGjUUWrnN4mpen
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS0802AAoJELSic+t+oim9tEoP/0UOgqDfQ958wm+M9lMqC+8P
vLt7seLV3Pr4IV/URdSeMU3nEkomowv5+d07WsMiigRFUU5oFU4kO+uVVM9DJRQB
gcz9Ga4WQKcPy/ZMkySV0j2S26icw349i1YWSTu3vofN4RK2BM7nq4PVDWx+IRWf
4CY/Ffh0CQBNnIETteMJEaAVjOH60wg4NwCrxtsEB78MZHUjqnTNCJu9WxswJ5By
YzkdK9YPyi0J35jLVbukH8NXfRBDn2mMMERju1JLl8SUsBON013qhJVzBKdxfVUm
nU9FpO5bSfYYh4/CcEvVvOaSjGieMeVCDGgxACkkqzIEpIINFzHUKu9tUn8VS+OY
5hNKLdalbieIL8dVbjCkTocsgBRmRhB63Firyfm1FOWNk6K3COxgu6kG5q2HeQVl
nKVLIdS3beAQ8/kaKi+jkjyGsWvPcpbrs/KSp7Mw70/fGNisg4LrRQa5PGId4dk6
ykEvqTdt7c4+la3ZMrqWYOaiaSa9os86ZEUmYSOvI9TddCjjeNnhoKmsOg6phZDQ
v4LZZjSEL6rpMa0z0CpS9+i8zfmXONSP9NY1i6rz7r7FRK+g5FdTu7P5jNQiUpG+
fd7x+GLrTjztZfosJLwazxMFDxLMXf4Z/QYItlUgsMOSkD0WJXIDbI1Q4xORbslE
vEqxY+/Xukp4mMyopVSF
=9VKC
-----END PGP SIGNATURE-----

--gJgGjUUWrnN4mpen--
