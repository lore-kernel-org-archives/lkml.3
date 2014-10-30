Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611AbaJ3Mw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:52:59 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42522 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbaJ3Mw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:52:57 -0400
Message-ID: <5452349B.3090608@ti.com>
Date: Thu, 30 Oct 2014 14:52:43 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marek Belisko <marek@goldelico.com>
CC: <plagnioj@jcrosoft.com>, <hns@goldelico.com>, <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] omap: dss: connector-analog-tv: Add missing module device
 table
References: <1414441443-10224-1-git-send-email-marek@goldelico.com>
In-Reply-To: <1414441443-10224-1-git-send-email-marek@goldelico.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="RgKewLvVfaOAGdTmd7mGV5mjWe1nifXO5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RgKewLvVfaOAGdTmd7mGV5mjWe1nifXO5
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 27/10/14 22:24, Marek Belisko wrote:
> Without that fix connector-analog-tv driver isn't probed when compiled
> as module.
>=20
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> ---
>  drivers/video/fbdev/omap2/displays-new/connector-analog-tv.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/video/fbdev/omap2/displays-new/connector-analog-tv=
=2Ec b/drivers/video/fbdev/omap2/displays-new/connector-analog-tv.c
> index 5ee3b55..d29cf72 100644
> --- a/drivers/video/fbdev/omap2/displays-new/connector-analog-tv.c
> +++ b/drivers/video/fbdev/omap2/displays-new/connector-analog-tv.c
> @@ -301,6 +301,8 @@ static const struct of_device_id tvc_of_match[] =3D=
 {
>  	{},
>  };
> =20
> +MODULE_DEVICE_TABLE(of, tvc_of_match);
> +
>  static struct platform_driver tvc_connector_driver =3D {
>  	.probe	=3D tvc_probe,
>  	.remove	=3D __exit_p(tvc_remove),
>=20

Thanks, queued for 3.18 fixes.

 Tomi



--RgKewLvVfaOAGdTmd7mGV5mjWe1nifXO5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUjSbAAoJEPo9qoy8lh71fHcP/2ik4haQjavnNylfsm39vOA8
zxZMLpONHF7SL56vIuxGGWN91olpSJaiyZovX2f7Mivlu2Apf3x0vAEhqNywQ/I2
TrTur4AYK/+v3G5bpRJdaWkMjtOsRG2yMNcQ9gxFCz8syVHVa750P+gebI4PlXjb
8h9J6AEceWGg2QNyF4hSPs8/xAczVSIbDUnMNwNzNVnKdyl4tgcnITRtNfZzKpof
3zMNr3LHz0LQl8B260sQsM2thaeIwwrmiqxECO0YgCeBVft6i1uebeTAFpDCkKuU
bg2trUtrCFZiw4yTRw+vdwcsHNiOSvoi02ZRS824/N+2OMxbmzfM89m8U1NxVCOQ
OnWFji5KaKBH45WXMhvussPlWNuzyERtEHNi3BFy92/i56VhItSiOR0H2ddXF3UY
uz1UFhXt7s5vf66phCaXOOuBkzHEubXymC8UclfaPhZC1DF5Te9fDjC3HH7bdmgv
mIoXGMT7mBctfOKD7aev1+SO5ElD2KoNZUXslaKfGBngwElc0RGOaO6svHLvMBKY
ikaIsqOgzDE2FaDP+4TcBrvxFfdFE8jJfj4QEQJxTVZEkTdTDLH7Bu9Dc36ih6Bh
2ziVY42bvwkJ+N6mh2tTy6lI3u4bgFamsrN60lgAoPK5mIRshoeQgaaqDfNsTQ3t
caw3mYvsF/Tl85Rq8O/R
=nyWd
-----END PGP SIGNATURE-----

--RgKewLvVfaOAGdTmd7mGV5mjWe1nifXO5--
