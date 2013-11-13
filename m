Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236Ab3KMKCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 05:02:21 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:54136 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758878Ab3KMKCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 05:02:18 -0500
Message-ID: <52834E25.1040201@monstr.eu>
Date: Wed, 13 Nov 2013 11:02:13 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] microblaze: Wire up defconfig to mmu_defconfig
References: <1384284164-12777-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1384284164-12777-1-git-send-email-geert@linux-m68k.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="dRbjXp1cnG9bN8M2l7KhrdvpwLvnlSEV8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dRbjXp1cnG9bN8M2l7KhrdvpwLvnlSEV8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/12/2013 08:22 PM, Geert Uytterhoeven wrote:
> Without this, "make defconfig" fails with
>=20
> *** Can't find default configuration "arch/microblaze/defconfig"!
>=20
> All other architectures either set KBUILD_DEFCONFIG, or provide
> arch/*/defconfig.
>=20
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  arch/microblaze/Makefile |    2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/arch/microblaze/Makefile b/arch/microblaze/Makefile
> index 40350a3c24e9..a69eaf2ab130 100644
> --- a/arch/microblaze/Makefile
> +++ b/arch/microblaze/Makefile
> @@ -1,3 +1,5 @@
> +KBUILD_DEFCONFIG :=3D mmu_defconfig
> +
>  ifeq ($(CONFIG_MMU),y)
>  UTS_SYSNAME =3D -DUTS_SYSNAME=3D\"Linux\"
>  else
>=20

Applied.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--dRbjXp1cnG9bN8M2l7KhrdvpwLvnlSEV8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlKDTiUACgkQykllyylKDCEovgCfY9VxBlkJNjQ8kD/pr28FUqH/
TasAnjci31YBjEHtz9L078bbPF4oUOWB
=cNtA
-----END PGP SIGNATURE-----

--dRbjXp1cnG9bN8M2l7KhrdvpwLvnlSEV8--
