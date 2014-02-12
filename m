Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbaBLKNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:13:54 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:39935 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaBLKNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:13:49 -0500
Date: Wed, 12 Feb 2014 11:13:34 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        David Airlie <airlied@linux.ie>,
        Stephen Warren <swarren@wwwdotorg.org>,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/tegra: fix typo 'CONFIG_TEGRA_DRM_FBDEV'
Message-ID: <20140212101333.GB3409@ulmo.nvidia.com>
References: <1391950893.20670.2.camel@x220>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Content-Disposition: inline
In-Reply-To: <1391950893.20670.2.camel@x220>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 09, 2014 at 02:01:33PM +0100, Paul Bolle wrote:
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Entirely untested. But it's clear that this is what was intended.
>=20
>  drivers/gpu/drm/tegra/drm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks!

Thierry

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+0lNAAoJEN0jrNd/PrOhZW4P/3EA9j2N5IfW1v1duKjdiaSB
b2cGsw8xCZBEid0zJYICuX0VcL9fSMKZUW65bubUPBoeMmJlZnwuiTf8UTO25LC9
HTa9AKIGTwacFuc5g7BKGaS8u+8x6R2j21oUMQRUi0UlHeh35/9NYmeW5RarVgdD
oDzPSx02+qwIl5y1n/f/Rm6x1knb7d4zKpMqNyYpU3xFyl7fNg+4siSBwSCDlnBo
xE9HYHfoURAahgOTXV+NIxLSdyEWcO8weXB06zg8Crt3FMpyueMJFOQ2OeUeWuF3
7vuvRcDpk5ckZO7nyOTKx8hlEt6i54iUqSR6GqlYCX/Q/yTnv35sBElRjVnNVODq
sbGt8pP1wRkEbZq3LRdYimoIq43EtFd4xjMgdyBLNQLAPJHwZUa2W3axxbkO08WE
MGACl4IO9d0TOZPEdaFXPi+C2FHXIm+WyZd2m/6sVKsskPsKSOcuNBVbow9KEkoE
yI+6D40TySbuDIPhYzh9J/vrIQPDbrnTAUIqMVVwEOJ/fK8ohw15S+ISWN/6PXhe
XvTg1e1pYZfNY/wkp/o+8Hy2i2tTwWwQFESrKStiDgx758WuGVOMndOf60kpRupM
uqSdzrMDA0cZQi2aoUHrV1NSERSM+IqnlzJsMHIGQpt01avsxoS0p4vHe46WBji1
1eJLvCD22Uy8pMXS24iR
=zBpF
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--
