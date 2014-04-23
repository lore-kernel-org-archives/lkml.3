Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154AbaDWNpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:45:43 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:47988 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851AbaDWNpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:45:38 -0400
Message-ID: <5357C3FC.5020501@monstr.eu>
Date: Wed, 23 Apr 2014 15:45:32 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 17/21] of/fdt: introduce of_get_flat_dt_size
References: <1398215901-25609-1-git-send-email-robherring2@gmail.com> <1398215901-25609-18-git-send-email-robherring2@gmail.com>
In-Reply-To: <1398215901-25609-18-git-send-email-robherring2@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="3J2bVK1p3xU8pq4RROhJnKThfChBHoVAv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3J2bVK1p3xU8pq4RROhJnKThfChBHoVAv
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/23/2014 03:18 AM, Rob Herring wrote:
> From: Rob Herring <robh@kernel.org>
>=20
> Add a wrapper function to retrieve the FDT size from the FDT header. Th=
is
> is primarily to avoid libfdt include paths for the whole kernel.
>=20
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> v2: new patch
>=20
>  drivers/of/fdt.c       | 8 ++++++++
>  include/linux/of_fdt.h | 1 +
>  2 files changed, 9 insertions(+)
>=20
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index d9e6450..358bcf0 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -554,6 +554,14 @@ unsigned long __init of_get_flat_dt_root(void)
>  }
> =20
>  /**
> + * of_get_flat_dt_size - Return the total size of the FDT
> + */

It looks like that you are trying to use kernel-doc format
but I believe this will caused kernel-doc warning.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--3J2bVK1p3xU8pq4RROhJnKThfChBHoVAv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNXw/0ACgkQykllyylKDCHY7ACgmQZh8up/hvkdAn69igCkKfZ2
XRYAn3/x8njeA0wc3ABp8+N829Si9QIu
=HTyK
-----END PGP SIGNATURE-----

--3J2bVK1p3xU8pq4RROhJnKThfChBHoVAv--
