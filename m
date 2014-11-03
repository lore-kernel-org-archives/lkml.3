Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbaKCNWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:22:32 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42236 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaKCNWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:22:30 -0500
Date: Mon, 3 Nov 2014 14:22:19 +0100
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Krzysztof =?utf-8?Q?Koz=C5=82owski?= <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH v2 2/4] regulator: Set ena_gpio_initialized in regulator
 drivers
Message-ID: <20141103132219.GE24292@pengutronix.de>
References: <1412776028-15655-1-git-send-email-mpa@pengutronix.de>
 <1412776028-15655-3-git-send-email-mpa@pengutronix.de>
 <20141013144235.GJ27755@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d9ADC0YsG2v16Js0"
Content-Disposition: inline
In-Reply-To: <20141013144235.GJ27755@sirena.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:00:20 up 18 days, 23:14, 60 users,  load average: 0.08, 0.03,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d9ADC0YsG2v16Js0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Sorry for the delay, holiday and so on.

On Mon, Oct 13, 2014 at 04:42:35PM +0200, Mark Brown wrote:
> On Wed, Oct 08, 2014 at 03:47:06PM +0200, Markus Pargmann wrote:
>=20
> > --- a/drivers/regulator/max8952.c
> > +++ b/drivers/regulator/max8952.c
> > @@ -225,6 +225,8 @@ static int max8952_pmic_probe(struct i2c_client *cl=
ient,
> >  	config.of_node =3D client->dev.of_node;
> > =20
> >  	config.ena_gpio =3D pdata->gpio_en;
> > +	if (!pdata)
> > +		config.ena_gpio_initialized =3D true;
>=20
> This looks wrong, we're checking for pdata being non-NULL immediately
> after dereferencing pdata.

Yes this is wrong, I changed it to check for client->dev.of_node instead.

Thanks,

Markus

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--d9ADC0YsG2v16Js0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUV4GKAAoJEEpcgKtcEGQQS24QALgSKG5wsDYp65wEkxqwtDqL
UNavkA8PBGf0y9rlnH58PV6LQBNHcfO+HWtDLM6PXICoWcLqdfekDR3Kw9bIad9e
W1TL8b3sVHdpd0L/K2JmHfwpB7Su6cc6kjcoxQ426dmBHVfpkGobyAF78+ak/71H
lNVWxtK5PkBsLWIKBziMA2/EORTzikqxFN9NU1zQ/gTC2lVXxeNCYejPlF8QBVro
BoQaHfklLELWLmNbEDnK25Qr8Y4DqnT23Wk8A8/JdExN7BmoUZlS+HwI/omvjgKu
r0kaX/Ptpt+fW3MCZPG5VhxW6jajOeu10vEIH3dYweUssZOjGlcop0DOYSzdblDS
XXj3gN/Q7L+3wWuEl4P1AoSAL0FcpCxzfpR3ui7AATRiQpf4foDBWPRrTC4/IxHV
vCj/DA9+9ejpoHtLkgVliJw6vksWNp/ToYfgwwRj3udNcXEdQK4q6PNZBbgdxvwa
Nbs6pCaYumLvSK1HFvRK/8HvemTBqBs7Nokg4YR0GQMoUaq+UPVkkzDV5qJyvNFA
3N4AyqWyH1xYBu3Rih21pIujO6/Xkj0Jz+Y785TImp5HC+iC8oT4bRi/DLCViMTP
nBLHL5/gkHf7p5eVfNc6fYO6j5LfnRsUvZIuMijcsUkzkH4HSHuFpmuZ4KETybi9
5ZhQPMf3rklOGxpl5tRI
=JAop
-----END PGP SIGNATURE-----

--d9ADC0YsG2v16Js0--
