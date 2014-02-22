Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaBVXhF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 18:37:05 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49507 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbaBVXgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 18:36:40 -0500
Date: Sat, 22 Feb 2014 12:07:34 +0900
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140222030734.GP25940@sirena.org.uk>
References: <1392908503-23166-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ftQmbtOmUf2cr8rB"
Content-Disposition: inline
In-Reply-To: <1392908503-23166-1-git-send-email-geert@linux-m68k.org>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.4.12
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] Documentation/spi/spidev_test.c: Document -N/--no-cs and
 -R/--ready
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ftQmbtOmUf2cr8rB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 20, 2014 at 04:01:43PM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>=20
> commit b55f627feeb9d48fdbde3835e18afbc76712e49b ("spi: new spi->mode bits=
")
> added two new command line options without adding the respective help
> texts.

Applied, please use subject lines matching the style for the subsystem.

--ftQmbtOmUf2cr8rB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCBRzAAoJELSic+t+oim90nYP/0jNdzn2U/LMUdGWZBVVMsp7
XU/Yhu6Zv2PWXXkN98pn8m6RVwpeyk5a8rsKpeu23SoXWOXx9Mge3oUIfBWT0eOM
BqRXC/Loo0Bb+UkArw5YW3iSmjnqap2QV9aR0k/p9uY5aXUuZoE7WxK07kTEFByQ
8e+vv+UmkGwbIHs6AGQzdtIjgclgG96EtVe/OCBrRhUJup4/AcUWUzTaoTAvzaYD
i2kSic5gx1drXdOVxa7wTT3902LENh/yjyuS2LcrOKUo5bbOhiE+lPpPWdsEngHV
QABYPxIQ4OoMs+9kjApUmiYmMsaMGcoqH3tlV2r6uAAMCcj44LoKMLMzoDzpeVEk
luSHtoirpVOVTnXFF1/dK1XXvq+zLrpOrDTZSuqqNCUrnwY6hNzDABwgIenWXibP
RA6Gn9c4QW+Foux0oGo+Y4VJRkXeLwyF2BjpQYECxTcA5b+eb0msm+KNr6SeOSML
ZmUrs6xoTH9kc7w8n2KryO2UfR3jdWFP7dyTQThluGj3IKUUDzcDsCpPHFhvGJ1F
hp2BGR6ArZYJm5fNZKIqbWiQZJqofqkVkn9fsnva/WHwZNXej33NGnFQso/DZ6rx
zZGcypu+K67jcPx7AVW6XauDi99cTPLnqUEDDedZXZk/gSb8GW6jz/GfDknqUAhK
GyCecOPKGj2g5XfteVB+
=B3Jl
-----END PGP SIGNATURE-----

--ftQmbtOmUf2cr8rB--
