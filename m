Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbaEFUFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:05:43 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54600 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752671AbaEFUFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:05:41 -0400
Date: Tue, 6 May 2014 13:53:51 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Arnd Bergmann <arnd@arndb.de>, wim@iguana.be, dbaryshkov@gmail.com,
        dwmw2@infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 0/6] ARM: sunxi: Machine code cleanup
Message-ID: <20140506185351.GK9464@lukather>
References: <1399259284-6282-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140505155113.GB25199@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mPOSj6iWmtyhwOMz"
Content-Disposition: inline
In-Reply-To: <20140505155113.GB25199@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mPOSj6iWmtyhwOMz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 05, 2014 at 08:51:13AM -0700, Guenter Roeck wrote:
> On Sun, May 04, 2014 at 10:07:58PM -0500, Maxime Ripard wrote:
> > Hi,
> >=20
> > This serie moves the restart code out of the mach-sunxi directory to
> > either the watchdog driver or to a new driver in drivers/power/reset.
> >=20
> > Since the reset code was pretty much all the code left in the
> > mach-sunxi directory for all the SoCs but the A31, the only thing left
> > into mach-sunxi are empty machine definition.
> >=20
> Hi Maxime,
>=20
> what changed in this version of the series compared to the previous
> version ? Is it just the different directory for the reset driver ?

Gosh, I was really too tired to send patches.

I'll resend.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--mPOSj6iWmtyhwOMz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTaS++AAoJEBx+YmzsjxAghlAQAKBuVmkSVvVwbNFyURuVWVaB
1SJUCdKLdJYRJalXQI7fOgbq55RaVmflt7nfSM4hh0Wgk52qBpOHXMZfh3JwFYHQ
2CV1uaR7NV5CBgXmv2MrDdiCF15fJn/uuNKzDS9WuXLtebXWfdawl5YGsNXkrM9+
bLmUy7Np5XRVUz8LO4Dyt3TZHpCLUVtBdBDxqmrX4zNhrlL4MihpuZItniNvOiyX
3UT/bnMEpadtUjL7pDXraYdlJFuOlON7OCNAyhVUPx86ti8qFGKzalyKPn5WQZte
qVNtnKkaeReu84otInxbgmFwMt8YebVbdso3i/sORoV0iRGGJOaIKWuKixF5WJCy
1iJl8CsZoBy8RX8wMbyTCRcjPAS04LUO2oPTVLLTEG7Z+3pMd+gcTQVDX7qxa9ku
1Yuq9RPgsPNN9+QobC+lWcy/T1n5YlzBXaV2OU/Gb0Bw6UqXGVidiyn8RCtD5FgL
jQ7MpRUSPbdXJSYFSRBVGSE2gRAbDmL5wbEgNM/LtYMSXP8WR309+PgRXhtYSLec
xSgtE4rIiMfT7CDmI1p/xOBEHHJ4v3E4bfxinnInLJJgCPRTb+qtmS+BMIuIo+ba
DJSI7E1Fv4huM3HBuvh1tp8yRpYpecmuwcBoU+E+w7JikXS/OejtSTbNPrSwyVp8
I4Vnb/b6zRQFZUw08+y7
=+qxP
-----END PGP SIGNATURE-----

--mPOSj6iWmtyhwOMz--
