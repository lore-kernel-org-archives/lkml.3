Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaI3KJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:09:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33895 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbaI3KJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:09:16 -0400
Message-ID: <542A813A.6010603@ti.com>
Date: Tue, 30 Sep 2014 13:08:58 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, <linux-kernel@vger.kernel.org>
CC: <daniel.vetter@intel.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-parisc@vger.kernel.org>, <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 1/6] video: fbdev: stifb.c: use container_of to resolve
 stifb_info from fb_info
References: <1410980419-5326-1-git-send-email-fabf@skynet.be> <1410980419-5326-2-git-send-email-fabf@skynet.be>
In-Reply-To: <1410980419-5326-2-git-send-email-fabf@skynet.be>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="p6vxtaDxfn1sGQMCs9rLURodcWsq1VG22"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--p6vxtaDxfn1sGQMCs9rLURodcWsq1VG22
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi,

On 17/09/14 22:00, Fabian Frederick wrote:
> Use container_of instead of casting first structure member.
>=20
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> PARISC cross-compiled but untested.
>=20
>  drivers/video/fbdev/stifb.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/video/fbdev/stifb.c b/drivers/video/fbdev/stifb.c
> index cfe8a2f..86621fa 100644
> --- a/drivers/video/fbdev/stifb.c
> +++ b/drivers/video/fbdev/stifb.c
> @@ -918,7 +918,7 @@ static int
>  stifb_setcolreg(u_int regno, u_int red, u_int green,
>  	      u_int blue, u_int transp, struct fb_info *info)
>  {
> -	struct stifb_info *fb =3D (struct stifb_info *) info;
> +	struct stifb_info *fb =3D container_of(info, struct stifb_info, info)=
;
>  	u32 color;
> =20
>  	if (regno >=3D NR_PALETTE)
> @@ -978,7 +978,7 @@ stifb_setcolreg(u_int regno, u_int red, u_int green=
,
>  static int
>  stifb_blank(int blank_mode, struct fb_info *info)
>  {
> -	struct stifb_info *fb =3D (struct stifb_info *) info;
> +	struct stifb_info *fb =3D container_of(info, struct stifb_info, info)=
;
>  	int enable =3D (blank_mode =3D=3D 0) ? ENABLE : DISABLE;
> =20
>  	switch (fb->id) {
>=20

Thanks, queuing the series for 3.18.

 Tomi



--p6vxtaDxfn1sGQMCs9rLURodcWsq1VG22
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUKoE6AAoJEPo9qoy8lh71ge8P/1hcSpUn1+7zt50TUtefryPc
vGc+vd4QuI1GOh73BwV8O0PWR3R7OWkIHjoEK+ShZsv/W8r2auaHqwqaOH43nwED
P/yHj/sZGxluOlYixwehs0zNaOYWp7DTRZzWJb1AyqAueba2jPMslvYT6eGXiZP6
+esvP4GQ8kKc+NoiZ7ODz1Nzk35VUNoHzTPm0xoRtK8Hv4TKWWpAQxSY7KoUwnoG
5bWHPAYtnVhgMJchkB9CfAeD1KzLHKMHvdlrFju0hZw/tVNtS02kyz9hfK8Vx3n1
rW5O/57W7hAmobhjzNLsGutZfXUYuGArjU610tAaRekTFfmhFS1ggICYtoHGYh+X
P+GZcCumuac+RM8ETTTcFj/mCS8wPSGK5cp5GxEU1HWXK1sVk7jMaIuh9IIn8TIb
FeqlHtts1efr/mO7HYcNt4n0QZ0VhNoMAriZh1QuH7u/lE8fhV7xPRKXQCbQ+7uV
APMe1z1P7X1K60ROeaosLZgifU9hOXzVITNF2TO84fiCM2hsRgV2mJItPzUE0Hzb
COz/iCSMylDKV9guHOQc3K0sKiF5dgjDgbxAOQIL17zAXvUwdbfUf5BOZUxN2KXa
jeKb+xs8iRN5qz4e7kjzFDxMK5EMLRMZxjXK9BkuSBh5mHVFHiHdgSBsICmIUTg2
JeMii1QDpuS24HXKCNoK
=5q0y
-----END PGP SIGNATURE-----

--p6vxtaDxfn1sGQMCs9rLURodcWsq1VG22--
