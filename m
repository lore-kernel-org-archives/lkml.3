Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab3KMMv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 07:51:57 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52753 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab3KMMvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 07:51:54 -0500
Date: Wed, 13 Nov 2013 12:51:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Florian Meier <florian.meier@koalo.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        Martin Sperl <martin@sperl.org>
Message-ID: <20131113125111.GE878@sirena.org.uk>
References: <527D1DDA.2040004@koalo.de>
 <20131108181743.GR2493@sirena.org.uk>
 <20131113050017.GO8834@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T6xhMxlHU34Bk0ad"
Content-Disposition: inline
In-Reply-To: <20131113050017.GO8834@intel.com>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 149.254.183.27
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] dmaengine: Add support for BCM2835.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T6xhMxlHU34Bk0ad
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 13, 2013 at 10:30:17AM +0530, Vinod Koul wrote:
> On Fri, Nov 08, 2013 at 06:17:43PM +0000, Mark Brown wrote:

> > Adding in Martin Sperl who's been looking at DMA with regard to the SPI
> > controller (which will want non-cyclic mode but I guess there's a lot of
> > shared code).

> Is there a plan to add a library in SPI for dma ops, on lines of what
> is done in sound?

I'm probably going to be looking at that at some point, though perhaps
Martin will get to it since he seems to be looking at this.

--T6xhMxlHU34Bk0ad
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSg3W8AAoJELSic+t+oim9lAIP/i2DqKmTzrViDNzR93jn6mvc
yk4mHQ8T7rHUOhGCAgFhIahzj+oNnxem4IjfXPOdzKEHBAE8VaKrAFV7qRlWbCbU
4PloFqW65C5HjAidUgZQaWnKsk0HrfJhjKlN48LoBqQCKqwunL7fJ5EnL2dki0db
lmRND/wiZ9W3/6rIxxXYGWWZFQ0zdtdbeKV/h27fYZAv3OgVZabd8DdFlb9vUniP
bRJbLwBfBXZX8e/p1XrZQJ/5eP6yTFLqNGSZVM+/8vWwLEhOZriU6KTlxF4TtE2Y
0EmesN4Wzc+B7PIqIziu9BtV+YiyoaUypKs/Z6r60np6j1Wo5E8aXG+APwDTHfgM
eSPy5oqglsYNxxjR32AgXWpDORuZBqH3SobWvZjBrk1phFPMLzqYbRwWpY0x/U8i
nTvo/yEkhwsdt623Csl10u67UAG044fyBoSr+/pHgkuBdKuVs5HGnik8bTsfoa2a
1iBFJdUXHVJ8ip9AKO4oidekpjgV9gg4JD7qXBWbLWbhWKPvNUdTmuPeT1626nor
qZdgUa90tNZewLuJh+8GwdYGo+ep/lrnsA2ZDI3a5v3QWj/MJH0E9s5dKwqMRVzd
zfocxUDLM50cMtqAtHlUwcMdW7u0sAYcgWAEghWAh68jTYJ/D31YY6VqXvU+DlK+
Us6gLYk4U+Z158P8Wub3
=4s61
-----END PGP SIGNATURE-----

--T6xhMxlHU34Bk0ad--
