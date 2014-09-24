Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaIXOu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:50:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59894 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006AbaIXOu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:50:57 -0400
Date: Wed, 24 Sep 2014 09:50:53 -0500
From: Felipe Balbi <balbi@ti.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        <linux-usb@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [resend PATCH 3/3] usb: dwc3: add ACPI support
Message-ID: <20140924145053.GC17997@saruman>
Reply-To: <balbi@ti.com>
References: <1411545639-18741-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1411545639-18741-4-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DIOMP1UsTsWJauNi"
Content-Disposition: inline
In-Reply-To: <1411545639-18741-4-git-send-email-heikki.krogerus@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--DIOMP1UsTsWJauNi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2014 at 11:00:39AM +0300, Heikki Krogerus wrote:
> Adds ACPI ID used on newer Intel SoCs.
>=20
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> ---
>  drivers/usb/dwc3/core.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index d08cac5..c2cf2d8 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -32,6 +32,7 @@
>  #include <linux/delay.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/of.h>
> +#include <linux/acpi.h>
> =20
>  #include <linux/usb/ch9.h>
>  #include <linux/usb/gadget.h>
> @@ -960,12 +961,21 @@ static const struct of_device_id of_dwc3_match[] =
=3D {
>  MODULE_DEVICE_TABLE(of, of_dwc3_match);
>  #endif
> =20
> +#ifdef CONFIG_ACPI
> +static const struct acpi_device_id dwc3_acpi_match[] =3D {
> +	{ "808622B7", 0 },

can you just provide a macro for this string ?

--=20
balbi

--DIOMP1UsTsWJauNi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUItpNAAoJEIaOsuA1yqREkSIP/3L49Fsw+A4Pjd53xMjzXWWV
DZkvfEa2O9zNgLRK03pdEZe0K1MB4ob6rvP2dDp6kolsWGjd6RxRTv8wIk3pYADz
s/yYVScZ0lMqlWfmUzj9oCGeyfmszLAPju0xDBTiCtJdtUUACJNptuU9wcIyblka
mWn1k8dzJSkGCjsQu5keybp4U61bHz5lszkO3Z1pKiC3YYosaGmGLUo+/7BbtEny
VCpRh7WcbrWFJicro4SEFye3JOQYSMJY98X1lIqiV7fMUOvyj/LXyqERzenq+287
aj1a3Vj00kqmwj2lEi2RiFDdkNyT4PRTcMunVtCZE9oANh2lo+D4TkcaGGAxaHTA
qOiIvkmvCUSgOyGJP/f5NilU3seVkPPM5PVcfo1RP9H3Dxq3X4Jc/nnSf6ewDZRF
98CSobCM4I5UA1j4bMVbkgYhkdipBxmx5meQ18VqthXhyf/o+RirxA2A5dp0G22P
hLEtOw9lJ8h6/w7E+OxaXj0NPJ/Gdb6TGrE8MPlNXfFrQ2c5n15cMajmTiM8Psui
nnKEw+nOatRIAGnQ7kd94s3VpuF+M9rReEUXLGkeDVjC4nV5J+TotsFB0/gl+4Vu
c+z0oB8j+E1M3yi83LGwQOBU0sTUWVyQynCllyB8bnzbnsqvlmVYTGVtUijmd6U6
PymNY4n/UQ+x4jFw8A25
=+F6+
-----END PGP SIGNATURE-----

--DIOMP1UsTsWJauNi--
