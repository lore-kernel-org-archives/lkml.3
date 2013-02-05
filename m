Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab3BEJYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:24:24 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50756 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab3BEJXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:23:25 -0500
Date: Tue, 5 Feb 2013 11:23:12 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 06/30] usb: phy: nop: use new PHY API to register PHY
Message-ID: <20130205092312.GO32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <1359372631-8180-7-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hOh8F6DNH/RZBSFD"
Content-Disposition: inline
In-Reply-To: <1359372631-8180-7-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hOh8F6DNH/RZBSFD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 01:30:07PM +0200, Roger Quadros wrote:
> We would need to support multiple PHYs of the same type
> so use the new PHY API usb_add_phy_dev() to register the PHY.
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/otg/nop-usb-xceiv.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/usb/otg/nop-usb-xceiv.c b/drivers/usb/otg/nop-usb-xc=
eiv.c
> index 3060ed0..ac027a1 100644
> --- a/drivers/usb/otg/nop-usb-xceiv.c
> +++ b/drivers/usb/otg/nop-usb-xceiv.c
> @@ -197,12 +197,13 @@ static int nop_usb_xceiv_probe(struct platform_devi=
ce *pdev)
>  	nop->phy.init		=3D nop_init;
>  	nop->phy.shutdown	=3D nop_shutdown;
>  	nop->phy.state		=3D OTG_STATE_UNDEFINED;
> +	nop->phy.type		=3D type;
> =20
>  	nop->phy.otg->phy		=3D &nop->phy;
>  	nop->phy.otg->set_host		=3D nop_set_host;
>  	nop->phy.otg->set_peripheral	=3D nop_set_peripheral;
> =20
> -	err =3D usb_add_phy(&nop->phy, type);
> +	err =3D usb_add_phy_dev(&nop->phy);
>  	if (err) {
>  		dev_err(&pdev->dev, "can't register transceiver, err: %d\n",
>  			err);
> --=20
> 1.7.4.1
>=20

--=20
balbi

--hOh8F6DNH/RZBSFD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJREM+AAAoJEIaOsuA1yqREAfgP/1L/Z3dw6zrKsJSZATLmM4gb
mvAiRvK4mGDunHLCMReBHHFgyElgZV+DMDHaG5x+GTkFngGXTdRtWzjSZhpi9fAa
YnPUFPj/GJNhWNS20mlXvkOUUXXbK6NeckcGGByo0S6iF5hhNUZBQKjU+0UTh6yY
E0ywzPH4XwS1R5ciAVNGcM7epUxcXMWNJ+Pr3WSd2XYXP5nMxJtW1vb0ZTlwHMuP
2+RHqsNL5uw4NflzSNXNNoPPcyIMXl9e/2BVl6oNXZqEBWM0XhzFfz6Hu3Pb3fcT
tFg2g2E2/8VSQ4mYNGyJoHD1QUjMChpoBf9iaLLKJttPpxV2VJOZWnRSHi93442W
Rtck7c10Zxpgb3c74LiWds5DIrzq4e4oztkN+n7HmTFcmxbmGPeO6gyah8BxAh1k
4nr6Ksu3T4G0ETyVNsc13eyYYS8wOCZhNvmdc9gONBSQ6bTuRw+Omwt75TAtqJQF
DcRfMz0rBN3lmoBivP1CBA/sGod3F40Bn6kMrS80KwVB10ai1Htc0LeLtlv3hwJ5
lB8uiiiUvMtLRUCCxgX75GHdBadhGkAt1P5NRewc4KBhCGKzOWT5Mn9tEHTsLWqb
WPPhBZVHdj7tRRHt7Hul04Xre6Gdbbvka1gsjPKiLPFkOGdryHFA65g0OKKJBan/
YcaiF0eVp2n21oWttuom
=QUy7
-----END PGP SIGNATURE-----

--hOh8F6DNH/RZBSFD--
