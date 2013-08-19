Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab3HSLZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:25:59 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54876 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751235Ab3HSLZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:25:58 -0400
Date: Mon, 19 Aug 2013 13:23:34 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3 4/9] pinctrl: sunxi: Add Allwinner A20 pins set
Message-ID: <20130819112334.GK3173@lukather>
References: <1375610330-18185-1-git-send-email-maxime.ripard@free-electrons.com>
 <1375610330-18185-5-git-send-email-maxime.ripard@free-electrons.com>
 <20130812083319.GN2911@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5dNcufZ4prhark0F"
Content-Disposition: inline
In-Reply-To: <20130812083319.GN2911@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5dNcufZ4prhark0F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 12, 2013 at 10:33:19AM +0200, Maxime Ripard wrote:
> Hi Linus,
>=20
> On Sun, Aug 04, 2013 at 11:58:45AM +0200, Maxime Ripard wrote:
> > The Allwinner A20 is pin-compatible with the older A10, so the two pin
> > set are quite similar. However, since the A20 has new features, we can't
> > just use the A10 pin set as is, and we need to define our own for the
> > A20.
>=20
> I'd like this to get merged in 3.12, do you have any comments on this
> patch?
>=20
> It's mostly just another round of pin sets additions for yet another
> SoC, like we already had a few times.
>=20
> Hopefully, it will be the end of it, unless if Allwinner release a new
> SoC.
>=20
> The only missing feature now is the gpio irq support for the A31 that
> had a slightly different interrupts handling. Anyway, this support will
> likely be in 3.13.

Ping again :)

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--5dNcufZ4prhark0F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSEgA2AAoJEBx+YmzsjxAg1u0QALDXWUEavhpIv3A6JZY5N23W
PZPx2xKcGCOoybJ8MXBLd8At/j2M9waUXg1IiZKeZxqvVyosVHmROBnH/nDhsVyC
yP3jcf1sOqnehsgR1q0Cc4zm1grF+BS7Lb/c1RTOo4U46yvRLEiMFe8+81SD4Jhb
JXeoX9TGcA1/ZmOhqT2R/64gI4bXQVuvs9QPywYDwOwhhmj8IJGyBFhvx+wD8yMU
8OYfUUdoUm2nskAHrF4EWfwhF4mOMxDBAWubNtf3n74ZdCYte+M5cMBZIAohnA1R
2QuhS235q/c8u1tys8EA+fLNKXBXmiZqDb8i3+PVGsviupVk0PUhE8fgp1pM11eL
aR7Mmmox968eUBvum85S1iyct4LOAhq2vzCnvGEFvkhKlfXMm/pGDqubIeP2M5za
Hc6kC92LqOQWWrZm12Q4MRBbOYnqeEcwaIu9pWJFZZC/zjW29HSCIRY1YU+tx0+6
eRCRh6z4IkLX8Tuzs0rVXbGE5t6MoFTvws7wjG0vswRsfeEbPfeFs9g5gXqHub/+
SAqKhLguWkGGUmZXbneY2G45o0N9/KkIgDNDYu5/tsgOA1NWR/XvwfKMBBWSQkgg
gEtbN7ydiYjApGh4Zt5ruENCFM3Xm36liej8nSTiT2gHcFTYiYVdxthg52QDua+x
FR3hRbjRtrJTHBMAX1lN
=Lrl0
-----END PGP SIGNATURE-----

--5dNcufZ4prhark0F--
