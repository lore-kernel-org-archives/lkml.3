Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab3K2QFH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 11:05:07 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59893 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030Ab3K2QFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 11:05:01 -0500
Date: Fri, 29 Nov 2013 16:04:31 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>
Message-ID: <20131129160431.GE27568@sirena.org.uk>
References: <1385733827-19831-1-git-send-email-peter.ujfalusi@ti.com>
 <1385733827-19831-4-git-send-email-peter.ujfalusi@ti.com>
 <20131129160032.GC26982@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jxJZfy9MYHgKPwT/"
Content-Disposition: inline
In-Reply-To: <20131129160032.GC26982@lee--X1>
X-Cookie: Boycott meat -- suck your thumb.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/5] MFD: twl6040: reg_defaults support for regmap
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jxJZfy9MYHgKPwT/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 29, 2013 at 04:00:32PM +0000, Lee Jones wrote:

> The code looks fine to me (me = !regmap expert), so with Mark's Ack I
> will apply.

> Mark, is an immutable branch required for this patch?

Yes, please.

--jxJZfy9MYHgKPwT/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSmLsMAAoJELSic+t+oim9WygQAId6aXD6wTYsgpIrqZkiIJV/
Idi/Ddg247MLIu+yYZioKgRhSg+u5b9hzQg+XpPp0Dhr9a75rnwReB/aCExQwRmU
TdHhdpv0TiLACXxLioSN9PrsyFrbzjiPI3xr0NJqIQ4xp9dKDOLquAvSdGk3p/7B
I8i4NMMnyWu0856sa3OhHPNEiwgDtj4d+3Q+gihT/8JelDyHdLHj+POdIN/ICuxh
6r4y21AcZFEoJUnD6hrF5TqH2cAoCXRG3m3LbJCP4a9PKEkyBk4V6LMsmmKm4YJj
sSdjIQt2reMcLn8EZoBF1AHAe09jfPz4kecn2PNq911CbJYmeAPMWlgXcoqgPLjm
HiVJOJOMuHI0lq/gr993fOUvLZ30gFwmnMLNQY1J2S7BcEgRbocD7oCDoCZG0hwF
GKJv3kB8EMwVq8wPZL3v6nrVl0+ZbBZViGvEDeLEwbZ+sSBsh/tjhs49o5Zfr21c
T0jkdycTLFiM6hVdglcmbygiajInZh8KH/kJYsV5Bzn8dMlDrhlhbGNVjtsMugVA
jruMxPuJSqIzaBu/4YPD2/EWscix2DtfQGLNXd36kKDb3CnSIDDZtmxYRMIdmKqE
IP2LCPEJ2cCRo1ujKzniTTuKBus1gbR40G5vE5+gsFifflr4q9oepAuLwQjJ0flZ
CHfpy3ClLxnNeS5mpOBe
=JlEr
-----END PGP SIGNATURE-----

--jxJZfy9MYHgKPwT/--
