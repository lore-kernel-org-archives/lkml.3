Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583AbaJOW7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 18:59:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:52545 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbaJOW7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 18:59:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="asc'?scan'208";a="400939844"
Message-ID: <1413413961.2412.40.camel@jtkirshe-mobl>
Subject: Re: [PATCH v2] bcm/CmHost.c: Fix noisy compile warnings
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: gregkh@linuxfoundation.org
Cc: Fabio Estevam <fabio.estevam@freescale.com>, linux-kernel@vger.kernel.org,
        mail@beyermatthias.de, devel@driverdev.osuosl.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Joe Perches <joe@perches.com>
Date: Wed, 15 Oct 2014 15:59:21 -0700
In-Reply-To: <1413399701-4321-1-git-send-email-jeffrey.t.kirsher@intel.com>
References: <1413399701-4321-1-git-send-email-jeffrey.t.kirsher@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-niEHmbDkTaq35b0ZPtn6"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-niEHmbDkTaq35b0ZPtn6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-10-15 at 12:01 -0700, Jeff Kirsher wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>=20
> The Beceem WIMAX was generating compile warnings on 64bit machines,
> which were:
>=20
> drivers/staging/bcm/CmHost.c: In function =E2=80=98StoreCmControlResponse=
Message=E2=80=99:
> drivers/staging/bcm/CmHost.c:1503:3: warning: cast to pointer from intege=
r of different size [-Wint-to-pointer-cast]
>    (struct bcm_connect_mgr_params *) ntohl(
>    ^
> drivers/staging/bcm/CmHost.c:1546:3: warning: cast to pointer from intege=
r of different size [-Wint-to-pointer-cast]
>    (struct bcm_connect_mgr_params *) ntohl(
>    ^
> drivers/staging/bcm/CmHost.c:1564:3: warning: cast to pointer from intege=
r of different size [-Wint-to-pointer-cast]
>    (struct bcm_connect_mgr_params *) ntohl(
>=20
> This resolves the issue by preventing the driver to compile if CONFIG_64B=
IT
> is enabled, since the driver is known to be broken for 64 bit arch's.
>=20
> CC: Dan Carpenter <dan.carpenter@oracle.com>
> CC: Joe Perches <joe@perches.com>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Greg- I have also submitted a patch to remove this driver entirely.  So
if you choose to apply the patch to remove the driver, then you can
disregard this patch.

> ---
> v2: change fix from using typecast u64 in the code to altering Kconfig to
>     prevent the driver from compiling on 64 bit arch's based on feedback
>=20
>  drivers/staging/bcm/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/staging/bcm/Kconfig b/drivers/staging/bcm/Kconfig
> index 8acf4b2..273b328 100644
> --- a/drivers/staging/bcm/Kconfig
> +++ b/drivers/staging/bcm/Kconfig
> @@ -1,6 +1,6 @@
>  config BCM_WIMAX
>         tristate "Beceem BCS200/BCS220-3 and BCSM250 wimax support"
> -       depends on USB && NET
> +       depends on USB && NET && !64BIT
>         help
>           This is an experimental driver for the Beceem WIMAX chipset use=
d
>  	 by Sprint 4G.



--=-niEHmbDkTaq35b0ZPtn6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJUPvxJAAoJEOVv75VaS+3OT14P/3mAwK9G6IlN7bqspE+M7sRq
KBG66SzADOBwO7C0L8ouDf2l5/jpDOGaSG/UFykEq1IIkFFbf5TRii/6QmQlWFul
7zlZSVR01ddDwYCptUbvrg428th5sXC/rl8Wv4tm/dnhMnUHaE3HWD0JDYw6DqeA
5326Ldw76u9H61XiZTCYxL7dWW85CDDmklYK+lAki27ap++2V6HPjP0V7jnXzoch
E0QDQscLJhBOK+gwl97eb2+g/GY6eIUUOT3LOq8LW8rTUC4Ns49gF5csEs7Bebwt
5pDsCo7sb2NVfVgq3AUBgqU0YAF0OKTZTBQ8O96/TpRx4MGJV+S1HU3H8iLTo8b2
Z37NQOY8eP3UhRQBB6oyHIaICdd4UtnGREnM/dNMGjPuCIH+sU6qKT6drPjIG7cb
kAris2pTi7XGvzMboGNzS+g0Cyv1W8RqCcv5uhEgbovC79Nd7RtcY3RQcMuoEMWU
WVOu7nVf5d54vXqkPhXLHQUm8e3PguuhfWVI/7XHUnTs7AOyqGtPR/kTth45iFr3
1j/J5ziJy/fu14lMmI4RR28cU/92GGuGlYQnNGEOHy7TM9dmJQN7ccVa97fFMSb+
I+lxtFTDPRiyUsPGVhiZNgf/09aH1Cfwzyhby/6ZAjCnCoc3bDMWwQQg8M8Wk7N1
7o79ecXgfL8Eosd9a1N3
=O8Qz
-----END PGP SIGNATURE-----

--=-niEHmbDkTaq35b0ZPtn6--

