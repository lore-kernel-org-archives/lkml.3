Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424AbaDVNxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:53:24 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:34250 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbaDVNxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:53:15 -0400
Message-ID: <53567445.6080909@monstr.eu>
Date: Tue, 22 Apr 2014 15:53:09 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
        dhowells@redhat.com, broonie@linaro.org, benh@kernel.crashing.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 02/18] microblaze: io: remove dummy relaxed accessor macros
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com> <1397742261-15621-3-git-send-email-will.deacon@arm.com>
In-Reply-To: <1397742261-15621-3-git-send-email-will.deacon@arm.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="is7qvWBUfthW23kAviq3HpW74RLXUTjhm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--is7qvWBUfthW23kAviq3HpW74RLXUTjhm
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/17/2014 03:44 PM, Will Deacon wrote:
> These are now defined by asm-generic/io.h, so we don't need the private=

> definitions anymore.
>=20
> Cc: Michal Simek <monstr@monstr.eu>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  arch/microblaze/include/asm/io.h | 8 --------
>  1 file changed, 8 deletions(-)
>=20
> diff --git a/arch/microblaze/include/asm/io.h b/arch/microblaze/include=
/asm/io.h
> index 1e4c3329f62e..2987fd4c73d6 100644
> --- a/arch/microblaze/include/asm/io.h
> +++ b/arch/microblaze/include/asm/io.h
> @@ -72,12 +72,4 @@ extern void __iomem *ioremap(phys_addr_t address, un=
signed long size);
> =20
>  #include <asm-generic/io.h>
> =20
> -#define readb_relaxed	readb
> -#define readw_relaxed	readw
> -#define readl_relaxed	readl
> -
> -#define writeb_relaxed	writeb
> -#define writew_relaxed	writew
> -#define writel_relaxed	writel
> -
>  #endif /* _ASM_MICROBLAZE_IO_H */
>=20

Acked-by: Michal Simek <monstr@monstr.eu>

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--is7qvWBUfthW23kAviq3HpW74RLXUTjhm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNWdEUACgkQykllyylKDCEmbgCgnDgZ/ahyF2awb3ZjrolE4T8J
QIoAoIJBSaPpprlBLBcwE7lGNvcyyFsV
=iUNn
-----END PGP SIGNATURE-----

--is7qvWBUfthW23kAviq3HpW74RLXUTjhm--
