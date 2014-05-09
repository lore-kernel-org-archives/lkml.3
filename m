Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbaEIJ5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:57:24 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44901 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbaEIJ5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:57:22 -0400
Message-ID: <536CA67C.2090109@ti.com>
Date: Fri, 9 May 2014 12:57:16 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: akpm <akpm@linux-foundation.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/1] drivers/video/fbdev/omap2/dss/dss.c: add __exit to
 dss_uninit_ports
References: <20140423180958.8b3cc405c00fbbf7c6c5a947@skynet.be>
In-Reply-To: <20140423180958.8b3cc405c00fbbf7c6c5a947@skynet.be>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="AeMGSGLlMmj0gi91eLW9XgjTdD1CrS5G5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--AeMGSGLlMmj0gi91eLW9XgjTdD1CrS5G5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 23/04/14 19:09, Fabian Frederick wrote:
> dss_uninit_ports is only called by __exit omap_dsshw_remove
>=20
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: linux-omap@vger.kernel.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/video/fbdev/omap2/dss/dss.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/video/fbdev/omap2/dss/dss.c b/drivers/video/fbdev/=
omap2/dss/dss.c
> index d55266c..a1c1cc2 100644
> --- a/drivers/video/fbdev/omap2/dss/dss.c
> +++ b/drivers/video/fbdev/omap2/dss/dss.c
> @@ -813,7 +813,7 @@ static int __init dss_init_ports(struct platform_de=
vice *pdev)
>  	return 0;
>  }
> =20
> -static void dss_uninit_ports(void)
> +static void __exit dss_uninit_ports(void)
>  {
>  #ifdef CONFIG_OMAP2_DSS_DPI
>  	dpi_uninit_port();
>=20

Thanks, queued for 3.16.

 Tomi



--AeMGSGLlMmj0gi91eLW9XgjTdD1CrS5G5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTbKZ8AAoJEPo9qoy8lh71TNgQAKFCeaXACuyvqFUnCn55hFBT
2G0TQREpyUdjgWIYvBKUzEfBL7hWYnXBBh9wK8ngB2QtU/5KLR5YZTmPy/rXEj3F
v5WkD7Kuk2fB1f58hiXfj0Y6+h4k2qj5BMvHktE4K2DQVFG1jDc6nuJ9P3Zbtzd2
NIi0npQqQbH2zdox84amsOELejwPagjGtJ9HR7WX+qqT6coBbo7UFxLp67+GLmDo
poJOWcsPY3Yf4NR70UFH4Q2A2YJPRKDwibsvZhrneyS1XWY2V5Yih+/APokWo0U1
clpz5wTsuO7Gr+MXAc3hO/BRVoniERkYcW21RXlzHmd9asanzDjNNjf932PSg/W/
sVtbXun1rrjBCczirbQDAHCInAP6V9VycuI94+bYsJdYLX9yZNdTXNQI6obyQPSr
FmesSpCSgOzUhXOGzoR+zwZHAyV948f78T+sFwn6Q6801L5fxtaoPKdbhJyKfmHI
D0F/IGqUFaS/fLgj7Gnz17aYjRNYIANWCyJcZikzmmpwoCBchBW6GfbTpIRj69Wo
9ulBW8GsB9f/U5UcvcB9UY/A4ILxsDaCTt40cpff5Sz0aupUKBy1x/pdoHwxwrJY
CgdVVEwh5sjZkypkUnOK8+VFcpBUTSk4wTOZ5VW6D7kxUSxaCm3gBZgnTLDl0hnT
etz/puv7g9QdFTx743Xp
=SNtz
-----END PGP SIGNATURE-----

--AeMGSGLlMmj0gi91eLW9XgjTdD1CrS5G5--
