Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbbAOL1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 06:27:17 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48836 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbbAOL1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 06:27:15 -0500
Message-ID: <54B7A40A.3050509@ti.com>
Date: Thu, 15 Jan 2015 13:27:06 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        LFBDEV <linux-fbdev@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] fbdev: ssd1307fb: set default height if not found
 in DT node
References: <1420705079-3741-1-git-send-email-prabhakar.csengg@gmail.com> <1420705079-3741-2-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1420705079-3741-2-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="r9b76Td07I7h6u0r5SVtBU9muBM0fsWMx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--r9b76Td07I7h6u0r5SVtBU9muBM0fsWMx
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/01/15 10:17, Lad, Prabhakar wrote:
> this patch sets the default height if its not found in DT.
>=20
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/video/fbdev/ssd1307fb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd1=
307fb.c
> index f4daa59..70e3ce8 100644
> --- a/drivers/video/fbdev/ssd1307fb.c
> +++ b/drivers/video/fbdev/ssd1307fb.c
> @@ -460,7 +460,7 @@ static int ssd1307fb_probe(struct i2c_client *clien=
t,
>  		par->width =3D 96;
> =20
>  	if (of_property_read_u32(node, "solomon,height", &par->height))
> -		par->width =3D 16;
> +		par->height =3D 16;
> =20
>  	if (of_property_read_u32(node, "solomon,page-offset", &par->page_offs=
et))
>  		par->page_offset =3D 1;
>=20

Thanks, queued for 3.20.

 Tomi



--r9b76Td07I7h6u0r5SVtBU9muBM0fsWMx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUt6QKAAoJEPo9qoy8lh71FxAQALGNDABKCbo8XSeGr7TjKtmn
oF8YbLLFqw54ht5VVLEXf4stKjKWNiofQoj/gIU7MMDs/tw0zO1joRogSjL5gQoB
h+FT7AvJ6qK3sSfr3Q/2Rtfq1Cinr3cfd7yQJZITtjn3V/H3Mgs3Rhq1SmJjWrOS
S2o4eB40V4GjSXViaLplxnn6Q+9IAs1/otpElFvm5YW0xiDeTyTGMZectvPbY7Cb
6s/mSSrwaxEFDy2cklFYX68UDiObCYnUwWV4Rwq0aB71GmWhb6qJCU70P0grbSqJ
Y2eAD2hR0KKE7ryx1LeN/YcozXX8DAwMdJNLv0MZZ72IW0tHCtMmUmZxqZIbaBqV
n9v5MtzjSSt8eJnCN638F0Od+T0C3aO5MG+y7P7PZZvzNbhYkMQ8LHDCp7s8ueql
HUa5hF97Zto/GbMho7/BMkV24Nw+59JMonoSG12TMsCvatbq/2An8BW1rN5RDU6s
pszOTHMX12YqjE8PaTtLEUUfy0PzgKLcErsSFPnj0HOT8dycQSodjlMrX9DQ+2i/
Lk2DeeQURGr/6vH5g0l6yUUEJnOq7r+kJldwbZw8whXaiW3JLOjT+j99nxB73IqP
H3dsnFZj42G3braGG5eGwKx33Bg33YmY5FB2HSpHwShGiLXkycncvbp9m2OvGTQX
7hp2eR+6PO2qqlDgwcs6
=Skr8
-----END PGP SIGNATURE-----

--r9b76Td07I7h6u0r5SVtBU9muBM0fsWMx--
