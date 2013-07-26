Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab3GZHaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 03:30:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41741 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595Ab3GZHau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 03:30:50 -0400
Message-ID: <51F225A0.90801@ti.com>
Date: Fri, 26 Jul 2013 10:30:40 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Luis Henriques <luis.henriques@canonical.com>
CC: <linux-fbdev@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vga16fb: Remove unused variable
References: <20130710225659.GA14107@hercules>
In-Reply-To: <20130710225659.GA14107@hercules>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="RsG8ogCcBoo8VFhuj7elAuAaQDJPcJI6C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RsG8ogCcBoo8VFhuj7elAuAaQDJPcJI6C
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/07/13 01:57, Luis Henriques wrote:
> Fix build warning of unused variable:
>=20
> drivers/video/vga16fb.c:1268:26: warning: unused variable =E2=80=98dev=E2=
=80=99 [-Wunused-variable]
>=20
> Signed-off-by: Luis Henriques<luis.henriques@canonical.com>
> ---
>  drivers/video/vga16fb.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/video/vga16fb.c b/drivers/video/vga16fb.c
> index 830ded4..2827333 100644
> --- a/drivers/video/vga16fb.c
> +++ b/drivers/video/vga16fb.c
> @@ -1265,7 +1265,6 @@ static void vga16fb_imageblit(struct fb_info *inf=
o, const struct fb_image *image
> =20
>  static void vga16fb_destroy(struct fb_info *info)
>  {
> -	struct platform_device *dev =3D container_of(info->device, struct pla=
tform_device, dev);
>  	iounmap(info->screen_base);
>  	fb_dealloc_cmap(&info->cmap);
>  	/* XXX unshare VGA regions */
>=20

Thanks, I've applied this into my 3.12/fbdev branch.

 Tomi



--RsG8ogCcBoo8VFhuj7elAuAaQDJPcJI6C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJR8iWkAAoJEPo9qoy8lh71N/4P/1E5knfrJW5+cdjT5G8656fa
zJ6ZSqjVnB8SBp5jU7jC0gmssDC/02USD+qTNn1SH+VSEP4D8X1Lqof8yQgCP11g
i7zzWcrDuKBFfZ6H92QavYtHPLws+tYU1w4jI2/cBF1rG+gKx7zruGc6ZiJm96pa
CQNC0JYriwqs9yV1W+8DT0CXGPV3/eactw6msqEyNqAiczNgUsSjPKwZTDAvXx5C
G/Rfrtqx6svoexJf7WOZw1sg3uLw9hjj/JReYgNWmDcfZ4TfFzVBezrJyfIYPPab
UMjcU+oafFyvMPJOzvWboIFN5qAUqciaitkkT+96YmH8KkivCvwt2IOXLmBlBcOD
puro89iXQe2sIe2hhz9c59WOd1/iYE/0a1+Oux51LaIqOpUIRyLMX3nOZZmllg0a
pPMPwJaNhy2PilRHuN8mVsHdOpQU3lmTp8f8BcFGQWCM1M3NltXScteZuTVt3EOW
IkyTFoZAQa8IfaoWvVMIUCcXs+KysrUuAu/N9iUDhVqoBEVn3oWNC7dmdffzrkB6
jecpvzaMlpvMQgynHVWsIhxn9qv1pZLph49D51wib7OOzNQRUSKoGh/21sM3bNMc
trvCQC+i3PsJUnTKgStkEyL2q2KZ73X2ZnxKVKyiin+RmT/10gAsphhsvxKobZiE
0VlJZyOq9TrBmFOLW460
=zqCr
-----END PGP SIGNATURE-----

--RsG8ogCcBoo8VFhuj7elAuAaQDJPcJI6C--
