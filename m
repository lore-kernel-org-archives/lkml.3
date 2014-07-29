Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbaG2SXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 14:23:55 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33326 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaG2SXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 14:23:53 -0400
Date: Tue, 29 Jul 2014 19:23:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.de, timur@tabi.org, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        shawn.guo@linaro.org, b02247@freescale.com, b42378@freescale.com,
        tklauser@distanz.ch, varkabhadram@gmail.com
Message-ID: <20140729182310.GY17528@sirena.org.uk>
References: <cover.1406628283.git.nicoleotsuka@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pIgUhm2PSpi2KHBa"
Content-Disposition: inline
In-Reply-To: <cover.1406628283.git.nicoleotsuka@gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v6 0/2] Add Freescale ASRC driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pIgUhm2PSpi2KHBa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 29, 2014 at 06:08:51PM +0800, Nicolin Chen wrote:
> This series of patches add Freescale ASRC module driver support along
> with the extra request in imx-sdma structure required by SDMA Device
> to Device script.

Applied both, thanks.

--pIgUhm2PSpi2KHBa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT1+aKAAoJELSic+t+oim9SaoP/1FVsjb2QpLsKVSx6LP5AVJY
DKmL2lH6q3YqSurOEBtoKAPw8738LJdWxGtRGqPEA+AMgP2QwXE35PIEyo3NFE0K
ifGX0KKRfmvvGqWGajnYThJ71Z/0AWdlHj13ZTBuyschGBNi02JmeAwbPFH9y/Ux
Wab6Ygul8yGR3pcYO86vSAvPB9vXubHbZJIeyHV68saOjqTcR6BAK1ZgC6tFzvz6
QRtjosyqFDK00gWnXxPr3iyP+nq31cZPX3+LABwm3UDo8palIeKy+fz0AKpVr5IK
iE85eb/YQFJG+a0UU6JY0sxaQ7BYtnGIFRcgaohlUDyWvgTSnFIdDWpobaFCO1KF
M6pxRAtS3FPFY/oGvK+rzt7+fRkyj0AKd1mJLryYa6tG5OlBqESCuqy4mUa9xTmp
fewpqjuZPGURNX95bBl6aYtwqwC++fZKV+iM5jl3y2Hu60pGtXWanO6N5VxQPEXa
Ayd2VTrCQc6hgc3vmLTeXH7xFFX25HlFcYADI9ZCvH70JpeNmcKJzJyezF+lC6Ew
Rwx4pIRFVhi/NKUnWc8MWriKDhz27k9urM8VCesnTjZ2AwQUmX//rXQlJBRTWqWn
easFnaFB+wXzI3p/X7V3sTXYFkyOyWaludbgIyvU18hIwC2boLA2KDBkxfFwizFT
RnngHEH/Pf2zFzmlRuJ0
=ExYX
-----END PGP SIGNATURE-----

--pIgUhm2PSpi2KHBa--
