Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaANIGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 03:06:30 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:54126 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbaANIG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 03:06:28 -0500
Message-ID: <52D4EFFA.8090205@ti.com>
Date: Tue, 14 Jan 2014 10:06:18 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Antonino Daplas <adaplas@gmail.com>, <kernel-janitors@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] i810: delete useless variable
References: <1389629847-5330-1-git-send-email-Julia.Lawall@lip6.fr> <1389629847-5330-3-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1389629847-5330-3-git-send-email-Julia.Lawall@lip6.fr>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="sqxRxtgUBfQ1HqNuobL954PqphI6gFh38"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--sqxRxtgUBfQ1HqNuobL954PqphI6gFh38
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-01-13 18:17, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Delete a variable that is at most only assigned to a constant, but neve=
r
> used otherwise.
>=20
> A simplified version of the semantic patch that fixes this problem is a=
s
> follows: (http://coccinelle.lip6.fr/)
>=20
> // <smpl>
> @@
> type T;
> identifier i;
> constant c;
> @@
>=20
> -T i;
> <... when !=3D i
> -i =3D c;
> ...>
> // </smpl>
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> ---
>  drivers/video/i810/i810_main.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/drivers/video/i810/i810_main.c b/drivers/video/i810/i810_m=
ain.c
> index 038192a..bb674e4 100644
> --- a/drivers/video/i810/i810_main.c
> +++ b/drivers/video/i810/i810_main.c
> @@ -2011,9 +2011,7 @@ static int i810fb_init_pci(struct pci_dev *dev,
>  	struct fb_info    *info;
>  	struct i810fb_par *par =3D NULL;
>  	struct fb_videomode mode;
> -	int i, err =3D -1, vfreq, hfreq, pixclock;
> -
> -	i =3D 0;
> +	int err =3D -1, vfreq, hfreq, pixclock;
> =20
>  	info =3D framebuffer_alloc(sizeof(struct i810fb_par), &dev->dev);
>  	if (!info)
>=20

Thanks, queued for 3.14.

 Tomi



--sqxRxtgUBfQ1HqNuobL954PqphI6gFh38
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS1O/6AAoJEPo9qoy8lh71XO0P/jEYBpToHRMyxiUxj4T//A/O
bmtB4dk05lWjw9jyW8NqpHCB4z5EoWDh3P7lsfNFGlZMhBYBUrv1LTBxQKTjAzpT
zuLIv0jBznVvL0jiVtpCnIL3Z/92TCYs19jE2ZcOuwPQj0K4A61QE9fiW7+Tialj
SFwb8P9hTg+5Wc7BK6c3AhfqzGqXWZgfhMveVsyG/lGuKMljO/9m58RlpGmDKgDD
5aJDTupaK6Mts59TQtrRJkbk8F41+Bbhg6iWaYlcjypCUbvLM5uKU2bNGsLYMBrY
X6hLULDVDj3I+eM4BlyJI9WbPE532CFfAVhhdEc9nWl7PtytKUBiy1oSpq41gCLf
ZvoelVJtb3I/CEIe+moLdrvExIOPkzoUweQsLeSxZXfvy7XdKG7yHF45OMLwq/gS
2v9WdeJWtk1DmDo8/WEQ7eHhYnfw6psJS24sxJP/nhtnbwOXQ80Dds7UJ3GEf8uy
mFItocfg7CrGQpnfsjTXkXY9Z8/fAhFX3urIg9pnc0z+uj21waDubpN3PGUvwXLD
GFbERn5Ip4Ayoy0fGbQCystUhAHwOi0xCjloW6ztXYgaQxPrNdBcCdoB2zVNMv1E
c/TlZMjtDrXRvbC+XIiKRMANX6GqkWYGAlZCkFh0heW1clGZPtiXq6417hFtrrfL
WlfrX8yAgxLPxwRQiZlN
=e4wL
-----END PGP SIGNATURE-----

--sqxRxtgUBfQ1HqNuobL954PqphI6gFh38--
