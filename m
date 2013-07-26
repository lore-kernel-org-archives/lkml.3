Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab3GZIl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 04:41:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42536 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365Ab3GZIlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 04:41:53 -0400
Message-ID: <51F2364B.6090605@ti.com>
Date: Fri, 26 Jul 2013 11:41:47 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
CC: <plagnioj@jcrosoft.com>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/video: remove unused parameter in Kconfig
References: <1373259806-23067-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1373259806-23067-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="treXOS30gad8uCb8lSsdtPSqMDUbI0mpg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--treXOS30gad8uCb8lSsdtPSqMDUbI0mpg
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/07/13 08:03, Michael Opdenacker wrote:
> This patch proposes to remove the FB_NUC900_DEBUG kernel configuration
> parameter defined in drivers/video/Kconfig, but used nowhere
> in the makefiles and source code.
>=20
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.co=
m>
> ---
>  drivers/video/Kconfig | 7 -------
>  1 file changed, 7 deletions(-)
>=20
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index 2e937bd..a9c0964 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -2098,13 +2098,6 @@ config GPM1040A0_320X240
>          bool "Giantplus Technology GPM1040A0 320x240 Color TFT LCD"
>          depends on FB_NUC900
> =20
> -config FB_NUC900_DEBUG
> -        bool "NUC900 lcd debug messages"
> -        depends on FB_NUC900
> -        help
> -          Turn on debugging messages. Note that you can set/unset at r=
un time
> -          through sysfs
> -
>  config FB_SM501
>  	tristate "Silicon Motion SM501 framebuffer support"
>  	depends on FB && MFD_SM501
>=20

Thanks, I've applied this into my 3.12/fbdev branch.

 Tomi



--treXOS30gad8uCb8lSsdtPSqMDUbI0mpg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJR8jZLAAoJEPo9qoy8lh71rBoP/jB8Aed2jSL9QS+/VMH3RaW9
J1ncszrcpXdinFRGPDcqgOZBGCMD87L1t0y1OhLDDhYnYbMdFSg91c8TvH5qY8DB
v4vPrR+zsmX2M531hlUj+s2OQvWpS5KIcez8TFLyvOB4DvoTo2UksBLqQlvDU1XJ
G5bDkUseJxTN5REiCloFEZDwdJF3v+Rb+VfI7qFEeUR8hgMJ4pfpiGF9NbueMdwZ
5Nw9Zud2Td/ET5j4eBWHBqHNdXVP3wdF6OzsoVeJN3Ly7OSEK+VYoHDrmxa7uQaX
EVeZmYnKniJ15/OZVi0gdJ1jQ6/xUm1PR/jCM+vAKSTqHor/A9NM00sDxdWiqNfh
We59E9W0xdnFNWGA2PUyEklNRaNFYZRIo1jkCuyexaWGFGuwB6/2SOwsQWrVjw8r
F8/dPUX5F27ra7ORTjUpCnU5Ht1Sy08QWf0PzGH/zxlvXl7EEo+xJih1nlGzeNMu
MUU0bDip1EpgLJ758CNdyzD4oj9xJtvKV8FBAMN8W98vFjWUge3B5O40Jv2ovds5
92/f3S8WvQ8YNeeIqB8fOoJ1BUfD+apMycuopu99pTKvRIhotSNW9ZDmkZpEM3Rd
TvWkbNsVd0/iK6vMs3W7gmSc0iy33lIV5z/koO3kLo6RQSJynqiaAP1OosAZjWB6
Hh5MXd1nOy+mJbyhGoL/
=A8EW
-----END PGP SIGNATURE-----

--treXOS30gad8uCb8lSsdtPSqMDUbI0mpg--
