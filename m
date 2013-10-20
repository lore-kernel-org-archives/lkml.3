Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab3JTSBQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 14:01:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37553 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391Ab3JTSBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 14:01:13 -0400
Message-ID: <1382272977.2794.99.camel@deadeye.wl.decadent.org.uk>
Subject: Re: zram commit to backport in 3.2 serie also
From: Ben Hutchings <ben@decadent.org.uk>
To: Fabio Pedretti <fabio.ped@libero.it>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <571525005.2373231379338686866.JavaMail.actor@webmail22>
References: <571525005.2373231379338686866.JavaMail.actor@webmail22>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-W0PjUatelz+ge2Q2qZZo"
Date: Sun, 20 Oct 2013 13:42:57 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.8.5-2 
X-SA-Exim-Connect-IP: 82.132.212.222
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-W0PjUatelz+ge2Q2qZZo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-09-16 at 15:38 +0200, Fabio Pedretti wrote:
> Hi, this patch should be applied in 3.2 as well:
> https://lkml.org/lkml/2013/8/13/270
>=20
> It will fix a regression introduced in the 3.2.49 (same commit in 3.10.6 =
and=20
> fix applied in 3.10.7).

This doesn't seem to be easily backportable, so I'm reverting the
previous change.

Ben.

--=20
Ben Hutchings
Tomorrow will be cancelled due to lack of interest.

--=-W0PjUatelz+ge2Q2qZZo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUmPP0ee/yOyVhhEJAQqStxAAjwl1olLCgEsxMXVwMxX+mzZ0SyGIylYP
Kpm9Ro/u5OxLk/wO9FKTAuqpdNJXFIZWciev4ZbYwN6TaM0ySqzZuMMAKnyeCNKE
F6MMF2G2P9OCRxHCc548dWcIzkrKQiFiCKUFBmTLo6imR9oji/MaOvZ9nvhA5OnV
5osUsXQbIMg/J2U4W8iPdbzHJTFTNnoL76bb72YilAnnXgWJrqkKifmWLCbr2Xqm
aNmGQuSjAqWd4DW4TQvSRuggeV5uXIoZQuyB+7Tq92KM3jF+bOw8J2O+kh64Cnth
psjJ+yzAbhTVfRhOrlQ9mxKQwpYLLdWJZuw16qUq//gEWmXY3Ln3wSSNfDbQRv5s
3Ty/quWpfPAHvkH4GJteL3QZJ77mZxOYT/I7jq/bokrD4N0JVUkg2kH7cCnChMcD
2Cfh9+n1aUzFk5F1NatqcVzs9E0eowGumHW13bnAOXWZ8fC/6fT56Mo6Bg+b5ZIu
4Q1MGs2PQYGLBACQgXT6WEyjetHa3MQDHgk/qEkQZgzzdDK3yjp1F4lR8Uwvehlh
v5GF+uRBgTY04xJlccMa79AWWCbgIRgf08SoJ1teBsLTOJJb0Wvjtpt/6NEF16Sx
tEvqVVN3maR30myh5aT7R2fUSHgKs9QYkzdXM8imPsC4wIA08vMzu7g1wle8ncce
pruip31LmX4=
=jB6S
-----END PGP SIGNATURE-----

--=-W0PjUatelz+ge2Q2qZZo--
