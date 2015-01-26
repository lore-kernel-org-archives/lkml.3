Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbbAZMLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:11:54 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38719 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098AbbAZMLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:11:51 -0500
Message-ID: <54C62EFF.1010202@ti.com>
Date: Mon, 26 Jan 2015 14:11:43 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Scot Doyle <lkml14@scotdoyle.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] fbcon: Remove unused vblank cursor code
References: <alpine.DEB.2.11.1501232247340.2377@localhost.localdomain>
In-Reply-To: <alpine.DEB.2.11.1501232247340.2377@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="HiFRWLNX4ferETt22DSbOenjewSWAE76c"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HiFRWLNX4ferETt22DSbOenjewSWAE76c
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 24/01/15 00:55, Scot Doyle wrote:
> commit 1fa0b29f3a43 ("fbdev: Kill Atari vblank cursor blinking")
>=20
> rendered vbl_cursor_cnt and therefore CURSOR_DRAW_DELAY unused in fbcon=
=2Ec,
> so remove them.
>=20
> Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
> ---
>  drivers/video/console/fbcon.c | 4 ----
>  1 file changed, 4 deletions(-)
>=20
> diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbco=
n.c
> index ea43724..b972106 100644
> --- a/drivers/video/console/fbcon.c
> +++ b/drivers/video/console/fbcon.c
> @@ -146,9 +146,6 @@ static const struct consw fb_con;
> =20
>  static int fbcon_set_origin(struct vc_data *);
> =20
> -#define CURSOR_DRAW_DELAY		(1)
> -
> -static int vbl_cursor_cnt;
>  static int fbcon_cursor_noblink;
> =20
>  #define divides(a, b)	((!(a) || (b)%(a)) ? 0 : 1)
> @@ -1329,7 +1326,6 @@ static void fbcon_cursor(struct vc_data *vc, int =
mode)
> =20
>  	ops->cursor(vc, info, mode, y, get_color(vc, info, c, 1),
>  		    get_color(vc, info, c, 0));
> -	vbl_cursor_cnt =3D CURSOR_DRAW_DELAY;
>  }
> =20
>  static int scrollback_phys_max =3D 0;
>=20

Thanks, queued for 3.20.

 Tomi



--HiFRWLNX4ferETt22DSbOenjewSWAE76c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUxi7/AAoJEPo9qoy8lh71evoP/REgfrdP+SfW+LFnEf7e927A
iUB1PC06BXHlNiNrMFiuBW2GPreudVw38Q9m47a6rtQHAVBj4zvb4XvYLx5ud+q3
0L8J+h/OWTW3ZTmQUC7KWGdwHtMY49cps5avZ9JfxuH0F8CC0rpQTYq47pqOxpu2
r56S1nYOEBYDEEE0KOaB1RwbEnlog7d9UALmhsala/pBTx2sC+n7OJu0+FDicxX3
EiyoYhiLHZWVqBYAe2OqYox8CUbgMslPbsuqf24/Vo0uBuUrYHAVZsewRxgSasc3
ZGZ067sEscionIvPHqq9f9t9HtYS4+Xq+YAJL0IOuJBuzfUce3pWocVQfngeZ5er
eGhT8iRydGmeBXX+iQ/9O4fQD8nML1hhkMhO5R70LgCj/kyycsLEJyeFEOg89qxL
9ZVI5d/HyLJ5vPm83difXAyqfte9Zg77XS18xOd9Ffu1Sgt+4UeNMfdDlombYOA6
kh4lbQvZycNY6qaoGoe3rjodoG23fhLe8ms6VfrsjKtfvJVnKMkYRPF7VYvKsFc9
i+J3jqiFLZYF7AJYlsA4/LBu+IQAkOAoQ9vAUUSsspUKC8GTUAzuObD6N3asSCvD
DlxDb8wIOhl1f7ImbnAjszh5WHERdwK1v++6Llz3gCK1FwWCew6njgZh34GaTf9F
7Tjmd8oRt/iEz730QKLE
=UQbz
-----END PGP SIGNATURE-----

--HiFRWLNX4ferETt22DSbOenjewSWAE76c--
