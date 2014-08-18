Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbaHRO4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:56:46 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46970 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbaHRO4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:56:45 -0400
Date: Mon, 18 Aug 2014 09:54:52 -0500
From: Mark Brown <broonie@kernel.org>
To: Shengjiu Wang <shengjiu.wang@freescale.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de, nicoleotsuka@gmail.com,
        Li.Xiubo@freescale.com, shc_work@mail.ru, fabio.estevam@freescale.com,
        xobs@kosagi.com, arnd@arndb.de, sfr@canb.auug.org.au, timur@tabi.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Message-ID: <20140818145452.GD14537@sirena.org.uk>
References: <cover.1408350626.git.shengjiu.wang@freescale.com>
 <ee71a6cacc1d0bc1459bf9c21efc755c16e955b1.1408350626.git.shengjiu.wang@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TMTfqzsZeEKgETVO"
Content-Disposition: inline
In-Reply-To: <ee71a6cacc1d0bc1459bf9c21efc755c16e955b1.1408350626.git.shengjiu.wang@freescale.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 216.80.64.155
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V1 3/3] ASoC: fsl: fsl-asoc-card: Select
 SND_SOC_IMX_AUDMUX
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TMTfqzsZeEKgETVO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 18, 2014 at 04:38:40PM +0800, Shengjiu Wang wrote:
> Building kernel with SND_SOC_IMX_AUDMUX=n leads to the following error:

Applied, thanks.

--TMTfqzsZeEKgETVO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT8hO4AAoJELSic+t+oim9FdAP+gKsNJnyM2axEABYJ1G4HGnG
dQ/Po4rAdZ/C9NVtTgZq66v/YyGetydNLU9mjYAFIzaxgI1Mp1ca+IfNobO+K46W
9Mrx76t6Oc86hsRL4XQoMhCT5rQDHKYLz8aSaGCUm9ScQyyfTvNH7f3gjD6w/o5o
YzPP3hdoZvhvHR6Tcu9RpG0XLc8iKmcEwBJgWY2yHrnRnrWw7SHdkUYNTt3xfvzG
RiAUBpBcPOX9tKQCFiXAX54iNbBRQtq9cgLa9RSZll/Mjd2vMIJGNxGRqSyTYHVH
+LxpxMY422C3/mBh78RbTo+Zypu9teXdstF2YhEKCyZ5wsQeYIFJYhhqDxGWHhGo
7QiiSAvJXP3icmHH2yri+fpsEhZ/tAFm6CEA4Uk/Rg4z2QFBtxs2XypH21fJS7FH
ywddDt8K/fW5MfEa/X8IoHxhkAj0asq6kknFqJJ66F/wsc2xytWQHcRO8nlFQj2e
gWGh2yDvy17IWTtBgbtOgl3Tes8iYz9s7P2eBTR8ttg7Pcydf+AdPCskYW5Py4US
sgzl67Ak9UQvpJuF20TVl19g4Q2w5sD5wci6PDVm5JeCAYN4zcC7fmfG7wOLojbc
sewHkUAIXrfYpaV3ZCARg9RX39UWKFGlLgewliY+cFEe0/f7n7iF8bT9lPi9Igt3
ph+r3vtJi68HvW8cmTKP
=tLCH
-----END PGP SIGNATURE-----

--TMTfqzsZeEKgETVO--
