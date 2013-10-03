Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab3JCWJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 18:09:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35134 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453Ab3JCWJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 18:09:07 -0400
Message-ID: <524DEAED.4030905@ti.com>
Date: Thu, 3 Oct 2013 18:08:45 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Lukasz Majewski <l.majewski@samsung.com>
CC: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, <devicetree@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 4/6] thermal: exynos: Replace SOC_ARCH_EXYNOS with SOC_ARCH_EXYNOS5250
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com> <1380010102-25817-5-git-send-email-l.majewski@samsung.com>
In-Reply-To: <1380010102-25817-5-git-send-email-l.majewski@samsung.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="V8GaVGtHSjeacEeEBNBxR66VnrkDC7eFq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--V8GaVGtHSjeacEeEBNBxR66VnrkDC7eFq
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 24-09-2013 04:08, Lukasz Majewski wrote:
> The TMU data definition is now separated to Exynos4412 and Exynos5250.
>=20
> Now SOC_ARCH_EXYNOS only refers to Exynos5250. Hence the name
> SOC_ARCH_EXYNOS has been changed to SOC_ARCH_EXYNOS5250.
>=20

How about merging this one with patch 02?

> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> ---
>  drivers/thermal/samsung/exynos_tmu.c      |    4 ++--
>  drivers/thermal/samsung/exynos_tmu.h      |    2 +-
>  drivers/thermal/samsung/exynos_tmu_data.c |    2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index 21b89e4..037cd46 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -632,9 +632,9 @@ static int exynos_tmu_probe(struct platform_device =
*pdev)
>  	if (ret)
>  		return ret;
> =20
> -	if (pdata->type =3D=3D SOC_ARCH_EXYNOS ||
> -	    pdata->type =3D=3D SOC_ARCH_EXYNOS4210 ||
> +	if (pdata->type =3D=3D SOC_ARCH_EXYNOS4210 ||
>  	    pdata->type =3D=3D SOC_ARCH_EXYNOS4412 ||
> +	    pdata->type =3D=3D SOC_ARCH_EXYNOS5250 ||
>  	    pdata->type =3D=3D SOC_ARCH_EXYNOS5440)
>  		data->soc =3D pdata->type;
>  	else {
> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/sam=
sung/exynos_tmu.h
> index db37df0..b42ece4 100644
> --- a/drivers/thermal/samsung/exynos_tmu.h
> +++ b/drivers/thermal/samsung/exynos_tmu.h
> @@ -42,7 +42,7 @@ enum calibration_mode {
>  enum soc_type {
>  	SOC_ARCH_EXYNOS4210 =3D 1,
>  	SOC_ARCH_EXYNOS4412,
> -	SOC_ARCH_EXYNOS,
> +	SOC_ARCH_EXYNOS5250,
>  	SOC_ARCH_EXYNOS5440,
>  };
> =20
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/therma=
l/samsung/exynos_tmu_data.c
> index bd08093..188223f 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -183,7 +183,7 @@ struct exynos_tmu_init_data const exynos4412_defaul=
t_tmu_data =3D {
>  struct exynos_tmu_init_data const exynos5250_default_tmu_data =3D {
>  	.tmu_data =3D {
>  		{ EXYNOS4412_TMU_DATA,
> -		.type =3D SOC_ARCH_EXYNOS,
> +		.type =3D SOC_ARCH_EXYNOS5250,
>  		},
>  	},
>  	.tmu_count =3D 1,
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--V8GaVGtHSjeacEeEBNBxR66VnrkDC7eFq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJN6vAACgkQCXcVR3XQvP2zOAD+KHplqiVgYO/xoivdybLo7bRc
iyf16hw1pQan8fN1KJoA/jbk+7ABAF7565vSu1XVjl4TPxfDNbeKYJ5TN99JOVEw
=MhCh
-----END PGP SIGNATURE-----

--V8GaVGtHSjeacEeEBNBxR66VnrkDC7eFq--
