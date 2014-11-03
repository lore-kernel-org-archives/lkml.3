Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaKCP5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:57:33 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35642 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaKCP53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:57:29 -0500
Date: Mon, 3 Nov 2014 15:56:01 +0000
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141103155601.GV3815@sirena.org.uk>
References: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk>
 <1415025649-8119-9-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l5oECiFRo5dp+2y7"
Content-Disposition: inline
In-Reply-To: <1415025649-8119-9-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 08/14] regulator: max8660: zero-initialize regulator
 match table array
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--l5oECiFRo5dp+2y7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 03, 2014 at 03:40:43PM +0100, Javier Martinez Canillas wrote:
> The struct of_regulator_match rmatch[] is declared as a non-static local
> variable so the structure members are not auto-initialized.

Applied, thanks.

--l5oECiFRo5dp+2y7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUV6WRAAoJECTWi3JdVIfQY+4H/j9IrdOyzL6MI9zx0tDixLWi
rwq2UUEu6cA605kV2yHMXiQpi/HfTw4vEInaSt5MuqtGFRYevTNmc1L97dA0sL41
/5m/SREpXmLd8gzmIeJiAhnweq3DDcBqO8rVw4UHqLi6apLVO1j3rF4LclekTLrF
OoMJHLGpiIKGP8AA5THVlwe4vNEpAHITuASt1xW4EFa+fKK7lKcBUWXXM6btl5gx
QuI2NX90bHb3MnnE0SkhXm+GDWENvMUPrpdf4nl5gESOXczzWkpXpDFVASKl970V
YX/j6EaLtLGcl69611WRAFxtJ5AFgxBTztaqPFFrYrgLYy+ijs9KeN5xND+m59w=
=gf3d
-----END PGP SIGNATURE-----

--l5oECiFRo5dp+2y7--
