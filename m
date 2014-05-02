Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaEBLhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 07:37:36 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:53034 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbaEBLhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 07:37:35 -0400
Date: Fri, 2 May 2014 13:35:51 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: David Airlie <airlied@linux.ie>, gnurou@gmail.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/ttm: remove declaration of ttm_tt_cache_flush
Message-ID: <20140502113550.GB18693@ulmo>
References: <1399024162-6528-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6sX45UoQRIJXqkqR"
Content-Disposition: inline
In-Reply-To: <1399024162-6528-1-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 02, 2014 at 06:49:22PM +0900, Alexandre Courbot wrote:
> ttm_tt_cache_flush's implementation was removed in 2009 by commit
> c9c97b8c, but its declaration has been hiding in ttm_bo_driver.h since
> then.
>=20
> It has been surviving in the dark for too long now ; give it the coup
> de gr=C3=A2ce.
>=20
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  include/drm/ttm/ttm_bo_driver.h | 12 ------------
>  1 file changed, 12 deletions(-)

Reviewed-by: Thierry Reding <treding@nvidia.com>

--6sX45UoQRIJXqkqR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTY4MWAAoJEN0jrNd/PrOh52AQAKEfe57pYldOgkvrnjKmBexG
41etB1x5bD+tAqW65jf0iQLgvkgHEkrHo29NALcpyyKPL+KQUhu9Grryg8mIwpdA
PxNbU4RYWdyKt5VX8kVTW3uRCuGwrkUEm9FpXSr9M0WjzWvJgYcMaI1SJHs5OGMw
YtZCXbipSht6EyvH33Uwe7e0dA1wnkzWs6DhqWCtBqhchdL7EhJOWiYdv2/HjzKB
wthHW1yVzbz+S3iUJyWBqh855YmW3pYCKr6j7RtNfVxNepZVdlcSbzyclKAPQ4s2
GhjHF5fXmCiKI4cg7ZvUIW4TCiS+m/4fo7Xomymup88i10kjfZfSjgPmHLWG2lyU
8AB4guAZ/kJYxvNHyhVDpFsto0r8Izu7Qg0RXqI0va/xod7kLF5zn9DmifUgQgbj
RrLKOlHSXT8aFruThOhgiyolFZm9Izqph2SV+vz3haZrS4OpDDUKdgTjVGVoszMK
R/jwYyOkQJ48qgjNL0ab2Wzn+v3iLS053VLZ+guJGyas2gHv/YUeZBA3ZkpogCh1
KGxjfvJfeRIQwgcR9VjJ0et/g9gm/zut8q1zKVuRlnh217V7Ey1GlESr8+V3Fp+4
PTqCHBggX6ShL4kAnXzL6FmgVWEhvCfdfeSH8lkv5KEdkbdOz2qs6okHjjCyV64U
CDtZidLSRnY/BjBMCo1B
=+DfA
-----END PGP SIGNATURE-----

--6sX45UoQRIJXqkqR--
