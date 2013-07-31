Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760544Ab3GaQyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 12:54:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37426 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760081Ab3GaQyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 12:54:21 -0400
Date: Wed, 31 Jul 2013 17:53:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Robin Gong <b38343@freescale.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20130731165355.GY9858@sirena.org.uk>
References: <1375195664.11289.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jO07GP1DIjZR2Kaj"
Content-Disposition: inline
In-Reply-To: <1375195664.11289.1.camel@phoenix>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: pfuze100: Simplify pfuze100_set_ramp_delay
 implementation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jO07GP1DIjZR2Kaj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 30, 2013 at 10:47:44PM +0800, Axel Lin wrote:
> Simplify the equation to calculate ramp_delay.
> Below equations are equivalent:

Applied, thanks.

--jO07GP1DIjZR2Kaj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR+UEgAAoJELSic+t+oim9JMUQAJ14y4h0hqbXKVlUHiLttI0M
C+Noz9VgeSG0R8AnN4yV3qaO4SpmY20s5BQ2aNw110S6Uopbr3jjeERxLY/BR9oB
PjJ40UIAXMRG/KyCLORBVkYiTCZ9Pn/M+7bIk3Aq2fggIXwnCq3MMCKlEBEhwhb+
xr5WhyyoUjijKQyR7Bu/j+4xgK/nfvb/uOlgVNjtZwAts+gCvKgt4tIQn4FQTM//
zuF+yfpTUMjJatrLL2PGETP5BwDcVUJAIxoBv4trHDvM4WEWPbXsdl9xrAt+u7V0
uHQGpglXikZBHPn7SDfWYjFsBxG260g18mdzRdHFlpl/meBreL8cs3rV5yMT340S
k1ZUTYeufsijT+kUI1X6wZpuWYF5LHcW0SM0VYmwtmU+lfckvKVzZ5DPIzj1QF+N
YhOU+fDI32Qn0881rNZKy+jo3ESm7mJAVQC1AEYTmd7bz/TubtYqH9StQ7WzEks6
zgkDJ+ZyuOz6vJDj7lmcbU8SU091iY7HCF1cwC6VGSHIRTKp4Y3Kezx5esGO9I46
HKCQYDNkrTm8djarAcIq7vbxfHUNe1SXtQyLHaiXP0ww4UhIeychXKrsj7tjJSPS
tFnkir5NS0BO6rTdpuaNyHmtGo2teR6o32C6RTrl/Ih6gEbnyI75o4bP2pBHoc7h
sSlfGK71Y/rSAFly483m
=rpmK
-----END PGP SIGNATURE-----

--jO07GP1DIjZR2Kaj--
