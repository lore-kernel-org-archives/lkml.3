Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab3KNNCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 08:02:52 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53375 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab3KNNCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 08:02:49 -0500
Date: Thu, 14 Nov 2013 13:02:40 +0000
From: Mark Brown <broonie@kernel.org>
To: Oskar Schirmer <oskar@scara.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20131114130240.GQ26614@sirena.org.uk>
References: <1384271198-18974-1-git-send-email-oskar@scara.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4SRTEifjNkXp0Rce"
Content-Disposition: inline
In-Reply-To: <1384271198-18974-1-git-send-email-oskar@scara.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 149.254.58.211
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl: imx-pcm-fiq: omit fiq counter to avoid harm
 in unbalanced situations
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4SRTEifjNkXp0Rce
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 12, 2013 at 03:46:38PM +0000, Oskar Schirmer wrote:
> Unbalanced calls to snd_imx_pcm_trigger() may result in endless
> FIQ activity and thus provoke eternal sound. While on the first glance,
> the switch statement looks pretty symmetric, the SUSPEND/RESUME

Applied, thanks.

--4SRTEifjNkXp0Rce
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJShMnsAAoJELSic+t+oim9TIAQAJOcYOS1vFXVLpISAKKT7Br6
0NAdB03z356Zoi6Z71GFETBP6H9rZlRGCA3AK4WKFSixYVvxanBHC4DHwxJTkLl6
WsOYg47PBjsE4VhKlrau6oYNGjKOscgxcC++8Lj7Fp/cArnhMRxU+efNwpAB7uMO
egdkXJ2iUrYtQbAMPGu/MmRkY1TCsUHmmeuLdRePiHuFnKAzpVZMI+b6AVqr8+ew
6ZmSRGbz3BH5Q9/FRNqy2yX+ZxZLiECCgyCLSFWUZ/35uGjHm50kTkj4tROap2MV
cl7Rd55veQlodmQBZJjtR83kcvtewO6hOccHBBx5vcCf0YwLG61GateWy8cWzpA3
DsOiHgoCZ0HvGRbPAf7IJufdgYLVkyIgLXH2xTUbS3Q48EOamxrTcqDqsgqwKaE4
UVidDoihStyVjLAQ3hjjGPQ07MS2aY/r7KYks79RpbzAg3x9v4MEVSCh8umsCI5y
bA3I0N86diF7Y4dwK0NMRVshiFkCv6Tg1VvL3tyuLlbvpOqK9TytKrx4aByH2GVt
l2OyVfR7eY4QhGYnYwznQQaozDAGVu6WMcp77b/OdGDZL+xjKIf6jkJBA7ieHneL
87T1Xo6oAt+57YM7VD3/n5Rwu/7w5G5r5ca9KX+gJ0XnUrAL8oZD1742PHw3fTTv
DZYhGtHqB33VeePMmLdu
=xCkV
-----END PGP SIGNATURE-----

--4SRTEifjNkXp0Rce--
