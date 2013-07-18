Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938Ab3GRCJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 22:09:20 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59335 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab3GRCJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 22:09:18 -0400
Date: Thu, 18 Jul 2013 12:09:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Jul 17
Message-Id: <20130718120916.3bfd1ccdefdbc9e4fe907927@canb.auug.org.au>
In-Reply-To: <20130718093824.d449a17a810f8898f815c199@canb.auug.org.au>
References: <20130717141335.02a3ad620bdb473935d05aa3@canb.auug.org.au>
	<20130717083134.GB22506@sirena.org.uk>
	<20130718093824.d449a17a810f8898f815c199@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__18_Jul_2013_12_09_16_+1000_sYQP+s4B9ZR7rd_v"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__18_Jul_2013_12_09_16_+1000_sYQP+s4B9ZR7rd_v
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Thu, 18 Jul 2013 09:38:24 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> So these are the errors I got yesterday:
>=20
> sound/soc/fsl/imx-mc13783.c:23:28: fatal error: asm/mach-types.h: No such=
 file or directory
>  #include <asm/mach-types.h>
>                             ^
>=20
> I didn't look closely enough, because this is the same error that I got
> the previous day, but in a different file.

I got this again today.

> sound/soc/omap/omap-pcm.c: In function 'omap_pcm_preallocate_dma_buffer':
> sound/soc/omap/omap-pcm.c:171:2: error: implicit declaration of function =
'dma_alloc_writecombine' [-Werror=3Dimplicit-function-declaration]
>   buf->area =3D dma_alloc_writecombine(pcm->card->dev, size,
>   ^
> sound/soc/omap/omap-pcm.c:171:12: warning: assignment makes pointer from =
integer without a cast [enabled by default]
>   buf->area =3D dma_alloc_writecombine(pcm->card->dev, size,
>             ^
> sound/soc/omap/omap-pcm.c: In function 'omap_pcm_free_dma_buffers':
> sound/soc/omap/omap-pcm.c:195:3: error: implicit declaration of function =
'dma_free_writecombine' [-Werror=3Dimplicit-function-declaration]
>    dma_free_writecombine(pcm->card->dev, buf->bytes,
>    ^
>=20
> These are the same as the day before.

These are now gone.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__18_Jul_2013_12_09_16_+1000_sYQP+s4B9ZR7rd_v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR505MAAoJEECxmPOUX5FElrQP/ikfLhMx5EI0EgtoNpP2F/5u
WA9IK0ah4JVczZu8PM1loZMnmSq0fgC5+N+g/Jtu/TiKxfetSZwgCrUywnxBLtcg
O9kPC6aJaESEC+fv1sIgsgfgloxuDUqM2vSiqHTL9sXdXhr/rXhQltvAoxcIMHJ7
zfyNfhx+BYiEvUpyLgNbiVyaW5J8l+xnUibQ89fMykuvvgUd8pvykrQQNSw2yLFL
FdW/mAaJqAiMhxYuruoZyOFLcAz5+JsL19vVA6f13lEagWGWmLFZSuN3Z+FjRCNC
i1tooxhQpAVIJF1pYCrRLl/YcmndrSv6XRFy2X4vrcQUMRdD5muCHDxe7xnVA87a
liOzr/iWyLJ+EiB422U3H4KvRyV6jObsyHhfY4G7SqoRC+C/y95N5SNf8rWi9cwA
S5rraaOG803m8/Svzl27rQ2gKtRBC1uPMXgPnBrzuPhS0F5iuF2AaoXGV+jIyW+l
oC9L8uknorchbD6EEuu4c2Su9yAb4RvMV5rESvINhTVk3zXfyT170Hvpozhro2ZI
D3XiR+RfPfjfJWK+GCdjQEAmX9GnTyq5o5Sk8Ifwk0lIqULTG6/GaFyTsCyI+wDK
/MZnL0J2EBJ7/HNteYLWNsdkE/j80pY+nmTSGjL9aP9yJ3E9KqhFeM1Y63pyKtyK
wYhM+typKhYzaDN/hEhL
=6ydK
-----END PGP SIGNATURE-----

--Signature=_Thu__18_Jul_2013_12_09_16_+1000_sYQP+s4B9ZR7rd_v--
