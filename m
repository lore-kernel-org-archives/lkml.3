Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbaEWKs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:48:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38123 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbaEWKcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:32:09 -0400
Message-ID: <537F239B.9010504@ti.com>
Date: Fri, 23 May 2014 13:31:55 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] video: of: display_timing: fix default native-mode setting
References: <1399643592-17125-1-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1399643592-17125-1-git-send-email-boris.brezillon@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="d4UQeRwg49oKxoqsXg4gdUoXgSrU0m7Lm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--d4UQeRwg49oKxoqsXg4gdUoXgSrU0m7Lm
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/05/14 16:53, Boris BREZILLON wrote:
> Set native mode to the first child node of the display-timings node and=
 not
> the first child node of the display-timings parent node.
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  drivers/video/of_display_timing.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/video/of_display_timing.c b/drivers/video/of_displ=
ay_timing.c
> index ba5b40f..19dd752 100644
> --- a/drivers/video/of_display_timing.c
> +++ b/drivers/video/of_display_timing.c
> @@ -164,7 +164,7 @@ struct display_timings *of_get_display_timings(stru=
ct device_node *np)
>  	entry =3D of_parse_phandle(timings_np, "native-mode", 0);
>  	/* assume first child as native mode if none provided */
>  	if (!entry)
> -		entry =3D of_get_next_child(np, NULL);
> +		entry =3D of_get_next_child(timings_np, NULL);
>  	/* if there is no child, it is useless to go on */
>  	if (!entry) {
>  		pr_err("%s: no timing specifications given\n",
>=20

Queued for 3.16.

 Tomi



--d4UQeRwg49oKxoqsXg4gdUoXgSrU0m7Lm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTfyOhAAoJEPo9qoy8lh71uMcQAKB0BbU+4iPV+Sp99XZGMapt
HVWxnoYwQkyZsbJVltI3O7WTRRJMXEuHpOizraUKBz5yQgHd9BPcqRInswyzoSsM
/9U8TNDoYlU9g6uglbUC08gupOeC4PIqLt6whECle9w1WstatbYNSKBAOGKnI6Rm
OhNkKCQY0aRVb63j4EXwaoDo8+LclslsYQMqqqiFiWvSN8swT5eOWD2wiDOFLY2V
btsQKbn4B7c7TZNUQWSGzV4UjZ82bnj6vn3GeMgRG+wKUaBujte/qJdDNP1hnrkK
sqmDEgYzmtLcNCHPLsam20PiY3BRpZxZ59wvspy8mlPHD7iDqUAETNbjumU97a/Q
meGjOtxPe0GlmZ7wcmwiCfI3tWTDdRmighv+N+TFTukjDsCqzxUFfGjJuZV+rIYq
BgiJsgboAB2ZPDgE0QHzbsL89gVFh1C1IwS+yS9ocv6DvGwPJeiOZFliaNWnAz2e
9DWJcsjnHkuQ+OKmfJ/3pBwFIWF0bvSu72/olVXDag6WpLqgL1HZB4ntW2dLSQdu
WqFsa01dzbhbVI2zcptT1mnGV4jGwleWRc8X760b9+Mo+dQn0sOL7aSC5w2Dz519
gM39rSOtbyuV/wvuTAm5dJP9j0m63wj4er2ahyGLQoEp0orpWscyCHIUfT1+uRRU
RBocjUMWfGBbYDy9s7sh
=pyiQ
-----END PGP SIGNATURE-----

--d4UQeRwg49oKxoqsXg4gdUoXgSrU0m7Lm--
