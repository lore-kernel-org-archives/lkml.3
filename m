Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbbANRiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:38:46 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38436 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbbANRio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:38:44 -0500
Date: Wed, 14 Jan 2015 11:37:29 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Felipe Balbi <balbi@ti.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: Re: [PATCH 05/12] usb: gadget: at91_udc: Fix clock names
Message-ID: <20150114173729.GG16533@saruman>
Reply-To: <balbi@ti.com>
References: <1421252524-24452-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1421252524-24452-6-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zVyz+SkbhTrRQGHt"
Content-Disposition: inline
In-Reply-To: <1421252524-24452-6-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--zVyz+SkbhTrRQGHt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 14, 2015 at 05:21:57PM +0100, Alexandre Belloni wrote:
> From: Boris Brezillon <boris.brezillon@free-electrons.com>
>=20
> The driver is requesting clock by their global name (those declared in the
> clk_lookup list), but this only works with !CCF kernels.
>=20
> Now that all SoCs have moved to CCF, fix the driver to use local names
> (hclk and pclk).
>=20
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/gadget/udc/at91_udc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/udc/at91_udc.c b/drivers/usb/gadget/udc/a=
t91_udc.c
> index c862656d18b8..9ff2f7e5c6a7 100644
> --- a/drivers/usb/gadget/udc/at91_udc.c
> +++ b/drivers/usb/gadget/udc/at91_udc.c
> @@ -1779,8 +1779,8 @@ static int at91udc_probe(struct platform_device *pd=
ev)
>  	udc_reinit(udc);
> =20
>  	/* get interface and function clocks */
> -	udc->iclk =3D clk_get(dev, "udc_clk");
> -	udc->fclk =3D clk_get(dev, "udpck");
> +	udc->iclk =3D clk_get(dev, "pclk");
> +	udc->fclk =3D clk_get(dev, "hclk");
>  	if (IS_ENABLED(CONFIG_COMMON_CLK))
>  		udc->uclk =3D clk_get(dev, "usb_clk");
>  	if (IS_ERR(udc->iclk) || IS_ERR(udc->fclk) ||
> --=20
> 2.1.0
>=20

--=20
balbi

--zVyz+SkbhTrRQGHt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtqlZAAoJEIaOsuA1yqRErpUQAITjLdrrw6xB15kBht5OyD+D
d0RcmycwawNLk0jfdGsW/CMdbBxUyqME7/WRrBBne8mdBQPBKmXNqFRAmim0CgsE
HC/0rp9dRwQev49vWdaDepU11Wm1LT7n+zlQXGxJmGkjbaDusbSEIGw1eJOcBAt0
aiXkFfLgNRwhDVBEP6AVxbSprq42py/zS3UOcpatsbjfXogAXA47EoLZgIM9hkst
S4SanrUnkkpNrs9sZ4Xm3h7nYYZtpUvU3FGckyZwNM2d4Ye9LPBQCk4mKIejNdEX
uQb2UcY5LI3g3NSq/cywkpjNR7eJfnBPtgqZXb29q/QqpFiYj6swBryltXOtZrJ0
DZrbtyMd8GRX+wMECt0fVyXFVPy30m+Fzfd/bySwx41cAFxiMoksJTzFlJNATc5a
qfVN3rt/Vu6B67/9t3oJrK38v4YCZ47uztzdFnYaTgJtkNrp6YssqCEmmpoivDTu
IB4NWNZVuCu7aIk5hgxcCVc2iUqUmGvyHSpIbOi+9+XrR3g+l3GgjOWBvClSyLKy
pR7cNn2LEPEfUcIOibmpm5fPPg45ITHa5FjlwUirwVmRjHOhXSmCBIlUQ4hQRbpH
D1lnLQXIkeoaVasI2Aor9MKRxyRvjZv1Qlb3yiZGeQfokTQNNyvBGo9g4k6QoAUB
hpd9qwJ7O8PRFL2nJc88
=7PYy
-----END PGP SIGNATURE-----

--zVyz+SkbhTrRQGHt--
