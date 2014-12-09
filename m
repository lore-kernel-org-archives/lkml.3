Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaLIV1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:27:22 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53590 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbaLIV1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:27:20 -0500
Date: Tue, 9 Dec 2014 21:27:08 +0000
From: Mark Brown <broonie@kernel.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: anthony.olech.opensource@diasemi.com, support.opensource@diasemi.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
Message-ID: <20141209212708.GL11764@sirena.org.uk>
References: <CAOMZO5DBL1G7H3RE43edi5ObGOzvF_2Oo+LHqiG7EFfoWjXxaA@mail.gmail.com>
 <CAOMZO5B0WcR-=__QzCzD86oocuj--uhq+QYj3o1WU05JO-Qyfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNo5QvG9KeB9cWDw"
Content-Disposition: inline
In-Reply-To: <CAOMZO5B0WcR-=__QzCzD86oocuj--uhq+QYj3o1WU05JO-Qyfw@mail.gmail.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: da9052-regulator fails to probe in linux-next
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNo5QvG9KeB9cWDw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 09, 2014 at 07:17:14PM -0200, Fabio Estevam wrote:

> Seem like this issue is not specific to the da9052 regulator.

> On a imx6q-wandboard we can see the internal anatop regulators being
> probed on linux-next 20141031:
> http://arm-soc.lixom.net/bootlogs/next/next-20141031/wandboard-arm-imx_v6=
_v7_defconfig.html
>=20
> [    0.072014] vdd1p1: 800 <--> 1375 mV at 1100 mV
> [    0.073027] vdd3p0: 2800 <--> 3150 mV at 3000 mV
> [    0.073933] vdd2p5: 2000 <--> 2750 mV at 2400 mV
> [    0.074888] vddarm: 725 <--> 1450 mV at 1150 mV
> [    0.075935] vddpu: 725 <--> 1450 mV at 1150 mV
> [    0.076897] vddsoc: 725 <--> 1450 mV at 1200 mV

> ,but since next-20141103 they do not probe anymore:
> http://arm-soc.lixom.net/bootlogs/next/next-20141103/wandboard-arm-imx_v6=
_v7_defconfig.html

That last log looks *extremely* unhappy in general, I can't actually see
any references to attempts to do regulator things and there's lots of
backtraces in there.  AFAICT those regulators are anatop regulators and
I can't find references to that driver or anything called "vdd".

--cNo5QvG9KeB9cWDw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUh2ksAAoJECTWi3JdVIfQwZUH/2RswzfqJB6im/Q2XxXBUMZf
lAkcC8yos5dmol0WsEN9L/+IJWrGWJZsGWEEX9WwcIEuHIAutUgOlHsHurB7UeLo
3SYVW5WrY/OhLazCtVIMZfT2vZnTx05KyF7+iHHzT+HjtyB3aWzCt5sTjZGiQOt8
45y6mlQHQNNDTRDrAc8RG+OeAqlwnW07aGy8nG/vWhjPVhSMazvtAcEXW/eY5USN
1oq+NhwQKqM9kFFBQsPrN+LvqGt+NJ8/PGx/WJE48c4+j8QUqwC8pkT85Nqd9IaA
VkDVG6G/qfYrIQWgMH55SsA/8ibtaXHGHEK9DOVwH/MMyoQUw2JQFrMec6T2hE8=
=G7cV
-----END PGP SIGNATURE-----

--cNo5QvG9KeB9cWDw--
