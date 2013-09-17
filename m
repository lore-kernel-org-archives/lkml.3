Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab3IQTIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 15:08:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60489 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223Ab3IQTIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 15:08:31 -0400
Date: Tue, 17 Sep 2013 14:07:32 -0500
From: Felipe Balbi <balbi@ti.com>
To: <linus.walleij@linaro.org>, <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: PCF857x and 16-bit GPIO expanders
Message-ID: <20130917190732.GD15645@radagast>
Reply-To: <balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="27KoNqt0fmcl1zj/"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--27KoNqt0fmcl1zj/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

has anyone ever successfully using gpio-pcf857x.c driver with 16-bit
gpio expanders ? We're having some issues here where toggling the last
gpio pin (gpio 15) on a PCF8575 device causes platform to hang and I
can't come up with any explanation of why would it hang...

Any hints ?

cheers

--=20
balbi

--27KoNqt0fmcl1zj/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSOKh0AAoJEIaOsuA1yqREFPQP+gKwfBNTzmxv3avpe6HwkPdP
WE2RIXnJ+S4iaM8yeCD5Y9AyfaPn9VUlq+WiHPgeGB2xbs4N2hKo3BjRemWqh8qr
HKBPeyQ7sg2zfawAkDsnp4hgIiAR6p5s34TtGN9kcWQ2TEuUnooDu6BQl+V81QIs
m047GVXPOAOShBk8sbDT2TZfMEtoB+6uzcRVKZPupX0VGerYb6xcTzCuPEcNk2vn
YZCG0Fh9S8SbtiOio3nx7V92d0NCvrN0Xe0HGhXUT6bkImsXsiaIUaJfdd3frXYU
GiEWKjefCyAYkrmml6btNTnnhukJhqNjWVUP5yUlAuXIYhCES5kLIm7auVo+E9yw
btI+dIQRdH+f1pNh+s1tLrw1wXVUm9VZvb9D6vM2rlPvpruVH3BMydOOWQetiVvw
LhhnNjFeX7UX6PhhAhhOAbZ8W4hAIoJcfQgowoOra/hRaXuH9dVphpGBVugZY12Z
uuiUIRd7XuWcMoElvecUaWnU7+ckf8psuYFHkPmxNCdlq+1I4pt00aBqI9A/N+pv
dc296mOTlpeC2IuwHVHn8+uNfEunFCPYo9Tm3IVVqqxWF5caw5nqJcTNCcBxPQNt
QEnKc9s3C4oXqa89QXby0nR9RClTG+BF71tx/CXCU96w9yBVocMTeIBhy5JQiCZ/
TbSQIHJXefP13erBinOP
=LRSi
-----END PGP SIGNATURE-----

--27KoNqt0fmcl1zj/--
