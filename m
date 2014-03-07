Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaCGKPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 05:15:13 -0500
Received: from top.free-electrons.com ([176.31.233.9]:37551 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752268AbaCGKPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:15:08 -0500
Date: Fri, 7 Mar 2014 11:13:48 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Subject: Re: [PATCH v3 2/5] i2c: mv64xxx: Add support for the Allwinner A31
 I2C driver
Message-ID: <20140307101348.GO607@lukather>
References: <1393950521-4173-1-git-send-email-maxime.ripard@free-electrons.com>
 <1393950521-4173-3-git-send-email-maxime.ripard@free-electrons.com>
 <20140305163430.GC9228@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBPpwzKX54beUJMp"
Content-Disposition: inline
In-Reply-To: <20140305163430.GC9228@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBPpwzKX54beUJMp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wolfram,

On Wed, Mar 05, 2014 at 05:34:30PM +0100, Wolfram Sang wrote:
> On Tue, Mar 04, 2014 at 05:28:38PM +0100, Maxime Ripard wrote:
> > The Allwinner A31 I2C controller is almost identical to the one used in=
 the
> > other Allwinner SoCs, except for the fact that it needs to clear the in=
terrupt
> > by setting the INT_FLAGS bit in the control register, instead of cleari=
ng it.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > Reviewed-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> > Tested-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>=20
> Applied to for-next, thanks!
>=20
> Still...
>=20
> > +	if (of_device_is_compatible(np, "allwinner,sun6i-a31-i2c"))
> > +		drv_data->irq_clear_inverted =3D true;
>=20
> ... next time an errata is needed, I think it makes sense to refactor all
> these checks into one struct which can be used as match->data directly.

Yep, it makes sense. Thanks!

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--gBPpwzKX54beUJMp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTGZvcAAoJEBx+YmzsjxAg2K4QALNEOnLIurQOKVJ+HBIhem9Z
JwbhrAj2OYRAPc9ywqUQNN1W7d+6Vz2nuD6sZ3D9xOqsWTzHNlGz0CSNxY0iRNL0
3LNbVkgb8rKlg7y/huIuuM9CG81LWhvXwhHBh3nmxi5gpgUPmV+eEF0DZwhOv6nd
3V93g2NciTleqcZ50fDAeufCmJTlhMpahxUjY0sNzh1xDPq5xnsbANu2FdfmbHrU
dS2NGY5kRTOgD4xjno+zvbPo9AG5v1n9Np2Gj9wOC+rMT56vmKufEgKqyy0BrTHa
273k9nHu9/KqbHhuQdeOu/imROXSW61gmEp5HT8uHzqWh6O7lA78ve8r59qyljHt
3p+Xh47ybVD3SrVOpXoZdn6DX3+HYQ8Gb5r1oyuf89gXwrm2QRx/rfmaw5vaBz5U
BL0DL0ew54zdXrX5A7izyB9erxb0zJUAkxdTl3VyFkkqX0nBuMiwIexEEnJKcoqZ
slhOsSVt+n6Pm+AGCzRyGzWnnmftqm1ipPVr51EV6T7X/SEpLSzS+mKq22JcwX6A
RZqO5mxb/YAqpgqDos6zv7UJa3npHZhly9YsFaoA5A8z4elK+ItT4heUcoPAzFiw
ypZeRRAZTzH6xUuVwzJe5sYoYGB++4WVb46/BXveXyscS5LGtjU7R2QiJ85c6z34
U5/UAOzQwtr850JNclz7
=wmcm
-----END PGP SIGNATURE-----

--gBPpwzKX54beUJMp--
