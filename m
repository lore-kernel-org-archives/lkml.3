Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab3GYJaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 05:30:35 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36074 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab3GYJaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 05:30:17 -0400
Date: Thu, 25 Jul 2013 10:29:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Tomasz Figa <t.figa@samsung.com>, Greg KH <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, kyungmin.park@samsung.com,
        balbi@ti.com, jg1.han@samsung.com, s.nawrocki@samsung.com,
        kgene.kim@samsung.com, grant.likely@linaro.org, tony@atomide.com,
        swarren@nvidia.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, akpm@linux-foundation.org,
        balajitk@ti.com, george.cherian@ti.com, nsekhar@ti.com, olof@lixom.net,
        Stephen Warren <swarren@wwwdotorg.org>, b.zolnierkie@samsung.com,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <20130725092957.GV9858@sirena.org.uk>
References: <Pine.LNX.4.44L0.1307231708020.1304-100000@iolanthe.rowland.org>
 <5977067.8rykRgjgre@flatron>
 <201307242032.03597.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QD1r0wI5tTrL9hxl"
Content-Disposition: inline
In-Reply-To: <201307242032.03597.arnd@arndb.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QD1r0wI5tTrL9hxl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 24, 2013 at 08:32:03PM +0200, Arnd Bergmann wrote:

> Sorry for jumping in to the middle of the discussion, but why does a *new*
> framework even bother defining an interface for board files?

> Can't we just drop any interfaces for platform data passing in the phy
> framework and put the burden of adding those to anyone who actually needs
> them? All the platforms we are concerned with here (exynos and omap,
> plus new platforms) can be booted using DT anyway.

There's a bunch of non-DT architectures that are in active use (blackfin
for example) and I'd really hope that this is useful for some of them.

The pushback here was about the fact that the subsystem was doing odd
things with selecting device names which is odd in itself, I don't know
if that had bled over into the DT bindings but it sounded like it
might've done so.

--QD1r0wI5tTrL9hxl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8PARAAoJELSic+t+oim9h80P/1oXCil2BLGuGCRwLn6bJHhk
/07tzgZUwbrAEYfnu4JOwfHn4gTIqqK7mFxzM5FV5N3o8+YtPSy/iWs6p8hho2z8
8MPbMYN3mkR271aRq/B0m4OthaF32XNAkYO5khSYQprV4thtuhFqIOJd8l1/+4dL
I5LMkD1HvMLQBdLjsRdjwmNCLOfpBBLsng85n6UlOKtPSQy2In/d5xsJI8/Gh8OQ
rvCzyGjSiHetL9ZX5wz11+odJmVXah3ZaIOLn9xWJjS5EtD/Nr4iT19r2gYdkzOk
td6igrTO6k+5bdP/WIM6Fr4Fr6B7y7zWCA7MBma6kFoosp+dL2x9A+zWKQwLmHFR
lZLUgqiSy9vIiHSmCrpfwvbABtssVBi7fzIxcFKrhB3f6/ek2LTJ5jYgBg7yBTOe
1RNpwm6Bx3O9wJXWKrpobADL/ynPUtu9ttjYrCJw/sy18m8ZhDuycOOnRX1Ulhc0
g8LX/my6f8Mc2yNJiYdwNUMEL7iMynUqqH2Sy/5IbUN8GmWXNaBTFXczYAaKqFkt
p+CzV2fGcH+po1fwRclBP/0n9ywv5a6x8lHPYqVWkDOww8d4b694CaV6ZYTwDwIL
jor467WvL4OCk7OqfZ2f8RX3K2wp3DC5O24o695bf97hMGrpEU5S6Pm3p1XiDgvu
3LuNvC7nJdI900hwVANz
=1iQH
-----END PGP SIGNATURE-----

--QD1r0wI5tTrL9hxl--
