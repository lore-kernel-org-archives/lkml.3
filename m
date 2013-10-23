Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab3JWLSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 07:18:22 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60283 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab3JWLSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 07:18:21 -0400
Date: Wed, 23 Oct 2013 12:17:58 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, lee.jones@linaro.org, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Message-ID: <20131023111758.GN9388@sirena.org.uk>
References: <1381864462-26167-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1381864462-26167-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BjavXC7V3ilNTWHC"
Content-Disposition: inline
In-Reply-To: <1381864462-26167-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Do not overtax your powers.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 31.113.190.237
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3 v2] mfd: Allow mapping regulator supplies to MFD
 device from children
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BjavXC7V3ilNTWHC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 15, 2013 at 08:14:21PM +0100, Charles Keepax wrote:
> Occasionally, it is useful to map supplies from a child device onto the
> MFD device. A typical usecase for this would be if the MFD device is

Applied, thanks.

--BjavXC7V3ilNTWHC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSZ7BiAAoJELSic+t+oim9gI8P/1iUe52V0n3ZshrJSkfL60z+
RzlxN8za6YPTTwnQe5VNyqny55h4m1u4cYFd8jdlZM92401aH2SwUQBDv5HizkxM
bazoKel9ZVfn7d55WwKjVCrEzWlVsP23GlSOvgygdVillDwi+xFqrBFebA4X3hiP
/H+4pobmGZmQgGhfnM+AhWMVo826SEnQb9bYMkUTWFXnSw8dN7rWQBintKSJZZNb
32cRC4gwAPIofkpZo8cccKV3zvhcJljPPucB6Twa3TNuaV9aPMSJgk9El2Socsga
p1FTZ/RjtFle5DYuk8qmOhn9VXDaesXV6O3hlcaZaNoKRDfIlQB55mSj3oB4YLbn
+/+LwsU1ImH69kNWvSEvwjakOBL5CFq7OgbDoUKt/IzUTKCDR9MPNDZOmk1plgFm
Zn9yqTiEfLDkoi/cmaAHloVxyp+UKvSp2M84e0hi2MNHiIX0CUupkqW6cOEAuYaQ
CDcxlGpreJUK0x1azZ1/Ni2/qe+XdgTdVF9KxJiNjutbQHmI1PRFa108e10XmHQn
hbAjmavbaHMyrUqvGNVztOaT5SaF/0vLELQ6h8VL9omvhAokDfDkPM7t6jVQH3Bx
MtmhWf9tBp5A8i7yMLf8jIIqIF7oneMBdeqhRl+A09rKM2cqY9WPA/Y3IQVvRL0y
tphgcm9fGqJBbp1sn7Vh
=s044
-----END PGP SIGNATURE-----

--BjavXC7V3ilNTWHC--
