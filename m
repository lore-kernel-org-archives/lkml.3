Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbaKYKzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:55:52 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59841 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbaKYKz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:55:29 -0500
Message-ID: <54746012.3050505@ti.com>
Date: Tue, 25 Nov 2014 12:55:14 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: SF Markus Elfring <elfring@users.sourceforge.net>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] video: fbdev-MMP: Fix typos for the word "destroy"
References: <54736422.90409@users.sourceforge.net> <547368BB.2050401@users.sourceforge.net>
In-Reply-To: <547368BB.2050401@users.sourceforge.net>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="iNfvWhrwnEhIOmgsVxmQUaC48RJdl7ub3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--iNfvWhrwnEhIOmgsVxmQUaC48RJdl7ub3
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 24/11/14 19:19, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 24 Nov 2014 15:50:15 +0100
>=20
> Two mistyped words were corrected in the description for
> the mmp_unregister_path() function.
>=20
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/video/fbdev/mmp/core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/video/fbdev/mmp/core.c b/drivers/video/fbdev/mmp/c=
ore.c
> index b563b92..43ed576 100644
> --- a/drivers/video/fbdev/mmp/core.c
> +++ b/drivers/video/fbdev/mmp/core.c
> @@ -223,10 +223,10 @@ struct mmp_path *mmp_register_path(struct mmp_pat=
h_info *info)
>  EXPORT_SYMBOL_GPL(mmp_register_path);
> =20
>  /*
> - * mmp_unregister_path - unregister and destory path
> + * mmp_unregister_path - unregister and destroy path
>   * @p: path to be destoried.
>   *
> - * this function registers path and destorys it.
> + * this function registers path and destroys it.
>   */
>  void mmp_unregister_path(struct mmp_path *path)
>  {
>=20

Thanks, applied this and the patch 5/6 to fbdev tree.

 Tomi



--iNfvWhrwnEhIOmgsVxmQUaC48RJdl7ub3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUdGASAAoJEPo9qoy8lh71oQ4QAJW03l7JJL5NGV6nY3nMrAlX
FrxP+x0V85vdyp4BYvYAZ+jiU1KIu8ObpgHcvbvmyU6lPjhhIcm9VTKt6/lWAA7a
9Yr8aS0r+Xowh8z6LEBkSblMAL2VfnjsBiG/Ti6IPZgec+uD0aFGcgmi9EP597iB
/GDyZZTn1Eb0i/Z359/kAYcrIfj6DcLNCniNbxWvk8Q9Q1Ij+UwV5CsbehgDw0pz
4ERkEjhAQI0z2fMro1n4JEikutUuNCJb2B/J/5sfKM/l/jpTovfAETXyJqnoxZ5e
52mz5N7yAo+Nrem/2bGGLrwuU+O/DSwYTyA+rxBUSIDLz0ZJViLjBYpP2BpA9IyA
S794k2C92EjoybC4zFXjyLXqa2fGmQoCCqu3olwpUSoCLzh18BaqTAp48Zt1MytZ
E12rqnGUosZREAIEJsd19Poq0JxHxrY44JkGkxa/DpCCT4SGqE5sjfH+LaT6NkOY
mdL8W9JxcG4g5imCDLAaif+OSiCroKoriB9B8pIARdqRKTm1LFOIsVhY4PdPauxj
3unM5DLoxN1+xfiAmc5p3FNM9ennU3OcKLVIjH2ssIKlmo8hcevg/TjglUTqVFnY
v5wrWigjzSJEr9tb1FFoWDVNNrJREs9hyL/nG3gWh9i3sI6BEbnO4XeKMMeGlNmj
eUq2/7QtIKmW6a1L8ibu
=xW4g
-----END PGP SIGNATURE-----

--iNfvWhrwnEhIOmgsVxmQUaC48RJdl7ub3--
