Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab3K2M34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 07:29:56 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53962 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab3K2M3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 07:29:54 -0500
Date: Fri, 29 Nov 2013 12:29:50 +0000
From: Mark Brown <broonie@kernel.org>
To: Vince Hsu <vinceh@nvidia.com>
Cc: lgirdwood@gmail.com, ldewangan@nvidia.com, linux-kernel@vger.kernel.org
Message-ID: <20131129122949.GX27568@sirena.org.uk>
References: <1385637042-33201-1-git-send-email-vinceh@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GFPlsJ7YtLjXgs8j"
Content-Disposition: inline
In-Reply-To: <1385637042-33201-1-git-send-email-vinceh@nvidia.com>
X-Cookie: Boycott meat -- suck your thumb.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: as3722: set the correct current limit
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GFPlsJ7YtLjXgs8j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 28, 2013 at 07:10:42PM +0800, Vince Hsu wrote:
> Simple fix to set the correct current limit for SD0/1/6.

Applied, thanks.

--GFPlsJ7YtLjXgs8j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSmIi6AAoJELSic+t+oim9mYgP/0N24NDei23PtsU4EFBeqZUE
TOypNiMgPeriRtY9jUJL0r8BO5K2LRrMoaq3rOc5gHzL95Azz1QF9rv7zbV95BQP
ecz4F6Rp0udGu3SXXTfA98IDfp+JQyjKmBWEJ2gFOTq4weRgSqmodJ3mPQ17Ga+B
/ml8MbBuvNI2hDaxfMiwxldC4diYGvCHQj5qaC6a+GhYMo+nKTe94SlDrCU+owrF
eafkllB75g4XAQFO+/qPWOfMpBkC3CFYymA4+PVI8XXOjAWBrclYmmgCUm8RnCHT
9a/UWA2722YE4jBZRYdFH9VHbpOMaG697xlExTGKpyFJmUD9ETMHyjLPjTNzyeZo
yhig4gaa2ep/1vG6BSwFKmRkjVc6jmfEYdEfbuH0ewvvJWRQEZt//RsIoNH3Y2Mo
wRlL+CEYL1C5qPO9r8GfM8FLBvyy27IHUR6GkjJ4ibJjhumFDDuKfQ0ju0Fuf02x
zRZL2KO/iWLMW9PMSku30PDWO1FgqvydGtewuIqVklBYfQkcGsaym13yggfEv6Tq
I2vmVyUlXzOvOcyl4UOqbhUKW2OV16HbdZcaLxJ4LwX1Q0VsqmhIFOcgppGlgGMI
4oewnOF7rKaOwGQUK9dh2PkOgyo/IhdJCAEfRkm3VKRwsL/dXVTuvRruCA4lA0nK
/5Fc0gEESa4n6agecs54
=dMOs
-----END PGP SIGNATURE-----

--GFPlsJ7YtLjXgs8j--
