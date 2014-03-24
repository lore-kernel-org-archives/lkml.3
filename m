Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbaCXWPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 18:15:06 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38596 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaCXWPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 18:15:03 -0400
Date: Mon, 24 Mar 2014 23:14:59 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: Re: [PATCH 05/12] drm/nouveau/fifo: add GK20A support
Message-ID: <20140324221457.GE17218@mithrandir>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
 <1395650554-31925-6-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3O1VwFp74L81IIeR"
Content-Disposition: inline
In-Reply-To: <1395650554-31925-6-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3O1VwFp74L81IIeR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 24, 2014 at 05:42:27PM +0900, Alexandre Courbot wrote:
> GK20A's FIFO is compatible with NVE0, but only features 128 channels and
> 1 runlist.
>=20
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/gpu/drm/nouveau/Makefile                   |  1 +
>  drivers/gpu/drm/nouveau/core/engine/fifo/nve0.h    |  1 +
>  drivers/gpu/drm/nouveau/core/engine/fifo/nvea.c    | 35 ++++++++++++++++=
++++++
>  drivers/gpu/drm/nouveau/core/include/engine/fifo.h |  1 +
>  4 files changed, 38 insertions(+)
>  create mode 100644 drivers/gpu/drm/nouveau/core/engine/fifo/nvea.c

Looks good to me:

Reviewed-by: Thierry Reding <treding@nvidia.com>

--3O1VwFp74L81IIeR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTMK5hAAoJEN0jrNd/PrOhGDoP/0pgl3HDKM0+XYJVa8Eum5Jf
hPoM7RHtn7CGjaTKF9lhlngWiovM0tEPKH8sb1NoNoPWE+T+4hBuGHrFr07x2zdQ
v9R1YIddeEefc6sL7JWpC1MSNNUqySEA0MgO1S/iT4WMUmvB0AoJHZ5XGo2j2lV/
Cr89JvkrXsmu/h9tTXB1EHaAAbGAPidDoY2a1t/kFt8J9fHXft0ucN7UIBqyEXgY
VYIG3GHSEgjoneictNnAcCRn7pL7MhiimkuuZjkHpaoyfEYAdddhsBjHdwNiAkp4
CvsvIgE739IVopLONXFR8c694TA/PxMPTXR+OnHIGOlJ/MvxDtRvF6O4A+VyNY2p
IjPzrFQQ8rlcpnBIs6fCj80W5zxsNZdSOAesyQByQss3EVZ+/CIduKVMh19Daikn
n/Q0L8liB4fxGP2pG6+hlavnqRVmyOp9ogG4t6pOeDWaPQZej16V2l0drXhi7jP+
fw77+M6fhaTcxMW1/xHApQloXUOqZGaejaOGO5RKHomkR5dlMkoM63klf+kIfBAr
+ICD0WxmeM3n90nbwW/2pRzum+MhfBCwYNmuUu4shz2+FyXu2hpmcU87hyXojlj+
60v/cqQw7VBpuI4nD0hm731u5wuHLrol6TyvUeZnnLB40tHihQmX08/RoiIhf4bZ
oE2iLTpAisDEkdpfE6wK
=SOCw
-----END PGP SIGNATURE-----

--3O1VwFp74L81IIeR--
