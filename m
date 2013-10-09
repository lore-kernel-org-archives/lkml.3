Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab3JIIot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 04:44:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51593 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487Ab3JIIor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 04:44:47 -0400
Message-ID: <5255176F.1020700@ti.com>
Date: Wed, 9 Oct 2013 11:44:31 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>
CC: <linux-kernel@vger.kernel.org>, <monstr@monstr.eu>,
        Russell King <linux@arm.linux.org.uk>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 9/9] video: amba-clcd: Remove unnecessary amba_set_drvdata()
References: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com> <2f12a1d7caba382efe8d361b373da60c08e70622.1380793579.git.michal.simek@xilinx.com>
In-Reply-To: <2f12a1d7caba382efe8d361b373da60c08e70622.1380793579.git.michal.simek@xilinx.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="iDeamAVQR4lQIGMiBOJNQx408lXfKMPGa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--iDeamAVQR4lQIGMiBOJNQx408lXfKMPGa
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/10/13 12:46, Michal Simek wrote:
> Driver core clears the driver data to NULL after device_release
> or on probe failure, so just remove it from here.
>=20
> Driver core change:
> "device-core: Ensure drvdata =3D NULL when no driver is bound"
> (sha1: 0998d0631001288a5974afc0b2a5f568bcdecb4d)
>=20
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
>  drivers/video/amba-clcd.c | 2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/video/amba-clcd.c b/drivers/video/amba-clcd.c
> index 0a2cce7..0bab6ab 100644
> --- a/drivers/video/amba-clcd.c
> +++ b/drivers/video/amba-clcd.c
> @@ -594,8 +594,6 @@ static int clcdfb_remove(struct amba_device *dev)
>  {
>  	struct clcd_fb *fb =3D amba_get_drvdata(dev);
>=20
> -	amba_set_drvdata(dev, NULL);
> -
>  	clcdfb_disable(fb);
>  	unregister_framebuffer(&fb->fb);
>  	if (fb->fb.cmap.len)
> --
> 1.8.2.3
>=20

Thanks, queued for 3.13.

 Tomi




--iDeamAVQR4lQIGMiBOJNQx408lXfKMPGa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSVRdvAAoJEPo9qoy8lh71ouQQAKs3aKw7aRNephhZwPqKD7j5
8D+WeBLYlnG4E7xcW/0uNIyevAHjS11L/4CrWGg74x4ZA4DnMjy77jzBj5uI3aRh
l8RFddfPi3sDmfDZs6upMIks3S6TEF0BfdZcBA2JyviSORiI6iD8gyU3/LYMCwUZ
lAkRH/xq47cW3pSCGMeFlQqUohQR7BQakdr8PlDkF1HAeNOfJbRwCLBqYyvHagYG
cK9cWX5FB6GEoYXy/wbqY5/CDGYQT2g7uhyzt5FmBVyDrabZ7Aa+v0nCeExy15rn
90moisSIB0gG2odpqXQ+Jd1J4yoliYwIcX3NPbWkSyntydnpYXfWnERF3+TTWQVk
qngn4K3vgHvvvx7aoVBMl6HcjsJvz2llHESKuOSJ3fbLbUVQC85A2rPJLPZUPu5j
dF5sFOrQlsM1ioHHnuiQkUI81gQq5NeEDBbLhZjmCIZCViuMxTaz9aOve8Pok9PW
b/K5iZC5da7cPMVvAwymeOr+Ak4wjG4VBRrvHA7sHMT6eIsilmsfu+IzsmgkYy8N
jKdHUY8y4/WACmX+Ef9TjjNOffTwcCG4rsMGrAOQIT6VIB7NtRKkT1m/UNbEvhxF
+1ok1A4JRkKWGk09eZsm5jteX+lS4gKZgMb9KakorBQp7USz1rVgTRe8sA3xMA53
zAK4tZ6EokONJphyg2Aq
=2QKq
-----END PGP SIGNATURE-----

--iDeamAVQR4lQIGMiBOJNQx408lXfKMPGa--
