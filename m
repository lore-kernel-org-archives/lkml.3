Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbaCaQLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 12:11:14 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49504 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbaCaQLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 12:11:03 -0400
Date: Mon, 31 Mar 2014 17:10:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Tomasz Figa <t.figa@samsung.com>, Arend van Spriel <arend@broadcom.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chen-Yu Tsai <wens@csie.org>
Message-ID: <20140331161042.GW2269@sirena.org.uk>
References: <1392059868-8782-1-git-send-email-arend@broadcom.com>
 <52FC8CB3.4090305@gmail.com>
 <52FCB571.4020904@broadcom.com>
 <52FCBC1D.7050501@samsung.com>
 <20140213162249.GT28112@sirena.org.uk>
 <CAPDyKFpU=nQAgfjMm6KNRAEKwChAx_SxFMC-pLbq8yis2mgB=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y88ZgXPnK3pWvLGs"
Content-Disposition: inline
In-Reply-To: <CAPDyKFpU=nQAgfjMm6KNRAEKwChAx_SxFMC-pLbq8yis2mgB=Q@mail.gmail.com>
X-Cookie: Printed on recycled paper.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC] dt: bindings: add bindings for Broadcom bcm43xx sdio
 devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y88ZgXPnK3pWvLGs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 31, 2014 at 10:24:00AM +0200, Ulf Hansson wrote:

> Using a gpio regulator would simplify here, since the driver don't
> need specific "SDIO hacks" but can use the mmc_regulator_get_supply()
> API, which calculates the OCR mask, based upon the regulator's
> supported voltages.

If that makes life easier the driver could also just instantiate a fixed
regulator itself rather than requiring that one be put in the DT?

--Y88ZgXPnK3pWvLGs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTOZN/AAoJELSic+t+oim9AkYP/RqfpNxK6cszxBAoBuMaYWbA
XjO5rkRzW3reFjkLAm4H1eEMuUG2kGq1hKtEzB5Ou1AWhSSkq15jpD+rI+OdG3js
R6ZWjkgpebGp250+1oxvgRnGSdbb807OXDINjBkZ3BPHcSIhdVhr9PGnXH+rH2io
YQjZ6A5nFBNAXYkVyIKQSKXb6JWZJHyM1j+7/7xrTmCUoLESNnhgKmPkF98xD2lc
hMyzdSLIMO8DRLF04O7BJQ+nUZ4Zi6DZYDzbOV9zShkLPF8qbXfthLE3pGLCvX4t
larAApYd87tBkfsfzhZLxBjeI7cjhlK9SrrQv5WgqioU9Y4EynfiKHSEX7s8fyOM
yDOtX3FbK7AT/Teysvyc5ePiJx55fUOz6Lr2BBQN16r9CuYBKtglZKaoynqPBZBH
TA9/NBYG13xuLWot5b9CcXsGeJ4VVmH7nAmzW+0NDLJE5s2phlVEnrcEwTc3Pj1J
8OkWgZ/GWuGlqNBILHH21nuAtUhZ83g3d7bBU2j1tH354JlkAK4/dtInYgpS94uQ
Z9wMwY/MS5KdeDxAcZAJVehu45ICPNXybBQ3idC1TRbWJzuZ9GtdpAdtho8ekfdh
lwNbowQ7xjER/u1+sTirEvTrMCe3kTrq9F3L+8RFgqMnJr1/lhyQRSbkDPBMBJM6
e+SZc6T9J4Hjqjehxpxm
=2aUg
-----END PGP SIGNATURE-----

--Y88ZgXPnK3pWvLGs--
