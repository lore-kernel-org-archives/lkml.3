Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab3JQJhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 05:37:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40667 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab3JQJhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 05:37:10 -0400
Date: Thu, 17 Oct 2013 10:37:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei Ni <wni@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Message-ID: <20131017093701.GH2443@sirena.org.uk>
References: <5253A17E.10503@nvidia.com>
 <20131008090910.GW21581@sirena.org.uk>
 <5253D489.7010900@nvidia.com>
 <20131012121412.GJ2443@sirena.org.uk>
 <525E17DE.6080301@nvidia.com>
 <20131016103942.GG2443@sirena.org.uk>
 <525F6A1B.70505@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JnfXrmBFCAcKdhDT"
Content-Disposition: inline
In-Reply-To: <525F6A1B.70505@nvidia.com>
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: About [PATCH 1/2] regulator: core: Provide a dummy regulator
 with full constraints
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JnfXrmBFCAcKdhDT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 17, 2013 at 12:39:55PM +0800, Wei Ni wrote:

> So do you mean it should call the regulator_has_full_constraints() in
> the .init_machine for all machines? If so, this will affect all boards,
> for example, in arch/arm/mach-tegra, if we set full constraints in the
> shared board file tegra.c, all tegra boards will be set, is it right?

Yes, but this is currently the case anyway for every system using DT -
all we'd be doing is moving this call earlier in init.

--JnfXrmBFCAcKdhDT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSX6+6AAoJELSic+t+oim9Gw4P/iN90WW0Wn+/x5h8ETqum0/r
m5yCm8vN7EYh2WUmrEUIjl3d3JXuNRqpZplzf6sTLwXd94d8yekDR9Kldc2uat3Q
CUAtYKOqMGjf36YD1pFQ4Gc4dAjJuyd+2Br0j17yL9xprtPM+EEt70i0rrF4VdTe
NqVoIaj1YFIzCO27HiKF9oSrtHsxET5JtMpAqnZmIeOdfCkjsAVSSwB5lD2AnHmE
S5EftI6+pg4vdEKG/U3QbS+I27F8N33QBwGXYDmomVZMCb0sV1BS/mKuUyEeVXnT
94DIZiEcnzIHf/mSSVuzaeLmdmZyEws4iZkG1Y8CZDfsTHqwL9SdAW0dH8A/HWCs
kvsxqCCNY9BxvLRUuOE2jsR6Ahmt42L8BNjIDzV7M93buVj5pmoEe4S56JIdlPnk
fuj7AQi4plQOqDpxN3S0mLwAytLSD1UnoMGfP8JGWkTetGuXTqY0alpBhBlmT4Xo
AOvJHf/oGkmTvna892oVwhv7YEMbFhnUrqtzvq/9ffEjISITZFb4xJGCaNLAXOEb
zzrLyxK15CcHO5sVxj/0gp9kGFd0CosiM6yLUAhPDi46uMfNI3QhcNRAo78RNV/6
qCVYrsTud7Ul/r1PKMcwEjHoNwm1H0Se5Q/rGIy5D6+lU0eCOmIEtI3kF7maT9jT
YWTfeqWJVb55giCZsCEe
=+rKC
-----END PGP SIGNATURE-----

--JnfXrmBFCAcKdhDT--
