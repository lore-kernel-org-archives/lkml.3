Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaJTSxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:53:48 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:49539 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbaJTSxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:53:47 -0400
Message-ID: <54455A32.9010005@monstr.eu>
Date: Mon, 20 Oct 2014 20:53:38 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: zynq: Actually remove hotplug.c
References: <1413391193-26710-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1413391193-26710-1-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="6M0mqavsTLuBiALhkLSQlSqH5gW3UwV9d"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6M0mqavsTLuBiALhkLSQlSqH5gW3UwV9d
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/15/2014 06:39 PM, Soren Brinkmann wrote:
> Commit 'ARM: zynq: Remove hotplug.c'
> (caf86a73eab4132f870e883216850d9eee40b04b) was supposed to remove
> hotplug.c - but it didn't. It moved all content from
> hotplug.c elsewhere and removed its entry from the Makefile, but missed=

> to actually remove the whole file. Remove it now.
>=20
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  arch/arm/mach-zynq/Makefile  |  2 --
>  arch/arm/mach-zynq/hotplug.c | 14 --------------
>  2 files changed, 16 deletions(-)
>  delete mode 100644 arch/arm/mach-zynq/hotplug.c
>=20
> diff --git a/arch/arm/mach-zynq/Makefile b/arch/arm/mach-zynq/Makefile
> index c85fb3f7d5cd..b03a97eb7501 100644
> --- a/arch/arm/mach-zynq/Makefile
> +++ b/arch/arm/mach-zynq/Makefile
> @@ -4,6 +4,4 @@
> =20
>  # Common support
>  obj-y				:=3D common.o slcr.o pm.o
> -CFLAGS_REMOVE_hotplug.o		=3D-march=3Darmv6k
> -CFLAGS_hotplug.o 		=3D-Wa,-march=3Darmv7-a -mcpu=3Dcortex-a9
>  obj-$(CONFIG_SMP)		+=3D headsmp.o platsmp.o
> diff --git a/arch/arm/mach-zynq/hotplug.c b/arch/arm/mach-zynq/hotplug.=
c
> deleted file mode 100644
> index b685c89f11e4..000000000000
> --- a/arch/arm/mach-zynq/hotplug.c
> +++ /dev/null
> @@ -1,14 +0,0 @@
> -/*
> - * Copyright (C) 2012-2013 Xilinx
> - *
> - * based on linux/arch/arm/mach-realview/hotplug.c
> - *
> - * Copyright (C) 2002 ARM Ltd.
> - * All Rights Reserved
> - *
> - * This program is free software; you can redistribute it and/or modif=
y
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - */
> -#include <asm/proc-fns.h>
> -
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



--6M0mqavsTLuBiALhkLSQlSqH5gW3UwV9d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlRFWjIACgkQykllyylKDCFaoACeMMbCn5jUqSWPggHlO/S1aB9Y
Vs0AmwQiZ22n1sIcO007a66hIG/ynrim
=mgW5
-----END PGP SIGNATURE-----

--6M0mqavsTLuBiALhkLSQlSqH5gW3UwV9d--
