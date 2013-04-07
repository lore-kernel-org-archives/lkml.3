Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400Ab3DGLYn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 07:24:43 -0400
Received: from mail.gw90.de ([188.40.100.199]:39491 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933368Ab3DGLYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 07:24:42 -0400
Message-ID: <1365333863.7207.14.camel@mattotaupa>
Subject: Re: [PATCH] drivers/gpu/drm/nouveau: remove erroneous semicolon
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Chen Gang <gang.chen@asianux.com>
Cc: airlied@linux.ie, bskeggs@redhat.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Date: Sun, 07 Apr 2013 13:24:23 +0200
In-Reply-To: <51529E77.2010906@asianux.com>
References: <51529E77.2010906@asianux.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-HtPrv3sOPzaIo95CQvIj"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HtPrv3sOPzaIo95CQvIj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Chen,


Am Mittwoch, den 27.03.2013, 15:23 +0800 schrieb Chen Gang:
>   need remove semicolon, or always return true.

do you know if this cause any problems? Did you find this reading the
code or by using some tools?

> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  drivers/gpu/drm/nouveau/nv50_display.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/nouveau/nv50_display.c b/drivers/gpu/drm/nou=
veau/nv50_display.c
> index 7f0e6c3..1ddc03e 100644
> --- a/drivers/gpu/drm/nouveau/nv50_display.c
> +++ b/drivers/gpu/drm/nouveau/nv50_display.c
> @@ -479,7 +479,7 @@ nv50_display_flip_wait(void *data)
>  {
>  	struct nv50_display_flip *flip =3D data;
>  	if (nouveau_bo_rd32(flip->disp->sync, flip->chan->addr / 4) =3D=3D
> -					      flip->chan->data);
> +					      flip->chan->data)
>  		return true;
>  	usleep_range(1, 2);
>  	return false;

Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>


Thanks,

Paul

--=-HtPrv3sOPzaIo95CQvIj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlFhV2cACgkQPX1aK2wOHVhMfQCeKdcWk/a73SRXPutcW0oQc88l
yQoAnRbeLu4H/H9h1AvucKBxnDNvCT15
=fYBS
-----END PGP SIGNATURE-----

--=-HtPrv3sOPzaIo95CQvIj--

