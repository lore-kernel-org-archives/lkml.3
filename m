Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbaKXTBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 14:01:54 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37311 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbaKXTBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:01:53 -0500
Date: Mon, 24 Nov 2014 18:59:41 +0000
From: Mark Brown <broonie@kernel.org>
To: Weike Chen <alvin.chen@intel.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>,
        Boon Leong Ong <boon.leong.ong@intel.com>,
        Raymond Tan <raymond.tan@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Message-ID: <20141124185941.GH7712@sirena.org.uk>
References: <1412783423-9408-1-git-send-email-alvin.chen@intel.com>
 <1412783423-9408-2-git-send-email-alvin.chen@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HywGgDAwzDJj9z7S"
Content-Disposition: inline
In-Reply-To: <1412783423-9408-2-git-send-email-alvin.chen@intel.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2 v3] SPI: spi-pxa2xx: Add helpers for regiseters'
 accessing
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HywGgDAwzDJj9z7S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 08, 2014 at 08:50:22AM -0700, Weike Chen wrote:
> There are several registers for SPI, and the registers of 'SSCR0' and 'SSCR1'
> are accessed frequently. This path is to introduce helper functions to
> simplify the accessing of 'SSCR0' and 'SSCR1'.

Applied both, thanks.

--HywGgDAwzDJj9z7S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUc4AcAAoJECTWi3JdVIfQRyIH+wZImRqQJN7PU9dzxgmiy7TX
9GWfxfYOInrqz5Vq+1C9fSQa5BaPc5gEIxYhzhSTx2epN0iVzWPRAQ+9cWbJ8AzL
LimcFSDx8/TB4yj82fIPg64cN8HaPDqw/KP4vF4DkL0RNzTtLqY2voeZtbdcqnKC
1MgV3rVsB1KCaeOqjSUpiOt8S+yuX9HL5z7BJ0gTpM5oQUuQHLa/pXyr5DRx5mUB
lN0B5KNiwDRiNBMpK3J33gtC5fdjeJN6OhGkVggSnDOulcMl6gEfS6XNPFL4uXQu
t1KhUwHHi7RKyK4r9zYapidv0so4+6sNCgpEG0AywecVZ3ObZx3ybi9FCnrBlyk=
=hcgV
-----END PGP SIGNATURE-----

--HywGgDAwzDJj9z7S--
