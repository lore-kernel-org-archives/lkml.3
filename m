Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbaCMP2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:28:16 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52001 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779AbaCMP2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:28:14 -0400
Date: Thu, 13 Mar 2014 10:26:28 -0500
From: Felipe Balbi <balbi@ti.com>
To: Suresh Gupta <suresh.gupta@freescale.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Suresh Gupta <B42813@freescale.com>
Subject: Re: [PATCH] usb: gadget: fsl: Add FSL USB Gadget entry in platform
 device id
Message-ID: <20140313152628.GI4599@saruman.home>
Reply-To: <balbi@ti.com>
References: <1394719531-27062-1-git-send-email-suresh.gupta@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qVyHzDF4yf4A8jkR"
Content-Disposition: inline
In-Reply-To: <1394719531-27062-1-git-send-email-suresh.gupta@freescale.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qVyHzDF4yf4A8jkR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 13, 2014 at 07:35:31PM +0530, Suresh Gupta wrote:
> From: Suresh Gupta <B42813@freescale.com>
>=20
> 	Add FSL USB Gadget entry in platform device id table

why this tab ?

> Signed-off-by: Suresh Gupta <B42813@freescale.com>
> ---
>  drivers/usb/gadget/fsl_udc_core.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_u=
dc_core.c
> index b7dea4e..35b20e6 100644
> --- a/drivers/usb/gadget/fsl_udc_core.c
> +++ b/drivers/usb/gadget/fsl_udc_core.c
> @@ -2654,6 +2654,8 @@ static const struct platform_device_id fsl_udc_devt=
ype[] =3D {
>  	}, {
>  		.name =3D "imx-udc-mx51",
>  	}, {
> +		.name =3D "fsl-usb2-udc",

why aren't you just using chipidea ?

--=20
balbi

--qVyHzDF4yf4A8jkR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTIc4kAAoJEIaOsuA1yqRER04P/2Q5uYwfkZJ0XnfZvNYFlybz
FenbK+7ZdtFtcrz0y6z4pVDQ7TDYRi5t8Dj0imRqAB4u3GYm7oG7ZsOVx/2pKOm+
FOiKCh7WkUmR9Wly+cLsDMB29HE7dUqoAFhFxCXZDBiVJo3AWdN+9AjgrJbYzfEi
ZYOofjCYZlQUtGcTfSvWw3P/PPbFuziQ+kP+p1x6VIq60/RK0HT/zaEnfCiR3J8l
V8c6JvvaVoWjTNtiFt1OdQ4/Q8livLjH2KjCByG6qUAytSJmqM/yLJqAoQBKUOyB
7Lag8+1giEu5RW0L1HvqxFObUNvneuS1y+5wKOcgsfPX50CMOTFurj0ObxrglL5F
BYz5VhJxIXuIog5lWvdE9hXCT22QtnMXnCCwxYP6/GRCl1NsZ9Wfmn8QTiw7wl8d
wtxvMNdTrETObSiBRoGHW17/i6cijwo/y8V1gdM8ua8i3OnmrVbM/UN1PRvx0AQi
InlSFto58d1VRkpNCfSL+sOiLLBJKaNPWpQaa7joVvbiTRGaTtOgu9MUKoCG/RcF
QyBZew0hqtOWd0mV4KPi0Tt2xzHJ7KAPpwEJXe/FPF+4z50qVKXFK43TVyH2SK7t
aQoYr6d5uJKa2gTMqf4NQV/tTL4Eily+MMiHWK/A2ssLwOM/gJjjMkyHtE3QAg8u
bKjOh/DZ8jTvM4uYVrL5
=OA3W
-----END PGP SIGNATURE-----

--qVyHzDF4yf4A8jkR--
