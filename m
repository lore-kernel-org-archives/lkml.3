Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab3IINMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:12:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35520 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab3IINMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:12:53 -0400
Message-ID: <522DC944.80802@ti.com>
Date: Mon, 9 Sep 2013 09:12:36 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Regid Ichira <regid23@nt1.in>
CC: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] typo in drivers/thermal/Kconfig: lpatform instead of
 platform
References: <20130908215853.GD8821@nt1.in>
In-Reply-To: <20130908215853.GD8821@nt1.in>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="4uQTpUQIIEwSiOcpbiG4jweQDlUCenagu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4uQTpUQIIEwSiOcpbiG4jweQDlUCenagu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08-09-2013 17:58, Regid Ichira wrote:
> Applied to the HEAD of linux.git,
>                        VERSION =3D 3 PATCHLEVEL =3D 11 SUBLEVEL =3D 0
> Signed-off-by: Regid Ichira <regid23@nt1.in>

Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

> ---
>  drivers/thermal/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index e988c81..3f99f79 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -47,7 +47,7 @@ config THERMAL_DEFAULT_GOV_USER_SPACE
>  	select THERMAL_GOV_USER_SPACE
>  	help
>  	  Select this if you want to let the user space manage the
> -	  lpatform thermals.
> +	  platform thermals.
> =20
>  endchoice
> =20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--4uQTpUQIIEwSiOcpbiG4jweQDlUCenagu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlItyU0ACgkQCXcVR3XQvP3tiwD+PR2QkwFSEajaklUzzwOnbhh8
t4x7hc33ycSsMOecwTYA/jPj3BMooALrMS6xHBw2KT6jKXPyAD+kxfPmqDabuINO
=tJcI
-----END PGP SIGNATURE-----

--4uQTpUQIIEwSiOcpbiG4jweQDlUCenagu--
