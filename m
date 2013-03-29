Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab3C2SaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 14:30:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43445 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753713Ab3C2SaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 14:30:04 -0400
Date: Fri, 29 Mar 2013 18:30:01 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robherring2@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Axel Lin <axel.lin@ingics.com>
Subject: Re: [PATCH] clocksource: Fix build in non-OF case
Message-ID: <20130329183001.GK18316@opensource.wolfsonmicro.com>
References: <1364473805-773-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <201303281308.22738.arnd@arndb.de>
 <20130328131044.GA18316@opensource.wolfsonmicro.com>
 <201303281447.51532.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pBVEohhI2cZ2uXfo"
Content-Disposition: inline
In-Reply-To: <201303281447.51532.arnd@arndb.de>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pBVEohhI2cZ2uXfo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 28, 2013 at 02:47:51PM +0000, Arnd Bergmann wrote:

> Since we recently introduced the IS_ENABLED() macro to test for preprocessor
> symbols, I think there is a general trend away from any #ifdefs in driver
> code.

I have to say I'm not seeing any evidence of this in the patches I'm
seeing, and I'm not sure what the connection with IS_ENABLED() is?  It's
a reasonable idea, just likely to surprise people given the amount of
boilerplate we've got for things like PM - I guess we'd need to make
sure those macros do references as well, they're the main users of
ifdefs.

--pBVEohhI2cZ2uXfo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRVd2iAAoJELSic+t+oim9weQP/11NCDjtnuYnFM9nh4wButqf
GZeVogw5/KccJ4zOrdxsdyycbPMR4Szi0yv3XSTDERv8wbt6srW0H1q/kAHCj3Vf
nF5aEIV3XY9A7+eUy1vDjOkxYDkgczvpyTK0M0Ckvx8iY5JWpFOZnWSJTh1nAGwh
kqOihBg7rqRGXtBBQ9SYjsfyBdyDQEzknds1CqKDR5AApAuQPErpZycmwP40jls9
LjblvmUEmuubg0GtNnssiNPmAUeulZHkNXNvA83qeaCKGz5V2PymNGQ7x++64AZT
aS2jWnRtHWzJNEchb6yipbP2gTCB3D9I4c9CsNUVZ5Pf7ZtZxsp593qMIDFR41BC
sayo0g5ZsZ8qwrx5CtBF23Q8X0CQ+iV8rpq5qptEbbSxJFocENfY71k+xszFt8DW
o+8b0aABFodP2Xj9k4lMhPp9BqbeUDDlkbVn8DEFaYg1lD/z80Z5wqb/3WwiwGa+
Py9MbVGOEcepDRtTmHNYADSsxWaYEY7hEK73xYDHdGXUOPsCq6z7KUjXexyECWNq
0wuaP+/6XEXZLLg+ez+hXJbE7IzDo3NQW/UsUMZlITqHlLFYnOuBpCmzsabtT7+Z
F/Z3TOViY1aWOLDGnjnvEDSCNurd76TOM0cYgwoXubxU7fcmh8Hnq1FXEff+ChVF
7fY7/+0K+sFkNhcHw5fl
=glpU
-----END PGP SIGNATURE-----

--pBVEohhI2cZ2uXfo--
