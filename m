Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731Ab3C0NjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:39:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42308 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751310Ab3C0NjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:39:20 -0400
Date: Wed, 27 Mar 2013 13:39:16 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Xiong Zhou <jencce.kernel@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [patch v2] sound/soc/codecs : fix build failure for next-20130325
Message-ID: <20130327133915.GU18316@opensource.wolfsonmicro.com>
References: <alpine.DEB.2.02.1303272127400.26487@M2420>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ff5AkW+g6+eEohN"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1303272127400.26487@M2420>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7ff5AkW+g6+eEohN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 27, 2013 at 09:31:33PM +0800, Xiong Zhou wrote:

> diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
> index 18fea10..f38af70 100644
> --- a/sound/soc/codecs/Kconfig
> +++ b/sound/soc/codecs/Kconfig
> @@ -79,7 +79,6 @@ config SND_SOC_ALL_CODECS
>  	select SND_SOC_WM0010 if SPI_MASTER
>  	select SND_SOC_WM1250_EV1 if I2C
>  	select SND_SOC_WM2000 if I2C
> -	select SND_SOC_WM2200 if I2C
>  	select SND_SOC_WM5100 if I2C
>  	select SND_SOC_WM5102 if MFD_WM5102
>  	select SND_SOC_WM5110 if MFD_WM5110
> @@ -370,6 +369,7 @@ config SND_SOC_WM2000
>  	tristate
> =20
>  config SND_SOC_WM2200
> +	depends on SND_SOC_ARIZONA && I2C
>  	tristate

I really don't understand this at all, removing something from
ALL_CODECS is not a good idea.  This isn't a Kconfig issue.

--7ff5AkW+g6+eEohN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRUvZaAAoJELSic+t+oim9S4EP/0YmqpaFfaCeMbh2keqtYkFZ
Alce3MyxsMq6l9Fux95Rt8EljOTutjcE65TnNJeVhKjyW0PopityHOjlLB4A1YxO
BGGcRyausoDjjCt7JaV1RsSienBbk82e3z4PPMjFJOV2I5Lql0setfIyNORBklFr
VpHhkGnKmlg94YZ21PRtnv1Rj4n25fGphxFSAszZCQEagtfAibiJEzsYNJTzBkqh
4sQ6wvvmh+u/ub9yFYREknZRLjv07AxPJMeFSF7YE7Ha6oddLhx+pbecU4Lk0SYB
GOwFr2pCHZT5tYFcWdP537o2buSP/ArCDjgb71IipCXtlkIxIfVCQB2pOKhGNJqq
G/MMoRjEa/cUQF+Q8L3eyZvyh8dTai3aDxyEuxcZG7fIYogYvRtEdSBy4HxcEyuG
ETXzS0otsSQl14uLR+iDM4vOaFcNywVz0UIT4TJxhMHOP560Ovnxi2iXRHs4SINA
osJxEh5jrpXcwi5TKoeJQuu+3zAvCffO+lII649AU3EoD63izRTe41PwaHOdQU5N
WH6Mtbi8AW+d5hPw+nGnF2hvyRy1AecAYslxWtCZKkf8MYr10D4miLxHlUqI5U0l
d7REnNuBm/zInIg0PXj9Oq3Uml6dTiW7H6kqE5VnKr48awS8sXdH4YikmSzsOysV
/q2ih3Y8KjARRCCOoXf4
=VUih
-----END PGP SIGNATURE-----

--7ff5AkW+g6+eEohN--
