Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660AbaDBMCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 08:02:00 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:57001 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaDBMB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 08:01:58 -0400
Message-ID: <533BFC31.1080203@monstr.eu>
Date: Wed, 02 Apr 2014 14:01:53 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, chow.kim@samsung.com
Subject: Re: [PATCH 02/10] ARM: EXYNOS: Correct file path in comment message
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com> <1396425058-4012-3-git-send-email-pankaj.dubey@samsung.com>
In-Reply-To: <1396425058-4012-3-git-send-email-pankaj.dubey@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="W0HsbOSS1WjbcSkQ5wEcStirGctgTChIw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--W0HsbOSS1WjbcSkQ5wEcStirGctgTChIw
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 04/02/2014 09:50 AM, Pankaj Dubey wrote:
> This patch corrects file path mentioned in file comment message.
>=20
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>  arch/arm/mach-exynos/platsmp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/plat=
smp.c
> index 03e5e9f..d8d1555 100644
> --- a/arch/arm/mach-exynos/platsmp.c
> +++ b/arch/arm/mach-exynos/platsmp.c
> @@ -1,4 +1,4 @@
> -/* linux/arch/arm/mach-exynos4/platsmp.c
> +/* linux/arch/arm/mach-exynos/platsmp.c
>   *
>   * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
>   *		http://www.samsung.com
>=20

Shouldn't you just remove it entirely?
I had the same file names in the whole microblaze tree
and some months/years later this was just broken everywhere.
That's why it is just easier to remove it entirely.

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--W0HsbOSS1WjbcSkQ5wEcStirGctgTChIw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlM7/DEACgkQykllyylKDCHusQCfRCuGLq2KM+pbmifH9QH93JA2
wUUAnAp9z8EAcQoRaCfgz9ffaKU9MxYp
=UcXJ
-----END PGP SIGNATURE-----

--W0HsbOSS1WjbcSkQ5wEcStirGctgTChIw--
