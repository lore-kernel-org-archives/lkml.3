Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965370Ab3GSIgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 04:36:00 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:32906 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412Ab3GSIf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 04:35:56 -0400
Date: Fri, 19 Jul 2013 10:35:55 +0200
From: "'Maxime Ripard'" <maxime.ripard@free-electrons.com>
To: Mike Galbraith <bitbucket@online.de>
Cc: Jingoo Han <jg1.han@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Alexandre Belloni'" <alexandre.belloni@free-electrons.com>,
        hector.palacios@digi.com,
        "'Thomas Petazzoni'" <thomas@free-electrons.com>,
        plagnioj@jcrosoft.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 2/3] video: hx8357: Make IM pins optional
Message-ID: <20130719083555.GC5106@lukather>
References: <1373902022-20439-1-git-send-email-maxime.ripard@free-electrons.com>
 <1373902022-20439-3-git-send-email-maxime.ripard@free-electrons.com>
 <003501ce81be$4a945ed0$dfbd1c70$@samsung.com>
 <1373945380.7549.26.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vOmOzSkFvhd7u8Ms"
Content-Disposition: inline
In-Reply-To: <1373945380.7549.26.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vOmOzSkFvhd7u8Ms
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jingoo, Mike,

On Tue, Jul 16, 2013 at 05:29:40AM +0200, Mike Galbraith wrote:
> On Tue, 2013-07-16 at 09:49 +0900, Jingoo Han wrote:=20
> > On Tuesday, July 16, 2013 12:27 AM, Maxime Ripard wrote:
>=20
> > > +
> > > +			ret =3D devm_gpio_request_one(&spi->dev, lcd->im_pins[i],
> > > +						    GPIOF_OUT_INIT_LOW, "im_pins");
> >=20
> > This makes a checkpatch warning such as 'WARNING: line over 80 characte=
rs'.
> > How about the following?
> >=20
> > 			ret =3D devm_gpio_request_one(&spi->dev, lcd->im_pins[i],
> > 						GPIOF_OUT_INIT_LOW, "im_pins");
>=20
> IIRC, some maintainers gripe (davem?) when they see such alignment,
> preferring the original arg below arg alignment vs strict 80 column.

As far as I know, the coding guide styles are quite fuzzy about this:
  - The new line is not required to be aligned with the braces above
  - Yet, the emacs config given does indent like this.
  - 80 characters is said not to be a hard limit

I don't really know if there's a better solution here, except maybe:
ret =3D devm_gpio_request_one(&spi-dev, lcd->im_pins[i],
			    GPIOF_OUT_INIT_LOW,
			    "im_pins");

But it's not really a big deal, is it?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--vOmOzSkFvhd7u8Ms
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR6PpqAAoJEBx+YmzsjxAgf8EP/i2RJuYd+QHxsbrKqLpQ8+wL
worAFgbqVtU1s3oebNvdNkM0JSPBsOwauj1Npmr/UFW5mbt6S2zBjQi6c1v9AH2s
mftB0AdNQpZ93Lu6cnYYdCLEILuaJXy67hqrxOM5vDgabzx/kCgjJ/SkZG5eOtzL
e3/pNyuP08pDG8ksysSzCn3tkf6ptx/Z/4LI2pEvc2O0ub0OxydCE7tqbRLlAkQI
KejLPAeb+wUFj30FEJiks+3By3I3kli52gwU1KYRecAAOA0p+MMGT2+4iD7L0SnS
Vu9gBAljdioOMXGvG80q+t4NL7H1ZchcN0IcK3u4dGCiL8287yeOpOsmoSm1zElZ
BQSYAcOvOWn72VN7Q+wysiMCjklLX5iuYpwUNm/EJrBDRSKB0Bc2k2dXtC2Ama90
ESZJd2XOoG6IkC71pZsWXdXMKMKv5PIfThXDU9W1VNhrlfuHMbpx6qFM2jMS6Y0a
XcCzgY7izwAyf0ycLGtDiBt6sw2gNcLDPH6+8RdOlEL2Aa9MK8OJVSpGwCOurPxn
SHCtLlqVvcWiPXKMfqf8zDLqGzNrQj2kW0W2VSpIb+yxfofoDFUvHKwa373Y49rI
Y0rsd9mplo4FE6AI45bU920qUlYfkFKEScqBNkMfam6tKk0SFyrs+mjwjSBxoEW1
/jAkpxF/AK9HTB4cSvAY
=RVce
-----END PGP SIGNATURE-----

--vOmOzSkFvhd7u8Ms--
