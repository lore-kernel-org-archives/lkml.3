Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbbAGKO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 05:14:27 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34223 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbbAGKOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 05:14:23 -0500
Message-ID: <54AD06FB.6070800@monstr.eu>
Date: Wed, 07 Jan 2015 11:14:19 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
CC: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Chen Gang <gang.chen.5i5j@gmail.com>
Subject: Re: [PATCH v2 28/40] microblaze: whitespace fix
References: <1420558883-10131-1-git-send-email-mst@redhat.com> <1420558883-10131-29-git-send-email-mst@redhat.com>
In-Reply-To: <1420558883-10131-29-git-send-email-mst@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="4gWoPVG5f4iU5Sr9loFpDwqnRfstQj3CO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4gWoPVG5f4iU5Sr9loFpDwqnRfstQj3CO
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/06/2015 04:45 PM, Michael S. Tsirkin wrote:
> Align using tabs to make code prettier.
>=20
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  arch/microblaze/include/asm/uaccess.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/microblaze/include/asm/uaccess.h b/arch/microblaze/in=
clude/asm/uaccess.h
> index e41bebf..62942fd 100644
> --- a/arch/microblaze/include/asm/uaccess.h
> +++ b/arch/microblaze/include/asm/uaccess.h
> @@ -306,7 +306,7 @@ extern long __user_bad(void);
> =20
>  #define __put_user_check(x, ptr, size)					\
>  ({									\
> -	typeof(*(ptr)) volatile __pu_val =3D x;					\
> +	typeof(*(ptr)) volatile __pu_val =3D x;				\
>  	typeof(*(ptr)) __user *__pu_addr =3D (ptr);			\
>  	int __pu_err =3D 0;						\
>  									\
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



--4gWoPVG5f4iU5Sr9loFpDwqnRfstQj3CO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlStBvsACgkQykllyylKDCHcnQCcDjtdGVQLUSO7422jDKh6MWxz
qeAAnAqjxN2cOOx4Sh11snlljapKa6ez
=6eIE
-----END PGP SIGNATURE-----

--4gWoPVG5f4iU5Sr9loFpDwqnRfstQj3CO--
