Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbaAUVBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:01:23 -0500
Received: from ozlabs.org ([203.10.76.45]:48798 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbaAUVBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:01:17 -0500
Date: Wed, 22 Jan 2014 08:01:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <poeschel@lemonage.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [GIT PULL] GPIO bulk changes for v3.14
Message-Id: <20140122080104.3228a7ded7e8174a635d5a94@canb.auug.org.au>
In-Reply-To: <CA+55aFzpF87hNgpFDsqLXYyiuTADe1xB2KUhOVd=atYASOLNFw@mail.gmail.com>
References: <CACRpkdY8Dk=i1-=rKU6gTM+3YHQ286r1u4z2WhLDQtcqLpyM2Q@mail.gmail.com>
	<CA+55aFzpF87hNgpFDsqLXYyiuTADe1xB2KUhOVd=atYASOLNFw@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__22_Jan_2014_08_01_04_+1100_thB0z6QIZu4BNMfv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__22_Jan_2014_08_01_04_+1100_thB0z6QIZu4BNMfv
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 21 Jan 2014 10:11:39 -0800 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> On Tue, Jan 21, 2014 at 12:36 AM, Linus Walleij
> <linus.walleij@linaro.org> wrote:
> >
> > here is the big GPIO pull request for the v3.14 series.
>=20
> Ugh. It does not compile for me. The problem seems to be that the
> gpio-mcp23s08.c driver only compiles in OF environments, but isn't
> properly restricted to them:
>=20
>   drivers/gpio/gpio-mcp23s08.c: In function =E2=80=98mcp23s08_irq_setup=
=E2=80=99:
>   drivers/gpio/gpio-mcp23s08.c:482:46: error: =E2=80=98struct gpio_chip=
=E2=80=99 has
> no member named =E2=80=98of_node=E2=80=99
>     mcp->irq_domain =3D irq_domain_add_linear(chip->of_node, chip->ngpio,
>=20
> and similar other errors.

Yep, reported when it entered linux-next.

> Introduced by commit 4e47f91bf741 ("gpio: mcp23s08: Add irq
> functionality for i2c chips") as far as I can tell.
>
> >  It's big this time but has been brewing in linux-next for
> > some time and it's all good stuff IMO
>=20
> The fact that it doesn't even compile makes me doubt your statement
> that it has been in linux-next. It doesn't even pass a basic
> allmodconfig build.

That particular commit was reverted in linux-next when it first turned up
on Monday and again yesterday.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__22_Jan_2014_08_01_04_+1100_thB0z6QIZu4BNMfv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS3uAbAAoJEMDTa8Ir7ZwVPqIP+gIyAzqE6jadUYDoYi8/mpj1
2JTNkpWs56OTvcDEz2fGiQ29E4ePMm0Q1y/G16C5vjfkp7+jMvgzAalj2R1EXo8I
iUOGgKm7/hO7zfk3PCZwfbmu8Mj9waVrnD8KVwOVJ9+j1vepExC+g8ESSPkF4YQ/
Oimx+f+mMPhCJs38yDGGR9zw49uA4Jkr1N36C5gPdpLA0J9K8RDEXK6ilKbHyDJG
11KKO8vHfn8HHz7Cv/wX1SRyRFwBHm6c9bflmthTQFAbxI5/iRIWLlQxRLoi0vcZ
99j3Vvp2O/YMr7b7uKTC0LYqWS6tBhC2SK0NDhwrkRGaSf713CX9duIvKR/2Qr5P
flq/AX6Rh34mwR+xJWSg8JJrOY1ZXMDO4vS5wFGTYg0jlSJ0OAq4m0NhppbA9KNZ
mY7V73jANO/Buz+QSsMWPI7eUiDQ8mzMRIMOjBmSk3VHg5hJ3kbtU2XYVH7cz1wR
gycdXX8GPxjjbEh9dY6j5vhPgZzp9z3u/l6dpy4tX26oQv0d1UMTnmV+ChyK44w6
ARXqtTvlsK1Cavd0qT3hw+7DIff91b77pg36+lGa/0RzidDHNxLmZF/Tp/B5qW+R
XVmplhTEWXRZTDMCFB0rocs8ZxLlPKM1bizGyo2T6FCZ8jzgY/YPyuyDiS4LR1vU
LTn9HEZUVsITDSvtvPgF
=Bw4+
-----END PGP SIGNATURE-----

--Signature=_Wed__22_Jan_2014_08_01_04_+1100_thB0z6QIZu4BNMfv--
