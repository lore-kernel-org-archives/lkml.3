Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761015Ab3GSSym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 14:54:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47264 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab3GSSyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 14:54:40 -0400
Date: Fri, 19 Jul 2013 19:54:16 +0100
From: Mark Brown <broonie@kernel.org>
To: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Ryan Mallon <rmallon@gmail.com>, Lars-Peter Clausen <lars@metafoo.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
Message-ID: <20130719185416.GW9858@sirena.org.uk>
References: <201307190953.25957.hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1Wg5Vd7si6EhrIHA"
Content-Disposition: inline
In-Reply-To: <201307190953.25957.hsweeten@visionengravers.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: ep93xx: fix build of ep93xx-ac97.c
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1Wg5Vd7si6EhrIHA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 19, 2013 at 09:53:25AM -0700, H Hartley Sweeten wrote:
> Fix the build of this driver. It was broken by:
>=20
> Commit 453807f3006757a5661c4000262d7d9284b5214c
> ASoC: ep93xx: Use ep93xx_dma_params instead of ep93xx_pcm_dma_params

Applied, thanks.

--1Wg5Vd7si6EhrIHA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR6YtVAAoJELSic+t+oim9NSMP+waWWU8DTARfpgtn2Mrolyf9
wqImY4sFaeEtn/6Cg7LHTLBs9Xerj8SxKpUXLF2J3s4Z0tBVf6iMW18JzR/2v0Uy
T65T0gLW0/ILjErkUJ68uSOZcWYnmAx5AXOxOGwkCv68bmiXoqXBWN8dBwAQgf5+
PaY+kZiBgZGrkho4REG4tcoNoGmhowiN2LWnOTMTB9fYkrx6EGdc8hoZOKTbTQQ1
nwxzEBmTFahmeCZskhOtBwBioOM1U8xMVFLLEZfSBzgU/exikcFxSiV4V2LwFoAQ
lXmx4lAZMkZx8bfWjKYMQg3qMS5A2cg97nRyXEGSvvRTG74ZGagFfC6rIIwAWHmh
gOHV1SbIWm4XsLKonF9HNzbXd6cFxqGRNVDp2PwhV5iCIWsyxp7Oo5CH2GYX4suY
cBAIfpOahjzPalBIVX3o6fNRQAmcOcGc39gXomYeXjgPFSfLIzZHTNof6tn0nhy0
a3ZgVpXPILV623LcoKLKK6HoT7cCLGZfTbaT/Pbr6tvB2AWXk7MhR6C/A/3YVp+6
vJ7gTd8aE2XnI2YfMnPGjOG+3d9I1X2FiapQoPrPHEZdlMrCS7k4Gss/uu+GnUtM
KeVqx/tdONDLIqCOb6OQlLZotP3eDA0KouDk042Gr4E13/5XRtJ0otP8sGINVbd0
w0MBaVhMWS5YrjwJJYQu
=6MLY
-----END PGP SIGNATURE-----

--1Wg5Vd7si6EhrIHA--
