Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab3JWLSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 07:18:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60298 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab3JWLSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 07:18:31 -0400
Date: Wed, 23 Oct 2013 12:18:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, lee.jones@linaro.org, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Message-ID: <20131023111810.GO9388@sirena.org.uk>
References: <1381864462-26167-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1381864462-26167-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JWJEtCrVvH5hpatL"
Content-Disposition: inline
In-Reply-To: <1381864462-26167-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Do not overtax your powers.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 31.113.190.237
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3 v2] mfd: arizona: Specify supply mappings for Arizona
 CODECs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JWJEtCrVvH5hpatL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 15, 2013 at 08:14:22PM +0100, Charles Keepax wrote:
> The CODEC power supplies should be looked up on the Arizona device as
> they will be created here by device tree also update the only user of
> non-device tree bindings.

Applied, thanks.

--JWJEtCrVvH5hpatL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSZ7BvAAoJELSic+t+oim9XsgQAJxxAMhnEqadcsjfwAxSiBmh
Jl+ZgL00sJcTiYCXVsPKUb8djIuoigW177jAG9XTbk8UJUZ1AKWh0q4nn8kMbBpC
EhkxPKzM9MgK24zTApdd6WLJpA2r3nndCT4u2irzM5ixC3EpR3ppOLuBp6zMTs7X
lxOTqUdNzR5t+YMNzQi3fjU71cMMrclL924mwnOQkuSGbOtqxbS2yA3m4zpTQ8Tz
bpaW6KgcsneMoF9oi+FkXhcjW19O1pa0mbSrdasZSzdrA6mJSFwexBCREXIKLJFA
yJIHP4gSyznXVqeLOwNnsg3oLugPvXjaX5FRElFW52FfrUefhdRw6rDR2J9scxPO
ILyx7H/Zq9R/wEgX8SZ4Q0BbqMaugoq3H1kyQ9JZOiU1d/loMAN7ks5hlHi3c4UL
RiuKoFcdJFpnRKPzvqsaOT6pXNdiHPvxdwdbXY3E3HuvoK2QnF7E5pWvTghPJ48R
VJJurZGhvy4FtjOKIkkKAkVq8Spsr0PLB6Rbe2gJ8tagVrfB4cRBSOdCt7vkVRtM
qP2pd45ZDoUf7JBITNwYWn1MoTnyHbbOJADc13Y/IEwvcNl3Bt6U3rzb7OxgLVu8
YeZEU93+zRJnmwZSqBsJVpIPheBDODoK8WrrVU8NeKIQn5q2jDRDZePqeyO8OhL4
xYKxf4bXiTvCnvsl5GnO
=VuMN
-----END PGP SIGNATURE-----

--JWJEtCrVvH5hpatL--
