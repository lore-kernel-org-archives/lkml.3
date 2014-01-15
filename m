Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbaAOJPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 04:15:12 -0500
Received: from top.free-electrons.com ([176.31.233.9]:44046 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751286AbaAOJPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 04:15:07 -0500
Date: Wed, 15 Jan 2014 10:10:06 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Gerardo Di Iorio <arete74@gmail.com>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH] ARM: sunxi: change the AllWinner A1X to sunxi
Message-ID: <20140115091006.GF3377@lukather>
References: <20140109153404.GA21055@kvmhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JSkcQAAxhB1h8DcT"
Content-Disposition: inline
In-Reply-To: <20140109153404.GA21055@kvmhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JSkcQAAxhB1h8DcT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 09, 2014 at 04:34:04PM +0100, Gerardo Di Iorio wrote:
> Change the AllWinner A1X SOCs to Allwinner Sunxi SOCs
>=20
> Signed-off-by: Gerardo Di Iorio <arete74@gmail.com>
> ---
>  arch/arm/mach-sunxi/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/arm/mach-sunxi/Kconfig b/arch/arm/mach-sunxi/Kconfig
> index 547004c..adb2574 100644
> --- a/arch/arm/mach-sunxi/Kconfig
> +++ b/arch/arm/mach-sunxi/Kconfig
> @@ -1,5 +1,5 @@
>  config ARCH_SUNXI
> -       bool "Allwinner A1X SOCs" if ARCH_MULTI_V7
> +       bool "Allwinner Sunxi SOCs" if ARCH_MULTI_V7

I wonder if the sunxi (apart the weird letter case) is actually
needed. Maybe we can just put "Allwinner SoCs" (it would be great if
you could fix the SoCs case too).

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--JSkcQAAxhB1h8DcT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS1lBuAAoJEBx+YmzsjxAgzRkP/2MGd6L9TyFeWHObygsSAR3r
/O+o2/UZuncGWUhzqGk6KmvbNBMCV3N3kbCTIK/wvOGOz9hrUXuzJUg+HQn0n8oC
vwrtOH8c9dSC/oAwt121ZVe259y+LhIFaQRXlMSZi0m55pqs7qrftgKuL7c/J2U2
Mr5mkW+tT64xPCbyCz883IeYOWRv8+wX7vE6hMXssVD6hVN1D5foVkD6aDPTyd4W
QG3vylC+5UuZtXmGNzph3sSs+kjrXgYkpxXxs4QZDVpFi2HKWgQbl5NQKc2ILbVQ
3Vipjcz31Dq8D6K/6NOj0R7q7Dmc3YqLY7c07uFQ2uW2uq+p0SrybJ47igLFDhcY
94IQXnB7x6V5NAl8nkck8qemecU1t0/yx5jiRUfJFWv+T8woPwt4TvU4q80vsK8G
StVaPE1YhpTPE4kJ+YF3tmm+XWCvQ3saS0lnrXK75Qy1hWXZCLwtqshcFY8APpX6
YeKf2ss/kjD2WrvdCXNrCgDdKs8TKk6huMuiCNbAlfVyfmt6BeuIhgP9nccKYCF7
t9XJzlq1I1nh/TQM3Nq9Z26bfeMXOBcAqNbVx/p/l5OFrJfC9ArVoQ+Bb+gYYFkg
05wAe0cVy/2isl4mKPk51F5pzPC6Li2wmDWnfEVh/HDt3VW8IuqrPHZxp7iREpld
XCJkqsKVC4/b/KQMXB/r
=JHqy
-----END PGP SIGNATURE-----

--JSkcQAAxhB1h8DcT--
