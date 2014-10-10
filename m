Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbaJJSAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 14:00:48 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60395 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaJJSAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 14:00:46 -0400
Date: Fri, 10 Oct 2014 12:59:45 -0500
From: Felipe Balbi <balbi@ti.com>
To: Johan Hovold <johan@kernel.org>
CC: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Andrew Morton <akpm@linux-foundation.org>, Felipe Balbi <balbi@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Colin Foe-Parker <colin.foeparker@logicpd.com>, <nsekhar@ti.com>,
        <t-kristo@ti.com>, <j-keerthy@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/12] rtc: omap: remove unused register-base define
Message-ID: <20141010175938.GP31348@saruman>
Reply-To: <balbi@ti.com>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1412881594-25678-5-git-send-email-johan@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5tINJiUS2/Dn5Rhr"
Content-Disposition: inline
In-Reply-To: <1412881594-25678-5-git-send-email-johan@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5tINJiUS2/Dn5Rhr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 09, 2014 at 09:06:26PM +0200, Johan Hovold wrote:
> Remove register-base define, which is no longer used.
>=20
> Signed-off-by: Johan Hovold <johan@kernel.org>

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/rtc/rtc-omap.c | 2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
> index 2eca141e784e..d1b5562a148b 100644
> --- a/drivers/rtc/rtc-omap.c
> +++ b/drivers/rtc/rtc-omap.c
> @@ -41,8 +41,6 @@
> =20
>  #define	DRIVER_NAME			"omap_rtc"
> =20
> -#define OMAP_RTC_BASE			0xfffb4800
> -
>  /* RTC registers */
>  #define OMAP_RTC_SECONDS_REG		0x00
>  #define OMAP_RTC_MINUTES_REG		0x04
> --=20
> 2.0.4
>=20

--=20
balbi

--5tINJiUS2/Dn5Rhr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUOB6RAAoJEIaOsuA1yqRElPYQAK3lDuWFVz4aALBTFUjTBajh
4Y6IXVWMMxSf791J72N+IcPSvlbs7Hymi8ciKc+mKEIjdaOYAHl5rx588FGlR8Xt
jiwI9z7U2H96vOpsr8uU4yBsps9BYpLrhER8JaWydm8nOCKPz9JDEJnJ7wlDBRkk
tiyRREcH6ilXtPpBQYjlfI8DICMeb+zN+i5GUKL9riEeI8d8KTEZqG9O3tzC7mUJ
1VWNhDTwYGHUfql8Kct0ETYAGFTQmmzbPSYHKFqA5VAkurr6xyq7b4ArnscFBkwu
ZGEDeTG2oI9YnkxlH41qzsog0uvPEzjweCKmsIXsAoltZBGEPx/VKJNw26kUgbUC
eXve89ZbCyjEmutcjJPyHD8dt1zRwnA4Rx2FUmswsZjO6IYmm39GVq5KZXAFHQZo
Mhpns+UZjIpMINMpqM9Qe4vf2aiwRHNPdvlvz6kkHPnplVhSTQ8vyL5vkgx2dsw8
IqRhLld10qMSgr9AB6HQd+lcwDAQDeT1W/KIdP5upt660Al0nCmovB8SM433Vb9x
k9AobtmjUtdx+w1jRcVAtXveQ9CtTmKRFXYGv+sY+3taM60bbPciRW2tH5t5wvRu
K+1eVukJljg9JgGLi2+z2ama225xFNHhPGl+UqSeJ85CEq3sNovZAWZoiigqrh7w
ZkEnnDugV7KEc5pjOIQM
=ay1F
-----END PGP SIGNATURE-----

--5tINJiUS2/Dn5Rhr--
