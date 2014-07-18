Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965936AbaGRRLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:11:05 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43851 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009AbaGRRLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:11:03 -0400
Date: Fri, 18 Jul 2014 18:10:35 +0100
From: Mark Brown <broonie@kernel.org>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Benoit Cousson <bcousson@baylibre.com>,
        Shubhrajyoti D <shubhrajyoti@ti.com>, Charulatha V <charu@ti.com>
Message-ID: <20140718171035.GQ17528@sirena.org.uk>
References: <1405683053-14104-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ensexbfp9Ul6anXl"
Content-Disposition: inline
In-Reply-To: <1405683053-14104-1-git-send-email-LW@KARO-electronics.de>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: omap2-mcspi: fix blatant abuse of the resource
 subsystem
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ensexbfp9Ul6anXl
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2014 at 01:30:53PM +0200, Lothar Wa=DFmann wrote:
> Aua. This really hurts. I wonder how this could ever be admitted to
> the Linux kernel...
> Further comments suppressed because the would most likely violate the
> CDA.
>=20
> If someone should not grasp what this patch does, they should consider
> what happens upon unloading/reloading the kernel module.
>=20
> Signed-off-by: Lothar Wa=DFmann <LW@KARO-electronics.de>

I'm not going to apply this with a commit message such as the above.
Quite aside from the tone the fact that it doesn't describe the issue
is not helpful for review, one of the things done in review is to try to
check that the change has the intended effect.

--ensexbfp9Ul6anXl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTyVUIAAoJELSic+t+oim9fmUP/1SyGlhn0Me9y8BBLgnUTImu
kWdKdLhh91px+7Zwz/P64DrnyEMj5Nqnay63LCjBRHK+pI3aBUu3ZMMzsiO8A77j
lmi04xEGdUIrfG/3qQ2wyacnBvlChDjplhTwRx2OBy37gF+4sD3fCa3BgUHpCejM
Vgyb+OGhtbhx2uwn5DOM3CDRd47WCOZ6kXD1qVhvVuoqVvo2EfdXDMqh/r8bG7gZ
p7Z7yjI7POEzi7Zb/OE1MiKQTWarwnpG9DcdKW3qmjAotaNjqdqur2oQIuaWCPkw
psaQqvRMZj3JjeuHYxCZ7a8maWLIv6H2Tl+PFB2BwdkF2F9xRXOYS/50ST6kyUHP
Nm2LuHp1atAUfAHRW8OZUYIpGQW7q+K2F+ZZ+021hfUa3IbzOC7n4ugCVlFmvWCx
LeiuXo70cjxnujvOwM9KO8x9D3TmVNg3mj9J9uZ68jYHBLmAtvgUJG07EGdA/nLL
chyS7b6CfeIKRgGSFMMfYx2EEIqso6kZG9U1sBnjgg9RxeaQ7ictGDwV/kIlkJ2n
0e8o8WTM+2EmNUnBiHv4Lt+10UNGxLaqP0mxsYMNk4+04pShln8U3t/IwmRlPSdw
TsFOxXzs2Vn3tb/+IO6PtN9s9D1BNDsiJ8G26kInutVx6mQmjPR240AVUd2dle3g
ArbUgKXm+rkHnN4UGSKZ
=fSdJ
-----END PGP SIGNATURE-----

--ensexbfp9Ul6anXl--
