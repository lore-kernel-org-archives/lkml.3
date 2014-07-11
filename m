Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbaGKNFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:05:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33142 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbaGKNFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:05:08 -0400
Date: Fri, 11 Jul 2014 15:04:57 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: Fix typoed ams,ext-control properties
Message-ID: <20140711130456.GB10827@ulmo>
References: <1404931997-7118-1-git-send-email-ttynkkynen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dTy3Mrz/UPE2dbVg"
Content-Disposition: inline
In-Reply-To: <1404931997-7118-1-git-send-email-ttynkkynen@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 09, 2014 at 09:53:17PM +0300, Tuomas Tynkkynen wrote:
> The property for enabling external rail control on the AS3722 is
> ams,ext-control, not ams,external-control. Since the external rail
> control property was previously being ignored, LP1 suspend on these
> boards wasn't actually turning the CPU rail off at all.
>=20
> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
> ---
> So here's a dilemma, either change the existing DTs, change the
> binding + driver, or make the driver recognize both properties.
> I chose the first one since the old behaviour was broken in the
> first place and the old DTs stay as buggy as they were before.
>=20
>  arch/arm/boot/dts/tegra124-jetson-tk1.dts | 6 +++---
>  arch/arm/boot/dts/tegra124-venice2.dts    | 6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)

Applied to the for-3.17/dt branch. Thanks.

Thierry

--dTy3Mrz/UPE2dbVg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTv+D4AAoJEN0jrNd/PrOhJ74P+gMFmAwPpZIOKH2Or2vKvh7i
dLO6/M30XCr8yQ+EULdwxpgwxrSJ1lrAlIOSjI/CR6xUrQn8XXeuCizUpUY2Pqof
UBQ7UM2igY/1uKu6vQJ0a8ZDR6Zo1u7V3JDzivIWckspYeJK1DqqZNL64cOKqcDb
RTPQ0XPtjvH3/yg97dEROpHljRcVzSyR3Q+rzbWw/qvryJkESWvqdk/dANVSiSYM
w9hodE684qZul9igSWvOaGzIuWJvYnrIOAn3z3yx4YxpakvbNi71OTU832bpWzG3
PXQscQzEOAj85EFFcxjaSCdwECdjqNEwhWeiiJYxpfZ3rj6LU3GxPHO+0eH7dh0s
7xI/zjHQ+Rn6Z1JSFwLyoEMA+5v25kitMozjgsAAwPfFAsfjl/bYAc1YbsrhY0Jz
i2BVHtPNAydDIbKBlvlqEsRsAGphcz+AuunklKZdJYsnLCYWY6G5ZYIXKmZ0a2aV
CmfeYCaWWYDMoB7V/1yB2uupA7N8KDlXSumD4h0fmoKQCjanFvBL0dZjqHEVWtOK
00S3fNd4AI4Wgpfr9Rk+P6yfr7TXo5POO9V1PoLuGoiXHgV/NE0i3EC94bgxRZLi
AOMEtS1JiLKdIdHwC1QGkoV1jNtAQiAJtHhAD1RwZ378TC9Ec1k19IXWrDiccgkx
k1H4prJcX2jLxLkY5nfi
=c9Ag
-----END PGP SIGNATURE-----

--dTy3Mrz/UPE2dbVg--
