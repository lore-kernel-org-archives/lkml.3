Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab3AaGme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 01:42:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33239 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917Ab3AaGmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 01:42:32 -0500
Date: Thu, 31 Jan 2013 14:42:26 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps65090: Fix using wrong dev argument for
 calling of_regulator_match
Message-ID: <20130131064223.GB7663@opensource.wolfsonmicro.com>
References: <1359548900.3885.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i0/AhcQY5QxfSsSZ"
Content-Disposition: inline
In-Reply-To: <1359548900.3885.2.camel@phoenix>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 30, 2013 at 08:28:20PM +0800, Axel Lin wrote:
> The dev parameter is the device requesting the data.
> In this case it should be &pdev->dev rather than pdev->dev.parent.

Applied, thanks.

--i0/AhcQY5QxfSsSZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRChJFAAoJELSic+t+oim9LO0P/1sZV5y4Z9vgyaczXFGQqxJM
zvZKxgxzfPNqCa6gLcVwie7IXRu1mgYxdyS+wUNNxdJ36M+ibc+uwczsSEKSZxcm
hrlKSW7lz27YM0tUTePWC7tgdnnyNr1G6n71U2ZKm9yzOq6AIqcptkJrAR/CkLNH
goXLu0Ru2ibFMDKHqDOm4OTz11WiADr68eM5NxtzkFdQxAqpzIGgvzeazN6EGLir
F0XgFT9PbkTD+Mga5o7JqBHfQ9cOcc9nKzMH+c/Kzccp4N7+9NJO94Cgw+0hjoua
6mQxYSC6ZWkO6Y+pRWBB0KK+5B9SKuTcTcsBullCFYMGAwrfvr4Vqbqlj2/boi9Z
nvbKfYhPubCWrrLex1p1T2drxI1Xp6WW5jeAXX27HzV5bLS/bV41yPVR/ffNr0qi
KLBfgK/MwgXoh92vgCfOGoqw6jNVVCE0uy9NzhS0rNrNU+wookIStbgmyjIWQwuw
fZaK7Us1t1FNBtQXwldXCE0X3o+epvg35j0GgoqAFMOFL4YPQS2RNu5SJX7cmXhw
Ehz8TyisebTWUH6SzpEWcGrYhlldC3wYhKwLL0F8Pwvl4d+RrNNP6ja2zQjf58+k
+Mkv7FkOo803kcMqmpZ1V8HQzuhGoA9c9vzbHWRNz41GYXtWO1LpYl50H82OvxgS
ZIPF/xpf7lWLjjUqmCd5
=NNnJ
-----END PGP SIGNATURE-----

--i0/AhcQY5QxfSsSZ--
