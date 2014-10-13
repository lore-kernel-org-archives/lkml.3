Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbaJMMaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 08:30:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50305 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752979AbaJMMaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 08:30:07 -0400
Date: Mon, 13 Oct 2014 13:00:43 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] power/reset: at91-poweroff: Fix error handling and other
 compiler warnings
Message-ID: <20141013110043.GY19438@lukather>
References: <1412988077-14751-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6749iDyxihQ87e9v"
Content-Disposition: inline
In-Reply-To: <1412988077-14751-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6749iDyxihQ87e9v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 10, 2014 at 05:41:17PM -0700, Guenter Roeck wrote:
> at91_poweroff_get_wakeup_mode can return a negative error code and should
> therefore not return an enum type. Similar, its result should not be
> assigned to an enum type. Otherwise, the returned value is never negative,
> resulting in a compiler warning and a missed error condition, which in tu=
rn
> results in writing bad values into a chip register.
>=20
> Also fix other compiler warnings which can be easily avoided.
>=20
> drivers/power/reset/at91-poweroff.c:74:24:
> 	warning: type qualifiers ignored on function return type
> drivers/power/reset/at91-poweroff.c:74:24:
> 	warning: no previous prototype for 'at91_poweroff_get_wakeup_mode'
> drivers/power/reset/at91-poweroff.c:83:16:
> 	warning: comparison between signed and unsigned integer expressions
> drivers/power/reset/at91-poweroff.c:97:2:
> 	warning: comparison of unsigned expression < 0 is always false
>=20
> Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--6749iDyxihQ87e9v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUO7DbAAoJEBx+YmzsjxAgTLQP/17SGGVwATXs+XQYvnmiQuYJ
hFkidwe00qYeRDHr1wZwCXlCtjF8PefMrhs/Yd9fP2JQhidgcQV8K6K/JshEk0Yd
k9w+WM4i1FTsFsrS+ganoBYDUhBdnB1hdo/BluhWQS8L/62DDyw520c63/+nG5RC
m4tNuQi0rr5GV7RuRd3O5AfCqI3/M24/NVecEcVko97luKT92QlPACZxX+emHU9H
gQnBFXgT89AvaWGiQwNtoBFzc++P8UtuUvGwjDwvZvyND2NAxjr7tNZ7didaRWJO
7NX45nCSGUJEA/+7pB5Nz1lBUqAp1wKAGCQ6e9dpyIkKIqn7L3rHIatKUiJCZKDa
nxX2EAPN6JBOVGt0yyIal/hQh6k3qEITCkQ1KC/y4wGiV4TGHhSV1Wh+gxeBL3fJ
GkmubNplmjZHgiT4onUOWcTOo/4XW50ajD4yZv3eVvZ8Vws3NDzR87Lc4M5MCxnZ
Vj1ArghmQjQ5SJEUDXHWatHuSl7x+p/Sgw1uZ7V+EiulydF6YZXbSih6dGkGJ1D/
PRAlXLPDVqCKIKaoXjM7273cOHkWwoPOvVvBtG9D2hvtdJ7OhmPUKdS3PqsR2gKm
Ux/LVI45IlvsB5fJF+lL1rPsc9GoigCXWdHcW2S3Xds6dZPVpkLVgpSOllFxp2Ro
0XD2f/jJIb9QX2nXuGcO
=Mji5
-----END PGP SIGNATURE-----

--6749iDyxihQ87e9v--
