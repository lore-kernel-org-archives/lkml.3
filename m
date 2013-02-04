Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab3BDKcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 05:32:19 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39571 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752962Ab3BDKcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 05:32:14 -0500
Date: Mon, 4 Feb 2013 10:32:11 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lrg@ti.com>, amit.kachhap@gmail.com,
        Thomas Abraham <thomas.abraham@linaro.org>, kgene.kim@samsung.com,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH V3] regulator: add device tree support for s5m8767
Message-ID: <20130204103211.GI4720@opensource.wolfsonmicro.com>
References: <1359935387-19065-1-git-send-email-amit.daniel@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rCb8EA+9TsBVtA92"
Content-Disposition: inline
In-Reply-To: <1359935387-19065-1-git-send-email-amit.daniel@samsung.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rCb8EA+9TsBVtA92
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 03, 2013 at 03:49:47PM -0800, Amit Daniel Kachhap wrote:
> This device tree support is added for PMIC block of S5m8767 multi
> function driver. The usage detail is added in the device tree
> documentation section. This change is tested on exynos5250 based
> arndale platform by regulator voltage set/get API's.

Applied, thanks.

--rCb8EA+9TsBVtA92
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRD44eAAoJELSic+t+oim9F2kQAI1oapH3N0mA60jSVNnZL6NL
AIGkSHMRebYen+83oYRh5kfw7RvYUQoys2rti7KpchczqRhidGTs4jM/MsA9rnyx
92Jtvlm2YBkzgMl8pS2qEDRethMZQjMU84FUj7wNbW+wjTuxfjW9AIOnN6gkgZAr
2FYiCQQH8T9OaVAt9DSpqXp+8O82U6vIKYi9FS1WRvdL72RtAkj0Db3h7CAIBXZq
q85zIUJGMN6mW1S4XaZeMym3PpI298XwXZe+PQe9NUAw8kzelkl1xq+752Y2TBGa
fOZKXX4ppJvFE0tT182fcrl13bEufNPCwhGMEpnoYxL4SEuVLzxOh3JB/OjLANLr
W8dZA9VZGC6j+iFfsXrUyp7d93FSy787G15nnHEN3Oxl3l/9MsDkZPeGJQeVT+sJ
M3RsdD2xq02tMEJO87TkiHOaugGfz5Tc2QCz9j07QTptJ11K3iJ7m58KBtGqsLYJ
nt82f4oPTstLAGCLEahJAVWO79XMfl9V4N3m0MvUdGj+wzNlmKfAzmZxZanfDfkj
++0GpFRFlYndl8UOpM3MoAwXpsfsTevbyMDByae9Z2V2blTvvoYiJ+zIPHklsewL
OOvyfiDiSvjdiQUWWJkcMmQelYcZ5yQrKHHYWiW/5h2Z6pw54tibD+Whzyo7MLwD
tJjU0hyryirm+89QZshF
=USWJ
-----END PGP SIGNATURE-----

--rCb8EA+9TsBVtA92--
