Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763142Ab3DIRIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:08:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40285 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753993Ab3DIRID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:08:03 -0400
Date: Tue, 9 Apr 2013 18:08:00 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Mack <zonque@gmail.com>
Cc: Josef Ahmad <josef.ahmad@intel.com>,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi-gpio: init CS before spi_bitbang_setup()
Message-ID: <20130409170800.GW9243@opensource.wolfsonmicro.com>
References: <1365525613-27198-1-git-send-email-josef.ahmad@intel.com>
 <51644A98.1070904@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/hzbcv1ZPoZ/SOgH"
Content-Disposition: inline
In-Reply-To: <51644A98.1070904@gmail.com>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/hzbcv1ZPoZ/SOgH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 09, 2013 at 07:06:32PM +0200, Daniel Mack wrote:
> Cc: Mark
>=20
> On 09.04.2013 18:40, Josef Ahmad wrote:
> > spi_bitbang_setup() deasserts the chip select line to initialise
> > the device. The chip select GPIO line is obtained from

Please resend the patch - git am doesn't know how to strip off quotation
stuff!

--/hzbcv1ZPoZ/SOgH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRZErFAAoJELSic+t+oim97fgP/AzxBXM4qvTxwn3WQOGvYqXw
7LODDFRZIQjEC5PDUpKDMzgvAWvmtfca90Phrplon0/kp6ahdoQdSp19w8afD6Pt
JnK4tuYbrgXKo6mQeEIgWMbAw2sUimpxkmyLeP08Ua7JaFn5ros+hr9cBSD19wD3
AIMOcP1R+dm3ex/Uh/cyBQ8KM/vTIc7mGKhrgA4Ke944Pp7a2aa6paUffxOP9CDG
Rh7QdwWrVmgdQ1HWCcCSaiL1Je/fDIiqDWc/K1Bzf8zGHDYb2YxsxVDQK3wY4XOA
xdlK2LSiE8gtL4xbATYrm7Uh04uvO1imMBmzSndWrRYRCe4YzvuB3sOJcxylwMYR
GVKbEOIyaEMamFYHTn+8aYf3FADacnF6ioQEIuYwf9nZwnUpeeAfvY7NHaUEMeX7
NW/EoGBov6144gifC8kju/lKSRV56DxsOnELT5VVsZitIjJgI8XHeE6HbYKAccFc
85jyObDoj2O+qbikDKUrsQnltGcMugkmpY5VDCjuLd0P4vFstWS9MTgJpFD+UrYj
uVziFPjYvZIRtambxGoSwSUihj2rJ0WgcoEVaRpVnPHNPioT1hgDdh1ZcwQII5Y0
b3BX72v1c3v9mFcspC0Wzh1Pc6VIwBs5cUkHWAFcSO3RViEBME+W8jexLjgJkauY
cBAa6ffyaddiEBGagGg4
=0JRE
-----END PGP SIGNATURE-----

--/hzbcv1ZPoZ/SOgH--
