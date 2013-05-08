Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab3EHK6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 06:58:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51577 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab3EHK6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 06:58:41 -0400
Date: Wed, 8 May 2013 11:58:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Message-ID: <20130508105826.GE7478@sirena.org.uk>
References: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
 <1367997261-32048-2-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XLR3b0NScy54cC0V"
Content-Disposition: inline
In-Reply-To: <1367997261-32048-2-git-send-email-fabio.baltieri@linaro.org>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.60
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/6] ASoC: ab8500-codec: Add missing ad_to_slot
 definitions
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XLR3b0NScy54cC0V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 08, 2013 at 09:14:16AM +0200, Fabio Baltieri wrote:
> According to the AB8500 user manual AD to Slot register multiplexer
> accept values from 0 to 15 where:

Applied, thanks.

--XLR3b0NScy54cC0V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRii/PAAoJELSic+t+oim9cREP/j3UYPYxbcMgkDhZsCQnCSAm
EZml26KwwgzXxDpAFTfFV0jqTLZsrBQO4T7jIxZECb6YaakARYJySdNWZHRRG/L0
tfp3PON3OcSyHjIi2RO/5u7f0edofmAtS4MRI4nbo2PXe9LZe7dRGEPGbzzb12nW
VaYEYBIx8ZsrcjxTxVmwqh6qmmIvi9ZpK0cDEAyGJ2PKHjfJ0MtPJRODh4n3bZew
GD5tR8JeT7YRympzmOHBnWkN4maeyIJe/X6T6UFbMDUuSCCqpULjjaS/kAibUdc2
4t7M1uVJ/dTtG07e+8VnEff33kvyKIl82yUNQolF/nGFol06BbrtbkgSr8qd09BS
rjHr5iFEOI8/9vVLp0n7MgFUm6/ZrNdirzzCBNTYomT6i+zE67yAxU7AnlBDEKCl
BIuFvtDLIjFluXHwY1vw+2yru8+2TivXnjnGoEqFT6w3y7p3V1kIObwQnwRe1dV/
cMT9HqEe7agtYZgoLUzwhsY0z5hqWAMm5hlkTQkUA1xDWtBQH6/zxGf5vLBzxzRJ
dpth1bycOBHz9Upgn8cEwvD5uPDQ3aHhIptIGke94tuGnii/3Vw+dv+TDeZVUui5
mh+MLETqavTEBNniY42fC+8AOAwSx+3h3H1LwYgU3p4VmAZegtlAWL9mFX2ZIAVn
rtcsnMoPBRfG48vkXghH
=5vOs
-----END PGP SIGNATURE-----

--XLR3b0NScy54cC0V--
