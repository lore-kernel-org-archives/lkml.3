Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaCYD7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 23:59:51 -0400
Received: from ozlabs.org ([203.10.76.45]:45658 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbaCYD7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 23:59:50 -0400
Date: Tue, 25 Mar 2014 14:59:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>, Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Paul <seanpaul@chromium.org>, Inki Dae <daeinki@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Subject: linux-next: manual merge of the omap_dss2 tree with the drm tree
Message-Id: <20140325145943.397eee136ee8326fef8a9fa2@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Mar_2014_14_59_43_+1100_Xnp3MHZo3qt0II+7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Mar_2014_14_59_43_+1100_Xnp3MHZo3qt0II+7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tomi,

Today's linux-next merge of the omap_dss2 tree got a conflict in
drivers/video/fbdev/exynos/Kconfig between commit 2e4e678aa8a4
("drm/exynos: Move dp driver from video/ to drm/") from the drm tree and
commits 07e521b66cf0 ("video: exynos: Remove OF dependency for Exynos
DP") and 844901baede6 ("video: move fbdev to drivers/video/fbdev") from
the omap_dss2 tree.

git said this:

CONFLICT (rename/rename): Rename "drivers/video/exynos/exynos_dp_reg.h"->"d=
rivers/gpu/drm/exynos/exynos_dp_reg.h" in branch "HEAD" rename "drivers/vid=
eo/exynos/exynos_dp_reg.h"->"drivers/video/fbdev/exynos/exynos_dp_reg.h" in=
 "omap_dss2/for-next"
CONFLICT (rename/rename): Rename "drivers/video/exynos/exynos_dp_reg.c"->"d=
rivers/gpu/drm/exynos/exynos_dp_reg.c" in branch "HEAD" rename "drivers/vid=
eo/exynos/exynos_dp_reg.c"->"drivers/video/fbdev/exynos/exynos_dp_reg.c" in=
 "omap_dss2/for-next"
CONFLICT (rename/rename): Rename "drivers/video/exynos/exynos_dp_core.h"->"=
drivers/gpu/drm/exynos/exynos_dp_core.h" in branch "HEAD" rename "drivers/v=
ideo/exynos/exynos_dp_core.h"->"drivers/video/fbdev/exynos/exynos_dp_core.h=
" in "omap_dss2/for-next"
CONFLICT (rename/rename): Rename "drivers/video/exynos/exynos_dp_core.c"->"=
drivers/gpu/drm/exynos/exynos_dp_core.c" in branch "HEAD" rename "drivers/v=
ideo/exynos/exynos_dp_core.c"->"drivers/video/fbdev/exynos/exynos_dp_core.c=
" in "omap_dss2/for-next"

I fixed it up and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__25_Mar_2014_14_59_43_+1100_Xnp3MHZo3qt0II+7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTMP80AAoJEMDTa8Ir7ZwVKVYP/2M/uPmABfXX1XT/3VQ2nyw4
gaElpDTiRRKY22SI/5uOxUHg0tC3fAgy1U6zCko/ccr2Jw9CvRhIuzDhWL8o4rdJ
vdpda+SzxEAD9ZqcV7KbDs9aRZgGC1uHwzAEpSE4gAWTo5C1bhPtOqf4d84IlLGn
6q29Hj/Zg/gV4HjJDMW2ViboAJWytQRG9pxKweBgO74UIrn1st/OWRdA2NqAQnZq
T9UCNnmCVfCsyCDU9ipgq0cm1AT1vABSfQ2RA/SreCFkmPZUxMKpDaNnZj5RjLMm
qlkm4U9gKCfMrozkR3IF+7cRu3g36iHfYwdSloIAIL/84y6p5pymhWhyp8aN6gTd
/25N5NWN2uPZqRLr33I+nJWXaKN2SNELzgmGcm0q6KIXGVYemH6Kp8+2gygPWrBL
zc6nxvXSAznYmjSUtlNl6fAtHy2EJqMh8F3uZAMomeYJHvxMRihzwspmKF2/x0Lo
KaMFwhxaEOvo79nrwU/yJnn1/gpHpSO6W0Uzex6THFEUn4DOsjA8pgKlod+C7joK
At0SvtgJ9qz92RtJh8K2y/j37vC/GZIwgqF79/Ee3LuPQ/QeCadyml2EDH13uffe
oBfFqxNyRnMbkQ1livXNf5hhAay59kXz4jLwWDDwG8PZVpzWtWi1nLfYsuyk3vKr
ZahAPEQEgVzhwyJwZh5h
=6Cqr
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Mar_2014_14_59_43_+1100_Xnp3MHZo3qt0II+7--
