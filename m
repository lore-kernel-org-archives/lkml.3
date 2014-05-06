Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933822AbaEFDBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:01:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55585 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933739AbaEFDBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:01:21 -0400
Date: Mon, 5 May 2014 22:00:39 -0500
From: Felipe Balbi <balbi@ti.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 05/20] usb: host: xhci-plat: Add clocks support
Message-ID: <20140506030039.GA15336@saruman.home>
Reply-To: <balbi@ti.com>
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
 <1399335255-589-6-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <1399335255-589-6-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 06, 2014 at 02:14:00AM +0200, Gregory CLEMENT wrote:
> @@ -118,7 +158,7 @@ static int xhci_plat_probe(struct platform_device *pd=
ev)
> =20
>  	hcd =3D usb_create_hcd(driver, &pdev->dev, dev_name(&pdev->dev));
>  	if (!hcd)
> -		return -ENOMEM;
> +		ret =3D -ENOMEM;

regression

--=20
balbi

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTaFBXAAoJEIaOsuA1yqRE9dUQAK1ujVgf0xDp21zyWDxh3FpQ
PISVIEvfLYiXp4Fxcr5mpslzuwRlQmudBOvXSPnmxDhzCD1f+zxT6fc32uoBZYKL
7RUDuyAdsSAmL+Hfm/EjMwvgFxKarU0+CzKgoj7xw9853UTgJghbrpBIK+6Sb+sC
liVY/sNVjg6KLY28kwKd1WLxuCxhaVk+gncRa7hzKo5vUab4r9lk5kYqgLFiNN8O
Omn3dNwmzHz55BXcMSoKi3XVoAZ2dud+MbYqpW8uPLTWYlThdURRk55tWtzZZQzj
+W2fWees/4D8PR6xTymUBpetAH4BvofkQ0XuF5E5XvGTmJxBXPzqvc2J25cDzQCH
sDS3OOe5HNowKisvT3GtKI8JB9AnfU/PE8vABl22Af7aSGefgS8+bk/0HhPZMQn7
YilgqJ3Tx+lf9Z9dzWopYZwLdguFWLsqJyAoYDZhLHuC7fXi6Gb266PhuYFSzFfJ
SqZv8fYY4ukkNMZxsayAdIK3EoV4ftV5UslmN0hBY3qW0BIAdOeSJT431Aix7kSp
TlSQBYiMFzdTj1gX39I2XGFt8NueKHfULRQmD/XxkxTvG2A5k0DMFK7HspxEOcDp
oEnZ9XuObgdi1Fp1PBwC5wVS9YF0WGKcCuNfKO14PdoN5W88icJUFZqbIHHQZUxh
FpReMh+lZtMWbh2ZLuiN
=wKS4
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
