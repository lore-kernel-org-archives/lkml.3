Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab3ELIvK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 04:51:10 -0400
Received: from ring0.de ([91.143.88.219]:43699 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117Ab3ELIvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 04:51:07 -0400
X-Greylist: delayed 1197 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 May 2013 04:51:07 EDT
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
Date: Sun, 12 May 2013 10:31:01 +0200
From: Sebastian Reichel <sre@debian.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [000/118] 3.2.45-rc1 review
Message-ID: <20130512083058.GA17531@earth.universe>
Mail-Followup-To: Ben Hutchings <ben@decadent.org.uk>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <lsq.1368193179.973009354@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ben,

On Fri, May 10, 2013 at 02:39:39PM +0100, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.2.45 release.
> There are 118 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Mon May 13 12:00:00 UTC 2013.
> Anything received after that time might be too late.

Please consider adding the patch "ARM: OMAP: RX-51: change probe
order of touchscreen and panel SPI devices" [0] to this or the next
3.2-stable update. It has already been added to the 3.0 and 3.4
stable queue [1].

-- Sebastian

[0] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?=
id=3De65f131a14726e5f1b880a528271a52428e5b3a5
[1] http://git.kernel.org/cgit/linux/kernel/git/stable/stable-queue.git/tre=
e/queue-3.0/arm-omap-rx-51-change-probe-order-of-touchscreen-and-panel-spi-=
devices.patch

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRj1NCAAoJENju1/PIO/qaMMQP/0i5luu9/r2B3zgtcYFBbwFM
3ZQC2uD9soddpoyr2I38iOozYsyXLAnXpw8TYZxqKUeTo+f44+DD0VtYmP1SWbyl
3y9o04ngkUkdICE8L5frZjVyDytRUOxWgvpzxAK5ZL9BNPkrwczORzheQErLyllk
2O/V/ablaLGXDhUn+n7Xo3Ly4Cf5WQfTnvp59o6jSvNhl9dxQ8IeQD35ON3J1TO4
G/ydeg61X84R1iU+2VeuNtq5ke2Q3BZ28EwPREK+2QWLQzPY1jf/4ee1NRlVvvA8
q3DMfkt57pjb0l/MLI1kEBVaqq8m6g4VqYtHuaEqSZNaY4ml+dhWYFGLOa2Mytue
BXnb+Am5qc6WqzytIGXMDk31NvAxnccLlrtpGjkVG00Pa0NTQMercvrRQf2k7s1G
FaN2ihH4UChfdlkaW0MajCXh4eXJfHmmG7t0IOjxAL498feysISIxpTqLfT9IpmZ
xzIHd0HT8iBfR0k+sY15/e56RX89jaiVTJT5ocmaezzOOzz9y1gknjlv0pEjQAk6
aMJjwfR8BX+umACiC9pCUcFDRWAvTByk1DeTNYuxIX+pBwCnoqbLvA8jZd39A5ZE
XdMMyz+CSU4oLs4OqJBCuo0rVWXMwndg+SPR/IzQxnH0zjMLXWymirKSRd9slyFn
KpwsgIhdGI/G7LGFZCAO
=FmfO
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
