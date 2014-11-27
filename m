Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750983AbaK0Q1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:27:09 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41052 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaK0Q1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:27:07 -0500
Date: Thu, 27 Nov 2014 16:24:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, linux-spi@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141127162459.GY7712@sirena.org.uk>
References: <1417088636-11994-1-git-send-email-lee.jones@linaro.org>
 <1417088636-11994-2-git-send-email-lee.jones@linaro.org>
 <20141127125904.GV7712@sirena.org.uk>
 <20141127150508.GI4628@x1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zBkzUKoNN9/BHFeb"
Content-Disposition: inline
In-Reply-To: <20141127150508.GI4628@x1>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] spi: Add new driver for STMicroelectronics' SPI
 Controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zBkzUKoNN9/BHFeb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 27, 2014 at 03:05:08PM +0000, Lee Jones wrote:

> > > +		/* Set SSC_CTL to 16 bits-per-word */
> > > +		ctl = readl_relaxed(spi_st->base + SSC_CTL);
> > > +		writel_relaxed((ctl | 0xf), spi_st->base + SSC_CTL);

> > > +		readl_relaxed(spi_st->base + SSC_RBUF);

> > No byte swapping issues here?

> I think this implementation has been pretty heavily tested.  What
> should I be looking out for?

The bytes on the bus should be in exactly the same order as in memory if
the word size is 8, SPI words should be big endian normally.

--zBkzUKoNN9/BHFeb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUd1BaAAoJECTWi3JdVIfQST0H/2HZDGXTX2tMsJEAuWKCam/d
+dHlbwpd10cbDyLHMxX1FRToqMzTjTPRV41fVVqbOmIF7qXh+GeogAgeaZvdhAvw
v0GFS30LGtHbCJkLVwxOHAMZMJ8QhGh5aSUkKQVu9IT33FVnEECers5saWpnPMuS
cwvX9lnV6PjqTdsWsmrOaAPhWHJs7grKKtLn3dXStBUo/vXvfxqded9fWwL8t1Cd
4y+AYu/PAeME2wfakOwZ12j0Fn5S0fdvNX55UXbScn93eNyHU3mJqe/CnUmbXTfy
PyIC021qIxT+z5AKZgqDLxV8wHhDyTA6jqJ8PDyKU3PvLSIiYOCBorBUtl2Hxgo=
=3gML
-----END PGP SIGNATURE-----

--zBkzUKoNN9/BHFeb--
