Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaBVXhv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 18:37:51 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49533 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbaBVXht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 18:37:49 -0500
Date: Sat, 22 Feb 2014 12:12:11 +0900
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        Magnus Damm <magnus.damm@gmail.com>, linux-spi@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140222031211.GU25940@sirena.org.uk>
References: <1392907389-21798-1-git-send-email-geert@linux-m68k.org>
 <1392907389-21798-6-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oGy11dVowAZA6eXT"
Content-Disposition: inline
In-Reply-To: <1392907389-21798-6-git-send-email-geert@linux-m68k.org>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.4.12
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 05/10] spi: sh-msiof: Use the core cs_gpio field, and
 make it optional
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oGy11dVowAZA6eXT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 20, 2014 at 03:43:04PM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>=20
> In current implementation, CS is controlled by GPIO, which is passed
> through spi->controller_data.  However, the MSIOF HW module has a function
> to output CS by itself, which is already enabled and actual switch will be
> done by pinmux.

Applied, thanks.

--oGy11dVowAZA6eXT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCBWIAAoJELSic+t+oim9Qm0P/j08p4jDi/VfBIhSdOGzcV2u
Vyz6QkEqy267uMsLkWIDLbJ9JyAE5Bk9OczVLmdXEJoDPtaHNXgxQJRwCjRJ5g+/
m6f28lbU3wRCNH0C8mg5sJyWxQ1dP29f41HfrLmZPeaZ+I+IBli89a3KVey5R0nZ
vksTGydZntYgAGETzif1ajCDf3EizYuV6LfuIxwsD8t/fVXV79jMbrdX5fO7+P+f
wl0tHQEaJcd7lzFNAmohJ0WCqjChuHuRexrngr3hBiS5H3L0ZZl7p1+V9mfowcDk
u8KzGshK/RyA2eVxhPy3C4onsyMogp0Cfs1/yqCdPsy2TAdBnt0f1wQULbDjSLLq
BWN9SRXigO+bmRn5bxvWA7xgACZLSqBwjqmu9P2uM0/RLpAhGRjobRqe0E1tBly9
EenfATCA1oKGKy5kV0goWZucQ+qPOk129hMup0JWquzswpbL+UmBFGNhXUMWxvEG
XBIGWXEiVKC0juilrm7p+gnWCYkBOgChS6GP2HFJFiWmIt2jHvlykw68S7aMhFfS
Hmgv8FHwtacBDj+/sHE+lJM8S9PDeM3ZQz+AY/GyfJhqcG3d4ePgWT9bz89ZiVN+
1gTkfhufFC+EH121ZdMiNAG06BJUorF73QwdfWxgBdxo11fEPrKMZiiVhbIPjpAl
bvFaamQXVAcGCz8wRXU0
=05VQ
-----END PGP SIGNATURE-----

--oGy11dVowAZA6eXT--
