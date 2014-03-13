Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbaCMP1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:27:45 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55979 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbaCMP1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:27:43 -0400
Date: Thu, 13 Mar 2014 10:26:00 -0500
From: Felipe Balbi <balbi@ti.com>
To: Suresh Gupta <suresh.gupta@freescale.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB : Gadget: fsl: add information message
Message-ID: <20140313152600.GH4599@saruman.home>
Reply-To: <balbi@ti.com>
References: <1394716310-27001-1-git-send-email-suresh.gupta@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9ZOS6odDaRI+0hI"
Content-Disposition: inline
In-Reply-To: <1394716310-27001-1-git-send-email-suresh.gupta@freescale.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--/9ZOS6odDaRI+0hI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 13, 2014 at 06:41:50PM +0530, Suresh Gupta wrote:
> 	Message helps to understand that the Freescale Gadget driver
> 	is up without any error.

why this tab ?

>=20
> Signed-off-by: Suresh Gupta <suresh.gupta@freescale.com>
> ---
>  drivers/usb/gadget/fsl_udc_core.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_u=
dc_core.c
> index 9a93727..455d0ab 100644
> --- a/drivers/usb/gadget/fsl_udc_core.c
> +++ b/drivers/usb/gadget/fsl_udc_core.c
> @@ -2503,6 +2503,7 @@ static int __init fsl_udc_probe(struct platform_dev=
ice *pdev)
>  		goto err_del_udc;
> =20
>  	create_proc_file();
> +	pr_info("%s (%s)\n", driver_desc, DRIVER_VERSION);

if there are no messages, then it's up. Also, you can very easily check
lsmod.

sorry, but I'm not taking this.

>  	return 0;
> =20
>  err_del_udc:
> --=20
> 1.8.4.1
>=20
>=20

--=20
balbi

--/9ZOS6odDaRI+0hI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTIc4IAAoJEIaOsuA1yqREJBwQAJd8V/tbGEN6dsUm66lSR2hp
5rx/c1/EqMOzNiy/ItPevyRfMqPfvl236gr/9dn2ie6zA6u5qqLBJp9Y2o83UcD0
eU8MlgFEV6YihvoialROzD2zxCEtp8KiTKX++5N2rmitEdJlZE3kOKS/PC5fOVid
QpYKnogGRDTMhkq9I/XcoMgTsZOqMlvrsCqG8KvY+Y/F55FtdaAR1AGnXbGfHSn+
kXmBLDKoGe6NttOXCyO+xiCdGKVXy5DIbxVByrrNZIjpTKV4FoKAgxE3eN7ksVM0
dgN/gM3iCcOYVK1DDlKy2qog0slUV611YvpqwcKHhqGpns87PgLIscPqAVDi4tDL
ihmvDcZqkfYi2NGFLt9vrB2Z64+JHMwwNkjHL5IW7+FnOQftzW6q4iTHFzODIT6a
2V3Gnls6DGoY9A9qx6BsbaeRRCugJ1o5eo/jY4ihXOlWsnk5VFC223h4/uwVL79/
fi0jNu7Gtv9J6CpwzuC1if+rAeZkj1y2fu1eLbDA35gYYDuFSqwx3U70WPl192nn
+NUEwgtli98YHhxCzKWgCty2gcz4MKmyF+wRH0zEOzaK2iPpSKmDyLalrrkBuN9p
Xv3opssP1776XuaL3U93FgtAkCsSbfksRL5L7/IGot6rF+joM0X4TJ0/MO9bMqF/
+tZrK3pvxh4w7udoJv5u
=hy7s
-----END PGP SIGNATURE-----

--/9ZOS6odDaRI+0hI--
