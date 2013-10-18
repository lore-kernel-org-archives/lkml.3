Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab3JRIBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 04:01:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44361 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab3JRIBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 04:01:41 -0400
Message-ID: <5260EADF.3020804@ti.com>
Date: Fri, 18 Oct 2013 11:01:35 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] set data enable logic level to low
References: <1381704273-31540-1-git-send-email-roel.kluin@gmail.com>
In-Reply-To: <1381704273-31540-1-git-send-email-roel.kluin@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="GSmfgdwrHODDvlJ1e6GXXn8rs1hwK1Vuf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GSmfgdwrHODDvlJ1e6GXXn8rs1hwK1Vuf
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 14/10/13 01:44, Roel Kluin wrote:
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/video/omap2/dss/display.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/video/omap2/dss/display.c b/drivers/video/omap2/ds=
s/display.c
> index fafe7c9..669a81f 100644
> --- a/drivers/video/omap2/dss/display.c
> +++ b/drivers/video/omap2/dss/display.c
> @@ -266,7 +266,7 @@ void videomode_to_omap_video_timings(const struct v=
ideomode *vm,
>  		OMAPDSS_SIG_ACTIVE_LOW;
>  	ovt->de_level =3D vm->flags & DISPLAY_FLAGS_DE_HIGH ?
>  		OMAPDSS_SIG_ACTIVE_HIGH :
> -		OMAPDSS_SIG_ACTIVE_HIGH;
> +		OMAPDSS_SIG_ACTIVE_LOW;
>  	ovt->data_pclk_edge =3D vm->flags & DISPLAY_FLAGS_PIXDATA_POSEDGE ?
>  		OMAPDSS_DRIVE_SIG_RISING_EDGE :
>  		OMAPDSS_DRIVE_SIG_FALLING_EDGE;
>=20

Thanks. Next time, please write a patch description and prefix patch
subject with appropriate string. In this case "OMAPDSS: ..." would be fin=
e.

 Tomi



--GSmfgdwrHODDvlJ1e6GXXn8rs1hwK1Vuf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSYOrfAAoJEPo9qoy8lh71+i4QALD0NIffphcNESvrrpK4LxA9
dnk2oTNT/Wx75sjb1gJzBC4ML69M/BkjlGrViOJAX+Klm0nJJMsraap9mjSrkDCj
humNB9kXHbFmqihiQ1PVFwXJ3QBh84XXCkXo0nT4pAPnFj2CmKP4Ej1Jps3E46vd
93i1KzIhaKGE90V1Fo8w1b8OShymTHXU/ySFOGjhfuk6z9bneY3BwPAOnwmrz4qe
W6Pf9uZMgJYmZ6y8dOedn5rp8A5bx3E/zG6Rq/mAigXKE0fVaIJDPtEFgkif5lXd
0sx3CjMHYZP0pezkYcEu1tNvV0fvxVQ398X/EHwCbvt0qE1Oj1+N+quzGYfC75Bv
gt7YewAS0NBW+RacMHMe/0FvvAau9rVAXycoI/7+eTzJHGrU5pxAbxdwE2jcUwE+
v5pm/0sBY611HjgG9MBwJOLz62/liSBskZsMUHWzsV0M9+02ne7I8o+HrVgAlxv0
CGv1/AGTYKuli6aFog0sCbMF/qbqOwJUsHONu4IZRNVgl3cV6rh8dvPBJGHOhgwE
zPZYfDFk4Mo/uDrLgyIOnmkvUzqvHVUsK7ARaBvS/keOqRsSK5dfPbubC+9OyWwI
O8kweGQxlQTnoMCe+tfw9VojJ2haK/y7trfZkCPE25da8cStEsiNFTAVc/ETQM1h
aZGOOg+/L7EUgutiCd6Z
=jZ7y
-----END PGP SIGNATURE-----

--GSmfgdwrHODDvlJ1e6GXXn8rs1hwK1Vuf--
