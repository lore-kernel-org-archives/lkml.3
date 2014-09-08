Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaIHFUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 01:20:21 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:41763 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaIHFUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 01:20:13 -0400
Message-ID: <540D3C89.6080702@monstr.eu>
Date: Mon, 08 Sep 2014 07:20:09 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, stern@rowland.harvard.edu
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, michal.simek@xilinx.com,
        linux-usb@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/usb/host/ehci-xilinx-of.c: Include "linux/of_irq.h"
 to avoid compiling error
References: <540738C7.5000106@gmail.com>
In-Reply-To: <540738C7.5000106@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="KPtXgxPFgEtee3lVHGJj5DtXKWaviI7ph"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KPtXgxPFgEtee3lVHGJj5DtXKWaviI7ph
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/03/2014 05:50 PM, Chen Gang wrote:
> Need include it for irq_of_parse_and_map(), the related error with
> allmodconfig under microblaze:
>=20
>   drivers/usb/host/ehci-xilinx-of.c: In function =91ehci_hcd_xilinx_of_=
probe=92:
>   drivers/usb/host/ehci-xilinx-of.c:156:2: error: implicit declaration =
of function =91irq_of_parse_and_map=92 [-Werror=3Dimplicit-function-decla=
ration]
>     irq =3D irq_of_parse_and_map(dn, 0);
>     ^
>=20
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  drivers/usb/host/ehci-xilinx-of.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/usb/host/ehci-xilinx-of.c b/drivers/usb/host/ehci-=
xilinx-of.c
> index fe57710..a232836 100644
> --- a/drivers/usb/host/ehci-xilinx-of.c
> +++ b/drivers/usb/host/ehci-xilinx-of.c
> @@ -31,6 +31,7 @@
>  #include <linux/of.h>
>  #include <linux/of_platform.h>
>  #include <linux/of_address.h>
> +#include <linux/of_irq.h>
> =20
>  /**
>   * ehci_xilinx_port_handed_over - hand the port out if failed to enabl=
e it
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



--KPtXgxPFgEtee3lVHGJj5DtXKWaviI7ph
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlQNPIkACgkQykllyylKDCEmTQCcCW9uV0MwnDh1r0AmkzJVYlnu
I7oAn17yZvMUoaSR97Q82gBB6yv/3tbP
=x+ZM
-----END PGP SIGNATURE-----

--KPtXgxPFgEtee3lVHGJj5DtXKWaviI7ph--
