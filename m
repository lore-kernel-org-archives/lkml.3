Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab3H3H5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 03:57:19 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55789 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab3H3H5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 03:57:17 -0400
Message-ID: <52205056.8080908@ti.com>
Date: Fri, 30 Aug 2013 10:57:10 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Marek Belisko <marek@goldelico.com>
CC: <plagnioj@jcrosoft.com>, <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "H. Nikolaus Schaller" <hns@goldelico.com>
Subject: Re: [PATCH] omap2: panel-generic: Added panel parameters for ortus-com37h3m05dtc/99dtc
 and sharp-lq070y3dg3b.
References: <1377779724-30648-1-git-send-email-marek@goldelico.com>
In-Reply-To: <1377779724-30648-1-git-send-email-marek@goldelico.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="xCkXAwdt47atsvQTJkFeT0tB0d6MDTOHI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--xCkXAwdt47atsvQTJkFeT0tB0d6MDTOHI
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 29/08/13 15:35, Marek Belisko wrote:
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> Signed-off-by: Marek Belisko <marek@goldelico.com>
> ---
>  drivers/video/omap2/displays/panel-generic-dpi.c | 53 ++++++++++++++++=
++++++++
>  1 file changed, 53 insertions(+)
>=20
> diff --git a/drivers/video/omap2/displays/panel-generic-dpi.c b/drivers=
/video/omap2/displays/panel-generic-dpi.c
> index bebebd4..d573291 100644
> --- a/drivers/video/omap2/displays/panel-generic-dpi.c
> +++ b/drivers/video/omap2/displays/panel-generic-dpi.c
> @@ -107,6 +107,33 @@ static struct panel_config generic_dpi_panels[] =3D=
 {
>  		.name			=3D "sharp_ls",
>  	},

The drivers in drivers/video/omap2/displays/ are on their way out, and
will probably be removed for 3.12. Please look at the new one at
drivers/video/omap2/displays-new/panel-dpi.c.

 Tomi



--xCkXAwdt47atsvQTJkFeT0tB0d6MDTOHI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSIFBWAAoJEPo9qoy8lh71/ZMP/27bd5Yhlc4KB+SNdC4s6L3c
wtxIuRdh1H0FhKrelfhER8sZO88syO3nAkYH5CRRi2vMerJj0HRDdeJH+jxFo1wk
Z6MeiVznRfDX56Lk5bCsrTPtKyvZvOmuutiOF8EOsPfbCSNfeVQ7JscQa8m2NOG2
A9AA1Y2wjOAjF5kNilqYH31r1ClI9IwfuNB3vdJsWdj0t0ZUueRc+2TsYQGYFegP
5STD+HzAYlUlt141dvKVOIZyvjHa1SDbStQkHiloTfrO8OOMUU4RugpMjTrmL9Ue
rTdhU7gki2j4zMFrW14wJqWQ+P2mc5shFzSicg6viRaoUKJIRIZ5XhLe36XnEBj9
846DV8XjDurH2bXLWeYh/BjBvQ80EuqHRG9xWXF8GQDgvuSYR9EkfPKGmc9SM2A3
tvtvEIuV/8B8EPrb4Abeo9MjR5y6Ef6Q7pW1rtfas+TUvd7bfwOs4ZyApz9eTWUc
eND/Uq2GJQc5ctTbg+E0obzdqKZF0D6+ePaXMarsjusstQBvMXOvJJ7EG6PXkbI/
+y34IB0+d185bMWML+TNKP/tUxbEruGdBqXuAjSXsJIa46rD24sCzMO0qdj7OTRZ
9tn9/1aKc3qadEG0ckP28CkXaeZejCEfLP3CAAjI5d6D7ONgiep6fLTqlYvb3JHP
dBdCLpnOXmgn5o+G1/Mx
=sm/j
-----END PGP SIGNATURE-----

--xCkXAwdt47atsvQTJkFeT0tB0d6MDTOHI--
