Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbaBTK2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:28:39 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47148 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbaBTK2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:28:36 -0500
Date: Thu, 20 Feb 2014 19:28:20 +0900
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Message-ID: <20140220102820.GO2669@sirena.org.uk>
References: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1392736948-26623-14-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OT7cAIs3hzHuHOVt"
Content-Disposition: inline
In-Reply-To: <1392736948-26623-14-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 13/17 v2] ASoC: omap: rx51: Update locking around use of
 DAPM pin API
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OT7cAIs3hzHuHOVt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 03:22:24PM +0000, Charles Keepax wrote:
> The pin updates in this driver look like they are intended to be done
> atomically, update to do so.

Applied, thanks.

--OT7cAIs3hzHuHOVt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBdjAAAoJELSic+t+oim9oekP/jKolAtuK0sXBlDdmImpNfFX
6iKrDOxrGz5q8QPJclelAauQJx5y2MNm4zMYKo9VaLbY+zZUdvaHW10WDZqRGzrc
BO9I4BwTjr/f2YV3oN9mEfmY5fBpDT/ntP1Yf5hNoT0OsuKewvtHHNGQkiYvtNUX
6RftYpNQiStuAqFGllsUaymgouEtAsNnqMDUNyaCbieVPNj0ah2aSNL208bdwrlC
XWmgq6eJbwnkiol46+KfItuqUJ8GaCm6QHlBlyJMty62bfa2DMY8HdkOuESvk7ZE
LL+COBXXtlNwKJCYI85qqCOqVFoeDszKP6nZvQz/iF2GhMD17hZJQwkBYrYLater
qghg9pzb9cCqHX5Mg1ERH5jjDOuRu9VNXvlEcCk8GM/JEGPttT8hjSOIT9J9Wbki
97B8OnX40HiBTr8yWRt+39ZKstJik8VYiCkxwJQyybnmhigA60pu90DzuGyXPGpV
o1vPyZaPlJxXE/FC0Hg+F+ABi0NxCKOIJIFmtN2oJgIVCPdCwel5SIh89UOo2ghA
cj/FxMpINZV4MW977Vsbe8FIOyhR3OR9NKqnuTAEAh2w4xLj0ljpc79Uz67guyFj
IlqGgUs6feDnQS6+sVD5MXnZzd0DArrpaPV+Q/yRoV6/XBGFIZaFBuKHL74RJWip
ckE9MIJ2EV8/tQcMrCpv
=en9I
-----END PGP SIGNATURE-----

--OT7cAIs3hzHuHOVt--
