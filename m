Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab3DPJNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 05:13:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36152 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab3DPJNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 05:13:20 -0400
Date: Tue, 16 Apr 2013 12:13:00 +0300
From: Felipe Balbi <balbi@ti.com>
To: Girish K S <girishks2000@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] ahci: sata: add support for exynos5440 sata
Message-ID: <20130416091300.GD25040@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1366103404-14105-1-git-send-email-ks.giri@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M38YqGLZlgb6RLPS"
Content-Disposition: inline
In-Reply-To: <1366103404-14105-1-git-send-email-ks.giri@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--M38YqGLZlgb6RLPS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Apr 16, 2013 at 02:40:04PM +0530, Girish K S wrote:
> This patch adds the compatible string of the exynos5440 sata controller
> compliant with the ahci 1.3 and sata 3.0 specification.
>=20
> Signed-off-by: Girish K S <ks.giri@samsung.com>
> ---
>  drivers/ata/ahci_platform.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
> index 7a8a284..c06f021 100644
> --- a/drivers/ata/ahci_platform.c
> +++ b/drivers/ata/ahci_platform.c
> @@ -327,6 +327,7 @@ static SIMPLE_DEV_PM_OPS(ahci_pm_ops, ahci_suspend, a=
hci_resume);
> =20
>  static const struct of_device_id ahci_of_match[] =3D {
>  	{ .compatible =3D "snps,spear-ahci", },
> +	{ .compatible =3D "samsung,exynos5440-ahci", },

is this an IP designed by samsung or something you licensed from e.g
snps ? If the latter you should add:

"snps,ahci"

instead. Right ?

--=20
balbi

--M38YqGLZlgb6RLPS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRbRYcAAoJEIaOsuA1yqREJNkP/1aBM28gY+rjyFnbY0zJn+Y4
TAFi9mRzNBGjdxfyot8arDVSB19tJ5sKUT8gejACJrGwnwMU3B5m//AemFdr6uKE
EVIMInmgkYPZ4n/yTB7WtKsAL/ktG+6Z0bTx/TI+khXhtAD7Vt4VCN6k3zVWqzlG
U8D8RJHvjICiUP3UehKWR+k2pRMTYLH26X+NLqoIAfma936iYUxTeFAAB6c9CDxS
3PkdSF1AK2Ix/Z8ofDmexO3NqUpPDeVGRzQrUW/mtNKXTG6pJWUfW4ss5sF2OFGP
WLv8aZg5N4oNw4/Mgt6zvxnjWAQ9WAR/FhgpwgwrGspMidOsPhlE2DPldVg3uGw2
5uayCOG8xGwWB1SA4M2nEsTLU8mnQ1oACEBX45WuILxQmgds5e9s0vy4wrgcATHB
RedOGFnWjlCimA794HhBrwKsSELZ2sisNwEmF4m4rk9kFQr1Cl1uCCKNezEoGiP3
WUqeZrEz6g+DJQx/aBJ94DMou0ScVp00uQO0Y0vcJvB8Cl8bLk9frqLpY/Q1+9nV
MN+lYB1hLdQivr6LJzM567TddEXYG4cR/55pblonPE4XRJBiBWOoBCvN0z3Y5yq7
crJKW+IdOe349YYY+2S+r4B8JkenUmW6r/O/gJxlfJxK+Tn2CHrW58ccvLzOKTrm
cmfM+Er9Ylt2Z1m3Bpmk
=DXl0
-----END PGP SIGNATURE-----

--M38YqGLZlgb6RLPS--
