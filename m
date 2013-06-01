Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab3FARAE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 13:00:04 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44673 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856Ab3FAQ77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 12:59:59 -0400
Date: Sat, 1 Jun 2013 19:58:54 +0300
From: Felipe Balbi <balbi@ti.com>
To: Thomas Meyer <thomas@m3y3r.de>
CC: <balbi@ti.com>, <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: lpc32xx_udc: Cocci spatch "memdup.spatch"
Message-ID: <20130601165854.GA15095@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1370079406.29224.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <1370079406.29224.1.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 01, 2013 at 11:36:46AM +0200, Thomas Meyer wrote:
>=20

-ENOLOG

please add a commit log.

> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
>=20
> diff -u -p a/drivers/usb/gadget/lpc32xx_udc.c b/drivers/usb/gadget/lpc32x=
x_udc.c
> --- a/drivers/usb/gadget/lpc32xx_udc.c
> +++ b/drivers/usb/gadget/lpc32xx_udc.c
> @@ -3046,11 +3046,10 @@ static int __init lpc32xx_udc_probe(stru
>  	dma_addr_t dma_handle;
>  	struct device_node *isp1301_node;
> =20
> -	udc =3D kzalloc(sizeof(*udc), GFP_KERNEL);
> +	udc =3D kmemdup(&controller_template, sizeof(*udc), GFP_KERNEL);
>  	if (!udc)
>  		return -ENOMEM;
> =20
> -	memcpy(udc, &controller_template, sizeof(*udc));
>  	for (i =3D 0; i <=3D 15; i++)
>  		udc->ep[i].udc =3D udc;
>  	udc->gadget.ep0 =3D &udc->ep[0].ep;
>=20
>=20

--=20
balbi

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRqihOAAoJEIaOsuA1yqREmHoQAKV8IDDuUOlia1YLQb5rE/Q+
1OkD2gomYCCH29ABITPA8WGCU+BSut7LKbeVWjL6cANgE3Va+sNF1e4sS7qrKTMO
ruVvI2uW0DPHaMkwz2YCA8ift/59ecLPbrj8Qr+lsdAeETlStctbkz+WYBhrIG12
t5J6ibv7dOC+Q3Y/1WdjIoTCj+F3cS9X33JCMTTbceYklPLyvEBp0kBXDVxhvnTi
wtnJ51xzMbojgCH5cB5zVkoEU7lstxGBKMm+O0Cfp2c2hYASPVPhXXfvLnhiJn7U
U/zXyGIHxSs2W/0Ysm2otz41UVU1xG840GstVJxocmr1DwPUdhCr99wNIQ8uaAXO
P0o3kB/QZ+oJsgBSemJG5GiPARYSiKSBfzK1JRNh492h3ACqL6sL9xLhESurQmoS
xq/J4Xeg02v9rV3xBIuTjK6rbRVqd/mL+9i6j9WyJJedsT+5lUehc3+jzaEyjM4w
6Xfxv74vy3S76ooBfoRYju7jH0Q0qRCNZBzlbzDc8F+CoXQpQjd0nOScWZFCL38+
ZDJAn82JkurYa18zLKX7hVtuvQZzUy+rT/qwdFWMHOoJ0UjMeWjKIS5B5jjRXQGV
iAMb+SqF46pM5a3sc2miMhp/pqMUdL4RjJts0QMGViG54xWMMoKgJGPtxVqlCcfu
uZPtdLTW4W53vjpH/+x8
=Teyc
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
