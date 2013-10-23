Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab3JWAhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 20:37:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43251 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507Ab3JWAha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 20:37:30 -0400
Date: Wed, 23 Oct 2013 11:37:14 +1100
From: NeilBrown <neilb@suse.de>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 08/24] md: Convert use of typedef ctl_table to struct
 ctl_table
Message-ID: <20131023113714.4899fd63@notabene.brown>
In-Reply-To: <97bd203891c6b2c45b2e77c31edda1b4149782f2.1382480758.git.joe@perches.com>
References: <cover.1382480758.git.joe@perches.com>
	<97bd203891c6b2c45b2e77c31edda1b4149782f2.1382480758.git.joe@perches.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ikf4vkwEO7ElgOEBHyMXCIA"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ikf4vkwEO7ElgOEBHyMXCIA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 22 Oct 2013 15:29:51 -0700 Joe Perches <joe@perches.com> wrote:

> This typedef is unnecessary and should just be removed.
>=20
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/md/md.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 8a0d762..7b57639 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -112,7 +112,7 @@ static inline int speed_max(struct mddev *mddev)
> =20
>  static struct ctl_table_header *raid_table_header;
> =20
> -static ctl_table raid_table[] =3D {
> +static struct ctl_table raid_table[] =3D {
>  	{
>  		.procname	=3D "speed_limit_min",
>  		.data		=3D &sysctl_speed_limit_min,
> @@ -130,7 +130,7 @@ static ctl_table raid_table[] =3D {
>  	{ }
>  };
> =20
> -static ctl_table raid_dir_table[] =3D {
> +static struct ctl_table raid_dir_table[] =3D {
>  	{
>  		.procname	=3D "raid",
>  		.maxlen		=3D 0,
> @@ -140,7 +140,7 @@ static ctl_table raid_dir_table[] =3D {
>  	{ }
>  };
> =20
> -static ctl_table raid_root_table[] =3D {
> +static struct ctl_table raid_root_table[] =3D {
>  	{
>  		.procname	=3D "dev",
>  		.maxlen		=3D 0,


Applied, thanks.

NeilBrown

--Sig_/ikf4vkwEO7ElgOEBHyMXCIA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUmcaOjnsnt1WYoG5AQKy2w/+LXVHoSB/jeDt3pICUI5tBmLFYX8ikdHJ
Q0M1dP1DFlFKDwb8iVhdVGLkkWKRquVM3hkFkzdIbsZJqBmcUSkCq9vIpb7sgQU8
K+GEGaYjoGqND/DT97m9rUaR2zXOFCsW0XLV7oIj+uPETwNCXRJ/SyCX0fL3WVKl
UFug+xcTv0TMOp9z9N+6I9zBZnX9d8iqtVDCusIx7OtYur1HdPOS1RYiaZ2GxaSX
doDzl9EJUtTv02Fg6Cm3a2HL1sd0ccGIgENr6Hqre7lfD8CPJSzYCAgUlrDvn3HB
QhiGy1ODH93sB0ccVBxsvMq/6CmJAoSVJHiv3Mamtd68beDLn33T1TyTynw1eOB4
kh12/4VBDMTljI3VAyBPeEc1CY3THfVVb6HlTv+C1+2PT6Fuo8jn5Dsvn9njQlyK
V4gqGxT2xj1ZNrXVxFDn807wej+MD0I8VvqKfP96ogmNZI1Dok5rZqukn9Srw/e/
TJJXo9A2Se/CKFe9qeJf2N1G/nyVsaHMoX9g208QgMrLpIvenBC2m0fUiqZlD2RK
1jNNFwlDZ/ogzS/W5XC+O36YQbcJp7v9BrxZBDAv8hGrXpWe/S9eCoo92cMFHOkn
wwVagVQ2/ls3ZoRZIB+1OhiHr9rc0VTXx0WR1DhGnl+EH/vS/qGdOumLMWmVG/Sl
mYmPlTWRA6A=
=IfC/
-----END PGP SIGNATURE-----

--Sig_/ikf4vkwEO7ElgOEBHyMXCIA--
