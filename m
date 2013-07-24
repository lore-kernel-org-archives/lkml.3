Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab3GXMXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 08:23:01 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41346 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab3GXMXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 08:23:00 -0400
Date: Wed, 24 Jul 2013 15:22:53 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <linux-arm-msm@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] usb: phy: msm: Lindent the code
Message-ID: <20130724122253.GC17962@radagast>
Reply-To: <balbi@ti.com>
References: <1372087664-26396-1-git-send-email-iivanov@mm-sol.com>
 <1372087664-26396-8-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Xm/fll+QQv+hsKip"
Content-Disposition: inline
In-Reply-To: <1372087664-26396-8-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Xm/fll+QQv+hsKip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 24, 2013 at 06:27:44PM +0300, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>=20
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-usb@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
>=20
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>

I really don't like blind Lindent patches... sometimes it makes things
even worse.

> ---
>  drivers/usb/phy/phy-msm-usb.c |   99 ++++++++++++++++++++++-------------=
------
>  1 file changed, 52 insertions(+), 47 deletions(-)
>=20
> diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
> index 6d05085..111f454 100644
> --- a/drivers/usb/phy/phy-msm-usb.c
> +++ b/drivers/usb/phy/phy-msm-usb.c
> @@ -64,8 +64,8 @@ static int msm_hsusb_init_vddcx(struct msm_otg *motg, i=
nt init)
> =20
>  	if (init) {
>  		ret =3D regulator_set_voltage(motg->vddcx,
> -				USB_PHY_VDD_DIG_VOL_MIN,
> -				USB_PHY_VDD_DIG_VOL_MAX);
> +					    USB_PHY_VDD_DIG_VOL_MIN,
> +					    USB_PHY_VDD_DIG_VOL_MAX);

like here, what's the point ?

--=20
balbi

--Xm/fll+QQv+hsKip
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR78cdAAoJEIaOsuA1yqRESGgQAIugeUPpnrCKxc7F+itZ2E6S
c04KH2htpoMuHU95Z6H/2yuZhYNKOpmgKakGgIxVTaVamf4hpnwy4BETnwyjpzGu
ulOTcs54xvgQO+qfYiQ7oogKPLNW5zG3iAckx4Ks/TLXxqRgVBa9F6ptA9qyCmbX
j3naFcvYeauUEZR7wHYg9LzKYuWfUjagxdmxemn9LkQdckxJZMBXxIRcqxHeJ5XX
JifdZZehLN/Se46teBQsRIMzgkA7fCdUFvQxo1piBQ5lp6z975bPB8LyQq/BTce1
ByBjPKvcNTTHl1FmZWnFNcugMAu0DF34NGsFWzGAL1kPzwTzHghLhOcuFr7bfbd0
wr3C7bWRnofTJ8V4YjqGdYHWeGFigvVLONcCsqWDxVn1T0KM0Gv0s7S0gC2o+2C1
PPHIgXHU4zVI9DhfsrizlIx1JStBHTZXv8KWsrWSri8SSeC2b1Zgwn6/2FYP4HYu
2sR0WFzrAgHU1fyRbaIZOCF6v7OwFnQuwen+i01jByoqnngTo47aIwAUqXH4ImHv
bl/nKm6X980IQ/nO/tpfS+E24JjxILjVLPfcYVNi4D/I6xoz2/I5ZEvJ959WO385
bH/zxQ7yeIAJcWayPbpyx/TZzypuRtBb4i9Z4F2nmKTMRywewToZEUqGbDYRxJ8t
j7sCjhK8gy2gFF3UlHvD
=TSf7
-----END PGP SIGNATURE-----

--Xm/fll+QQv+hsKip--
