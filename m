Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbaJMLGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 07:06:31 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50303 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbaJMLGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 07:06:30 -0400
Date: Mon, 13 Oct 2014 13:06:08 +0200
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20141013110608.GS27755@sirena.org.uk>
References: <1412883807-20825-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3lEnBJ3eT4fJ0mBo"
Content-Disposition: inline
In-Reply-To: <1412883807-20825-1-git-send-email-linux@roeck-us.net>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: Include err.h from consumer.h to fix build
 failure
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3lEnBJ3eT4fJ0mBo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 09, 2014 at 12:43:27PM -0700, Guenter Roeck wrote:
> sh:sh2007_defconfig fails to build with the following error:
>=20
> In file included from include/linux/regulator/machine.h:18:0,
>                  from arch/sh/boards/board-sh2007.c:10:

Applied, thanks.

--3lEnBJ3eT4fJ0mBo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUO7IfAAoJECTWi3JdVIfQa1IH+weLiUZvvBQNjsNvNdgj9oBr
MeS3P88vNUVuuMCxnM8mrO5xXMKDOnrgVok2UutQTZ0sqJ3nFnUKNIvFQa6/Tiwr
LCm5t+tzw6AvOSpcpBN6GdmnKPI2Q5Gix1HdXSTaaQwN+2365KP4d6P+BfAluRVL
LlGI8dwE96Me4It2WbkOgfzIqGTj+IAqZuNq6iClvRQwn02wxnmr1ToxVBdG2WVc
OemXB/S2fSlw/7kbOjVETMc4ARXDAKTEFO0V6hk0HAMyN363tNxcorvo3FFb8w2c
90rZ17NVLEhrDVmpDcZv1ld3KeGYFH20Kv1/Q9JzskbYhqR8ZCEHQuwBg6NOj8s=
=0wwv
-----END PGP SIGNATURE-----

--3lEnBJ3eT4fJ0mBo--
