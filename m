Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab3KLBYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 20:24:40 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47966 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab3KLBYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 20:24:33 -0500
Date: Tue, 12 Nov 2013 01:24:08 +0000
From: Mark Brown <broonie@kernel.org>
To: Gerhard Sittig <gsi@denx.de>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Message-ID: <20131112012408.GI2674@sirena.org.uk>
References: <1384162956-28274-1-git-send-email-gsi@denx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h22Fi9ANawrtbNPX"
Content-Disposition: inline
In-Reply-To: <1384162956-28274-1-git-send-email-gsi@denx.de>
X-Cookie: Drive defensively.  Buy a tank.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] regmap: trivial comment fix (copy'n'paste error)
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h22Fi9ANawrtbNPX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 11, 2013 at 10:42:36AM +0100, Gerhard Sittig wrote:
> fix a trivial copy'n'paste error in the regmap kerneldoc, s/write/read/
> for the regmap_read(), regmap_raw_read() and regmap_bulk_read() routines

Applied, thanks.

--h22Fi9ANawrtbNPX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSgYM0AAoJELSic+t+oim9boQP/1hBQRaY71JFw9eejuITQr4x
w2+XdbH3OM7a6KrAXL3nNTWRjHr04JeD4wMw7/32e0pb/5Vj8DnTkiqKkF6BATG4
LGkcpEWHYSdQrJI3AfrvDQTZuuDIdyUfLgEaxoJq8pPsfDE+ypROhcdLRDxF9Ghv
/LonuYHg3nUzNSMxy8Kl7VlZQLWm8lO7jKsm2RHx+LPiMGz7gF3KZu7DpeSsewSW
keA3Dp2sHwAwWbxl2cUB0j6p6GMgQ9ASuIt6aKqZhMiwES/TQLaf90YhN1CVVXsF
hZ+DCNxWRkaONTVMiMPXSrQPmy2Lzu8LemTeSuUbecf4oJrj4G9KXPr3wjEWD6yT
RHTXFj0LdVxc/VC8wIMkrjCRG5dH3vtDVIYx3g7QGHn1bd9GXQL1wMLWIk15vSOZ
spaxMDojGzpQ4XsUQM5gXdYEOJpuB1uVSl4F9dDlv6iQwsks0Mqk9h1Ckor7DwoV
a3ai9GCgxdqfSYL1vUDmxFZBC+1PTVRbIY2H46cZxciq3hlAzVDB5D7Oax5PbPR5
h1dhaD8gTSLMxnSWnuV1gB0of9TereXm5oJy1fTEMd4X/CB2wg5U1G0Ox5lwEyeg
O7H5blCvkHkanbKnHXJh5OsP7nZInunhnV4J3Vdz/1FqyzKeVRSb3kVN+NJO9qmg
jfjQB/LsXdr3jDVg6Bm0
=t49l
-----END PGP SIGNATURE-----

--h22Fi9ANawrtbNPX--
