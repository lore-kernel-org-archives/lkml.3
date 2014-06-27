Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbaF0ISu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 04:18:50 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:39388 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbaF0ISr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 04:18:47 -0400
Date: Fri, 27 Jun 2014 10:18:44 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu: Constify struct iommu_ops
Message-ID: <20140627081844.GA10835@ulmo>
References: <1403809494-31432-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <1403809494-31432-1-git-send-email-thierry.reding@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 26, 2014 at 09:04:54PM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>=20
> This structure is read-only data and should never be modified.
>=20
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/iommu/amd_iommu.c       |  4 ++--
>  drivers/iommu/arm-smmu.c        |  2 +-
>  drivers/iommu/exynos-iommu.c    |  2 +-
>  drivers/iommu/fsl_pamu_domain.c |  2 +-
>  drivers/iommu/intel-iommu.c     |  4 ++--
>  drivers/iommu/iommu.c           | 19 ++++++++++++++-----
>  drivers/iommu/ipmmu-vmsa.c      |  2 +-
>  drivers/iommu/msm_iommu.c       |  2 +-
>  drivers/iommu/omap-iommu.c      |  2 +-
>  drivers/iommu/shmobile-iommu.c  |  2 +-
>  drivers/iommu/tegra-gart.c      |  2 +-
>  drivers/iommu/tegra-smmu.c      |  2 +-
>  include/linux/iommu.h           |  4 ++--
>  13 files changed, 29 insertions(+), 20 deletions(-)

I noticed that this patch is missing a hunk to include/linux/device.h
and I've sent a v2 to address this. Apologies for the noise.

Thierry

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTrSjkAAoJEN0jrNd/PrOheW4QAI5fiSMIn1dMUzE3mYFP4OMu
R5zlK+Yr3E2PQdNfgp0It9sxA/RjXo0GVGMLVKw7wtDVLb3AOyBoKvYzj7oVu9TJ
PjFTlTJo3zMukjjAKXlPgE3DP9IUI0le7tzdOaBqrqt2edBgYb6LaLDg43Su32/h
UmZijdFxEiiq8YEyqpQMibYjznKE//XwLtecynyhDRkiGdZc/pisnUxtW2EU5kZr
Pf+owBsMS8ua4SsR7SPYy3EZBcc0VascYwkQUOEXbsBRjmjkAKfWEIQyHfaHNZtm
EbTELeCIjxQ5Am/O2C2OBlNZ+TAOgQ5Myu7a09M5YJTLOm974Fr++2Liw0fUGNb3
4YMVJ6dmWBa1l342yR+wTVeeBkoWurIbvvGpTlEbwpMosP0HkQSGcTtxCnx2vMcT
4SJLS/HmkAeKI4b88E/VUvc4YsRUXW+HGvu2RlirFkfu4ZsD1R4lqRbv6MztY72H
TXPyf21sybdnW8Y4LiwI+gwxIhnMfJN7hwFOKBVi+taLwnGsD1bmen5r6vNBlKUx
pl+/cXU54QLPfI2U/BLi3Z7VToDBVQOSufaB2lPajzi9sTLIh9N7+ES6q3TH9JsK
vhODDx3JlqabA6SuNcQglfA1bB1faE79eJfj31roaa+bqJNlOQG7O4ZD7CQGbRfJ
EipwOH90UoomyvXozCWY
=M3e9
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
