Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760914AbaGYQli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:41:38 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54819 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaGYQlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:41:37 -0400
Date: Fri, 25 Jul 2014 17:41:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Kiran Padwal <kiran.padwal21@gmail.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de, s.hauer@pengutronix.de,
        fabio.estevam@freescale.com, kuninori.morimoto.gx@renesas.com,
        Li.Xiubo@freescale.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140725164117.GT17528@sirena.org.uk>
References: <1406203117-2767-1-git-send-email-kiran.padwal21@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="02C+GlUcNvfRYA2K"
Content-Disposition: inline
In-Reply-To: <1406203117-2767-1-git-send-email-kiran.padwal21@gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: ak4642: Make of_device_id array const
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--02C+GlUcNvfRYA2K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 24, 2014 at 05:28:36PM +0530, Kiran Padwal wrote:
> Make of_device_id array const, because all OF functions handle it as const

Applied, thanks.

--02C+GlUcNvfRYA2K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT0oiqAAoJELSic+t+oim999cQAJLCqvyIWbigXLoIRtrxGYoh
GHy1nPjwhJbZm236uRkUWHK2dbnNzFhE33xZ2w9IVW4XNffGLrkyXJr2bd8d0Wyv
7kpYcmVXOUiLAEaO/9BKK5Z6JWRKEDKacz7LtdwXUshaOer3TnoZlW+qIy441dqd
mJts1q+eqCiaJ33KqEMoJnaupKpiLwjT4mx87DSY/5JOIv8/dCQ38UujGU6XH02F
NgC3q4vqiqr3Lc/SiSXtskLRuCydYGkVCH0Kr1Fgy03cE3gySOqFM7lRBmLFwp9K
u52vZFzJp8fa27GWR7g5uiYZvnelIsED69/CleBR5iztTEQVNTX2Tz9v7CJ8i1dv
iwT06ZQ2NduEZG2/rJax7pYjBTG4Q3jtrF4rD3vcqxfZN1+Jv+Eb03cMs7XtqXzx
adNQDNxK+fQp2fgrXUVvBkalKOkTmRyP+uNPuLV5l5xDgAmrDZNqST04SSKNigCq
2J+jJBx+JT999FrEhf2vnZKUo6KdcuYEvSQIB9eXflLgkHpcM6WtYyq0xXClJ02Y
rspt82rwZUpKCWQlgtOCD25r0AfDu1EyS1PxbVQkDt37UxmVVlDBsVFIr+ZNAG5A
e+/dDk4L7M+98DiyqJKeWR9EGl4FmcGUwqJY0wyrFEZEefPU9y/dqEXFmHJiw6gL
Rpl3kFHzNonjKHz1Iv2Z
=fsC4
-----END PGP SIGNATURE-----

--02C+GlUcNvfRYA2K--
