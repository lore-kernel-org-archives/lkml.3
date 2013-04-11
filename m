Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935566Ab3DKQss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:48:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38145 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934395Ab3DKQsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:48:46 -0400
Date: Thu, 11 Apr 2013 17:48:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH 21/30] ASoC: samsung/i2s: fix module_device_table
Message-ID: <20130411164844.GM9243@opensource.wolfsonmicro.com>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
 <1365638712-1028578-22-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fc4772q/IDjJVU21"
Content-Disposition: inline
In-Reply-To: <1365638712-1028578-22-git-send-email-arnd@arndb.de>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Fc4772q/IDjJVU21
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 11, 2013 at 02:05:03AM +0200, Arnd Bergmann wrote:
> The second argument to the module_device_table macro must be the
> name of the device id array. In the samsung i2s driver, there
> was a small typo, resulting in a build error when building it
> as a loadable module.

Applied, thanks.

--Fc4772q/IDjJVU21
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRZulkAAoJELSic+t+oim9Eb0QAJq6BWfFN8LyYm7SIzNs+7yS
XrUUUkDvwYPdas+ocmUEVf5y1CA5TXY1mRdcMgYD7MZU4Z12DFoOowxVud9p+4QP
pPLjrgBem9Z+yNMaLaX0C0tZyiabh9mcGVNdY8PFUXkFIRdB8fOHK2J2rvBQ1IBR
YnvzwuQ/dfQkDkyvlUR38qVb38N4oWf8TvA1Wdwj7Jx0qyZwvNPIRw4aZ5XNlJfD
4rN8MN+beNAOsYPx2tV9m8buA3Gw4W4gcEPAoRVLOD1llka7o0O+LjlkCncdYKxh
2kVrUbGTiivOqPScSFEuKvgNppeBLjC8uzY7lL7lLvNltalVxNM1NU9tE5aTQ4Rm
0OyktoQFQXbq39eR+H/RVGyQl8CO8/vZU7dhin6/mUJu+FLcWi/W3zMUFzxn5d2P
e6R2iwlrC+7dGrdKkGGAGBXvdbxZZRBKNw61ifbYRJIdg1D7n3W4UXtQP1Q4eoJX
Jm4ogYcN14RAYSBm4VtNnx2ABWrqL3QzTaVLBOmPO5VZZwgTR3f72kS4bj7umNpV
uCfu4BMVVMRXmZUXINIEfeFx12wAXksMLa19onwEBFGMoX9Xpbp/21E50PiRoqY0
E21HY+qiJHh9pgulIdDaD4d+xfuggZPMryJhdt6/h176UjlaqrN0vsvI1ctLUEem
dvnbg+rGLd4oRskVkeS8
=QeBV
-----END PGP SIGNATURE-----

--Fc4772q/IDjJVU21--
