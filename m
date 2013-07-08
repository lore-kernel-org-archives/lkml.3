Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab3GHN1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:27:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51872 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab3GHN1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:27:17 -0400
Date: Mon, 8 Jul 2013 14:26:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Yadwinder Singh Brar <yadi.brar@samsung.com>
Cc: linux-kernel@vger.kernel.org, sbkim73@samsung.com, lgirdwood@gmail.com,
        sameo@linux.intel.com, rob.herring@calxeda.com,
        grant.likely@linaro.org, sachin.kamat@linaro.org,
        yadi.brar01@gmail.com
Message-ID: <20130708132651.GC27646@sirena.org.uk>
References: <1372510280-31931-1-git-send-email-yadi.brar@samsung.com>
 <1372510280-31931-3-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/6wHi7xPkPVdS2Wv"
Content-Disposition: inline
In-Reply-To: <1372510280-31931-3-git-send-email-yadi.brar@samsung.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [v2 PATCH 2/6] regulator: s2mps11: Implement set_ramp_rate
 callback for bucks
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/6wHi7xPkPVdS2Wv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jun 29, 2013 at 06:21:16PM +0530, Yadwinder Singh Brar wrote:

> Implementing set_ramp_rate() and using standard constraints for getting
> ramp_delay and ramp_disable, instead of getting it as s2mps11 specific data
> through platform data, makes driver more compliant with framework and reduces
> the complexity for adding DT support.

These driver specific changes all look good, I'll apply them after the
merge window due to branching issues.

--/6wHi7xPkPVdS2Wv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR2r4YAAoJELSic+t+oim9bV4P/AkC0rjmxMIB6R2OpyX8R0Li
jr0F3nwyFXDpeDe3VTfpXcyHDrxLw1ULKRP5440MoMGMX1NY2MSjQbi8fH4/JyDa
/3Wmw6C2yztDE994fZ354tCg+DGFXtBUIRh3r2Zg+6e7Xva7D/VKsJnnddM5YzmY
LGu1ZYI5YF2dcBjqJfFPg3fgWhlRbPdK2tJYdLkAB9PIllUheXq69ue5cjzs/SXH
zyu2w2BrwyQhXU4aMZHr9TcpAIOGCqG8p07Mvfz5BqJLoeSDbGroBJqdARJ5R81n
8kL714eDcQKSajPmTMh5DxMmUe9boT9SQpdXdsOHJnppztx6cEnmc9ABVdOECt5O
Ec5H53PUrEqYstdDv9YozDrOTBOxp4VjyHIt1cyV31q04K5KbHlywGxDcX6xvjQY
TZhFAnX+uO7mFIC6T3FAm1qOpP3EgXcamEN7BeaTZmtlMsL3YoST4qMHEleS/Y1t
lJsmVmckPq77wr1VYmcowHJ+I3JsOsKRgN7fbAhtwREoUygi4IcONZLkJbKgUjWE
UQvCICFTqK54T17x4nP5w6JZSTSI3wpwb0n2BIjq0fGp2zRfnSlU7ayuwglFe9mI
33uYk7tQzfNc3nrhGDd+PLYTqQpkFluUDC6IcAr5Mn+jQ/wYts8cp5dmNMPKNfKx
Qm1C37qarPBYEHKPSBhx
=ZEXu
-----END PGP SIGNATURE-----

--/6wHi7xPkPVdS2Wv--
