Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab3EYPRX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 11:17:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33270 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955Ab3EYPRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 11:17:19 -0400
Date: Sat, 25 May 2013 11:16:43 -0400
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, Vinod Koul <vinod.koul@intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Maarten ter Huurne <maarten@treewalker.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Message-ID: <20130525151643.GI7660@sirena.org.uk>
References: <1369341387-19147-1-git-send-email-lars@metafoo.de>
 <1369341387-19147-6-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fmvA4kSBHQVZhkR6"
Content-Disposition: inline
In-Reply-To: <1369341387-19147-6-git-send-email-lars@metafoo.de>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 107.18.111.72
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/6] ASoC: jz4740: Use the generic dmaengine PCM driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fmvA4kSBHQVZhkR6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 23, 2013 at 10:36:26PM +0200, Lars-Peter Clausen wrote:
> Since there is a dmaengine driver for the jz4740 DMA controller now we can use
> the generic dmaengine PCM driver instead of a custom one.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--fmvA4kSBHQVZhkR6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRoNXYAAoJELSic+t+oim9VGsP/RwD3GHud0wg1TAOTr4i0QN1
CRJuK0puIfPvHg6RIhjj6q6PJ5BIwPxL4Ci50vVPeJ6WVsgvXpdqFVV0omxhSEY0
zsXdLabYw8FlsnyHfCQ9GnPBqS4uvoghpYma5/8/HNLFc6JoDHKU6k+DaoHudq1q
8Agkl13iaC3Q3qWBb/k5a+fvb9IdPCxEhEtW51WydsNvr5LWZ6ENYTN2wSYg/Hbu
LUX3479GOUMJpAdIwvbsJ7/P43PoTqIF5iQL1MB/IupnUwCRMNoRAUwmW2tY2WzF
8eS5VQLB5S9qEuMpoUiH0NAXlrKqTtugPUU24EQRLuCUR1b7XyOq3FDsFO6aimq+
ge1VbeILlw8kAUzM/9avNULZf6HnfOckOzoqXcfJvetw6Wjwk0bbooTlAUYPSHk1
OdLHuxkAQMubaldN+msRANImpomGkPsmzkwHid07IWBB9BhBodG2H0agxEk/Y03W
1gvmPfpvGAnrR2xVYBf0An27DxkH+/7BGkqV5jFinOjDlEbolp/inVNS8c6Ifj1J
KwRkXZdlvifk71WyXAlW3eefUODYrnIaaN24dKzru9xKi4J/YfEY6oy23RtUVgIc
VFKx5rikxnz6Gf4ZqLlUeG0R7rSnDIvV8iuZfaWMDuiFdpwkgHEo5a1b8U1DeQzd
bY5n8pdykGomdZ+epJNt
=L8pi
-----END PGP SIGNATURE-----

--fmvA4kSBHQVZhkR6--
