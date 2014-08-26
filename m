Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbaHZMbq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:31:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40654 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757810AbaHZMbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:31:44 -0400
Message-ID: <53FC7E29.3020603@ti.com>
Date: Tue, 26 Aug 2014 15:31:37 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, <linux-kernel@vger.kernel.org>
CC: David Airlie <airlied@linux.ie>, <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH 1/1] drm/omap: replace ALIGN(PAGE_SIZE) by PAGE_ALIGN
References: <1404240770-14938-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1404240770-14938-1-git-send-email-fabf@skynet.be>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="4Sm3NErWSKpdVaFaNxxMvXslhanjOxrdm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4Sm3NErWSKpdVaFaNxxMvXslhanjOxrdm
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/07/14 21:52, Fabian Frederick wrote:
> use mm.h definition
>=20
> Cc: David Airlie <airlied@linux.ie>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: dri-devel@lists.freedesktop.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/gpu/drm/omapdrm/omap_fbdev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/gpu/drm/omapdrm/omap_fbdev.c b/drivers/gpu/drm/oma=
pdrm/omap_fbdev.c
> index 1388ca7..8068612 100644
> --- a/drivers/gpu/drm/omapdrm/omap_fbdev.c
> +++ b/drivers/gpu/drm/omapdrm/omap_fbdev.c
> @@ -169,7 +169,7 @@ static int omap_fbdev_create(struct drm_fb_helper *=
helper,
>  	fbdev->ywrap_enabled =3D priv->has_dmm && ywrap_enabled;
>  	if (fbdev->ywrap_enabled) {
>  		/* need to align pitch to page size if using DMM scrolling */
> -		mode_cmd.pitches[0] =3D ALIGN(mode_cmd.pitches[0], PAGE_SIZE);
> +		mode_cmd.pitches[0] =3D PAGE_ALIGN(mode_cmd.pitches[0]);
>  	}
> =20
>  	/* allocate backing bo */
>=20

Thanks, queued for v3.18.

 Tomi



--4Sm3NErWSKpdVaFaNxxMvXslhanjOxrdm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/H4pAAoJEPo9qoy8lh71VDkP/3swDuFTM8BKXRa3Fr748H53
D9XL9WdpV+nBnN1khU7lhWFKO4x6Ft10CzcVMkj6ykRzehNd8TTt4IWnY/skmC8I
aPu4ZxF0Y+RrWaGWwXFtzxg/1UVj/Cy+hs6rscHL2dRu8dwieJbycicqjY6YZn83
1ltppGAfgoibvaLmp4UwR7mjFfnFyhUtlO5jiMxLzvk1+gIbN65AVqxqx3SxgU8h
Qzb0TaL5nsXaByv69vDKaPvKLMJQXQ2h1WH5QgxvBucu28/cbWMmYeojTTfjdxvB
yxKiALYgYMy3s9uzOkDtiOYFu28DNgOFp7dHlv6P8IM0jQV4psLoYp0t+pVajxCP
qqIcx2MScbhARDqYQACrSAoa2XeSKYeOKG8DA6zOnDka2XCtRsOwZcwioz0mu0sU
jkA2GvtHb+CG9LmuirxKx3NKKbe5KXxj5rGIoAn0p/J7wgvo4/rw5+f+nF3edc2g
Ijb9WCs5aqdaj4gM2DyR7fndJBY8TzgnIXaAECji513dmskclC30YImbrE+seUok
Hev5Zxfjz5yBi2RXPFURww0z+eXcaa2/or6tQtKQhJkrGvHaJLEXEwlUrZL/hxQ6
xZglnO01UX5V44Hv19z+mWntVrnkuEZ0gaCbXB6pjMq8WzXjE8DJx8Pi7jqgixI9
+TcxLnDxQ0CwitgxaUOb
=DSx0
-----END PGP SIGNATURE-----

--4Sm3NErWSKpdVaFaNxxMvXslhanjOxrdm--
