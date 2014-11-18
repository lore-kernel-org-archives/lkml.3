Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933302AbaKROvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:51:41 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48755 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108AbaKROvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:51:38 -0500
Date: Tue, 18 Nov 2014 14:51:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: lee.jones@linaro.org, linus.walleij@linaro.org, gnurou@gmail.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        ckeepax@opensource.wolfsonmicro.com
Message-ID: <20141118145114.GN22111@sirena.org.uk>
References: <20141111165227.GA24344@opensource.wolfsonmicro.com>
 <20141111170543.GC25738@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PZYVFYZbFYjzBslI"
Content-Disposition: inline
In-Reply-To: <20141111170543.GC25738@opensource.wolfsonmicro.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 81.128.185.34
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] ASoC: arizona: Add initial CS47L24 codec driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PZYVFYZbFYjzBslI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 11, 2014 at 05:05:43PM +0000, Richard Fitzgerald wrote:
> Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
> ---
>  sound/soc/codecs/Kconfig   |    8 +
>  sound/soc/codecs/Makefile  |    2 +
>  sound/soc/codecs/arizona.c |    5 +
>  sound/soc/codecs/cs47l24.c | 1133 ++++++++++++++++++++++++++++++++++++++++++++
>  sound/soc/codecs/cs47l24.h |   23 +

Can you split out the arizona.c change into a separate patch to be
merged via the MFD tree along with the new #define please?  Everything
else can go in via the ASoC tree but that build depends on the new
defines.

--PZYVFYZbFYjzBslI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUa1zhAAoJECTWi3JdVIfQ0t8H/jXoz+Qxae4NeoG8y2g5VKUJ
mRmwlDW9yKTIFCVyRFmzsaaXKgbBAhnjOG0ZTeW9CTYH/Yidlqpgq9cFOxPOlCMA
kw3P2inFLEpWDfunJ6/gA//Goa7hfRc38iyboDCzjcUAosiF5n/DBzw4VMhQPZ4w
WZUo7lXr0DjTIAGjFUt/irCZ0qLLWVB3W8tGuM4jpiZB1201ILnGMX+xPdJ99sa2
dS2PoDD47eQQRbG3D6hokeWFlOtdAjAZ2CyFmo6a5iSDfh8T+E94sIykvxahuVQj
pTa+s/jxwrWNGWp6x/IF4bjfcjh4Dj+/FxpYdpK3y/S3bGvLgGQ2nxhG7tOcrnI=
=ahcJ
-----END PGP SIGNATURE-----

--PZYVFYZbFYjzBslI--
