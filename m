Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbaGQLCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:02:47 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:46538 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbaGQLCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:02:44 -0400
Date: Thu, 17 Jul 2014 12:55:50 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        Richard Weinberger <richard@nod.at>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, teg@jklm.no,
        Lennox Wu <lennox.wu@gmail.com>, Marek Vasut <marex@denx.de>,
        Liqin Chen <liqin.linux@gmail.com>, msalter@redhat.com,
        linux-pwm@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-watchdog@vger.kernel.org, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        knaack.h@gmx.de, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Mischa.Jonker@synopsys.com, jic23@kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] drivers: Let several drivers depends on HAS_IOMEM for
 'devm_ioremap_resource'
Message-ID: <20140717105549.GH17877@ulmo>
References: <201407130545.23004.marex@denx.de>
 <6823014.2plXDE9VA9@wuerfel>
 <20140717095657.GC17877@ulmo>
 <6350114.L77bTv76Ul@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrvsYIebpInmECXG"
Content-Disposition: inline
In-Reply-To: <6350114.L77bTv76Ul@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrvsYIebpInmECXG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 17, 2014 at 12:33:32PM +0200, Arnd Bergmann wrote:
> On Thursday 17 July 2014 11:56:58 Thierry Reding wrote:
> > On Thu, Jul 17, 2014 at 11:20:36AM +0200, Arnd Bergmann wrote:
> > [...]
> > >                       score should set HAS_IOMEM and doesn't
> > > even have public compilers
> >=20
> > This begs an interesting question. Should it be made a requirement to
> > have publicly available compilers for new architectures so that they can
> > at least be compile-tested? Preferably this would of course be in source
> > form so that there aren't any dependencies on the distribution.
>=20
> The question has come up a few times. I wouldn't mandate that the port
> has an upstream gcc (you've got to start mainlining one of them first
> after all), but having compilers available for download should probably be
> required. It's hard to ask for a particular quality of that gcc port
> though, or to expect it to stay available online.
>=20
> Where did you find the gcc port for score?

It's upstream, though marked obsolete and to be removed in the next
release... =3D)

Thierry

--lrvsYIebpInmECXG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTx6u1AAoJEN0jrNd/PrOhEuwQALeTCrfkgfo5Tb0gskGOiJ2A
l5c9TdliuCOUNYpwW+4phztgN81QDg941PPecfB96ARNKGewq4tDbSt1QQ28/d1S
XC+bPi89pXVSzh+tt2VM9sWMXpkpfrY4Cv7F5HdlpsbAvXhU2q/Q89oJBDhOLLJ+
F7ledfllgqfF50oamHY4J+xJv4lDjKfve9U8MomM/r91IQ7rZAI2Zq//LwkFD3WF
6L8/FX1NbTOmGv85v19YDY3+PvDFbPpt4wG128p038hTIZ/k8RICic8N8smgh7r+
Ik/Bt3Ew4aXIgAtNXAyKzG9GIPuofKd6WkhaIB4vvrUoXan9kLqCY5CKrLuksG/p
Fj0B+4VGHoOevMwDVyqgn33pQPErm6rlTRdp0ddmI0SQph4GcKg0IBUIqD0XS0ma
WcUVlA6S3GLmXl7LrfCXl0xRvn/pa03v+Gzj7VcjmYNAxyDbtPrbzoSR8Lp0JC5j
t8Q03pOtQhXgI363OYll/S8j32qcreLtghi/xpi6MhAXSZJeonp0CxNi4Z/lWED+
aDr8rHEbve2orQ0ouyInSlV9mabI/03MdePZrHy/cJ94GPgpieHy1BLBc1N4JsEc
IPZWwWKj5LS3zG4wrutDweoN1Twh7nrQaPzlvJRSrtaGCEyKdHuHZMuhUjMXCcWH
ArZr57GeXOop6SEf41I5
=UHHF
-----END PGP SIGNATURE-----

--lrvsYIebpInmECXG--
