Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab3EJPNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 11:13:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42152 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092Ab3EJPNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 11:13:07 -0400
Message-ID: <518D0E73.9040207@ti.com>
Date: Fri, 10 May 2013 11:12:51 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [PATCH V3 03/21] thermal: exynos: Rename exynos_thermal.c to
 exynos_tmu.c
References: <1367931671-3906-1-git-send-email-amit.daniel@samsung.com> <1367931671-3906-4-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1367931671-3906-4-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2OWHXNGATSMSPVIOFMABX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2OWHXNGATSMSPVIOFMABX
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07-05-2013 09:00, Amit Daniel Kachhap wrote:
> This patch renames exynos_thermal.c to exynos_tmu.c. This change is nee=
ded as
> this file now just contains exynos tmu driver related codes and thermal=
 zone
> or cpufreq cooling registration related changes are not there anymore.
>=20
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

This one looks fine to me.

Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

> ---
>  drivers/thermal/samsung/Makefile                   |    6 +++---
>  .../samsung/{exynos_thermal.c =3D> exynos_tmu.c}     |    2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
>  rename drivers/thermal/samsung/{exynos_thermal.c =3D> exynos_tmu.c} (9=
9%)
>=20
> diff --git a/drivers/thermal/samsung/Makefile b/drivers/thermal/samsung=
/Makefile
> index 6227d4f..22528d6 100644
> --- a/drivers/thermal/samsung/Makefile
> +++ b/drivers/thermal/samsung/Makefile
> @@ -1,6 +1,6 @@
>  #
>  # Samsung thermal specific Makefile
>  #
> -obj-$(CONFIG_EXYNOS_THERMAL)			+=3D exynos_soc_thermal.o
> -exynos_soc_thermal-y				:=3D exynos_thermal.o
> -exynos_soc_thermal-$(CONFIG_EXYNOS_THERMAL_CORE) +=3D exynos_thermal_c=
ommon.o
> +obj-$(CONFIG_EXYNOS_THERMAL)			+=3D exynos_thermal.o
> +exynos_thermal-y				:=3D exynos_tmu.o
> +exynos_thermal-$(CONFIG_EXYNOS_THERMAL_CORE)	+=3D exynos_thermal_commo=
n.o
> diff --git a/drivers/thermal/samsung/exynos_thermal.c b/drivers/thermal=
/samsung/exynos_tmu.c
> similarity index 99%
> rename from drivers/thermal/samsung/exynos_thermal.c
> rename to drivers/thermal/samsung/exynos_tmu.c
> index 4c85945..3de3e61 100644
> --- a/drivers/thermal/samsung/exynos_thermal.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -1,5 +1,5 @@
>  /*
> - * exynos_thermal.c - Samsung EXYNOS TMU (Thermal Management Unit)
> + * exynos_tmu.c - Samsung EXYNOS TMU (Thermal Management Unit)
>   *
>   *  Copyright (C) 2011 Samsung Electronics
>   *  Donggeun Kim <dg77.kim@samsung.com>
>=20



------enig2OWHXNGATSMSPVIOFMABX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGNDnMACgkQCXcVR3XQvP3cNQD/XSuRBKNYuRpnrwa8AjcwA5cl
xX+3gOem5LCywPtIICsBAKmY5eQz5NH8ibJTQ/Npy88Da61Qus7L1KWcPE/C/Hnc
=f28/
-----END PGP SIGNATURE-----

------enig2OWHXNGATSMSPVIOFMABX--
