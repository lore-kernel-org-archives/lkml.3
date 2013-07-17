Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934756Ab3GQXih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:38:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46800 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab3GQXie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 19:38:34 -0400
Date: Thu, 18 Jul 2013 09:38:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Jul 17
Message-Id: <20130718093824.d449a17a810f8898f815c199@canb.auug.org.au>
In-Reply-To: <20130717083134.GB22506@sirena.org.uk>
References: <20130717141335.02a3ad620bdb473935d05aa3@canb.auug.org.au>
	<20130717083134.GB22506@sirena.org.uk>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__18_Jul_2013_09_38_24_+1000_oQG.TdiODLshLYXk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__18_Jul_2013_09_38_24_+1000_oQG.TdiODLshLYXk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

[Sorry for the delay, I had to go into work to find the logs of
yesterday's builds.]

On Wed, 17 Jul 2013 09:31:34 +0100 Mark Brown <broonie@kernel.org> wrote:
>
> On Wed, Jul 17, 2013 at 02:13:35PM +1000, Stephen Rothwell wrote:
>=20
> > The sound-asoc tree still has its build failure so I used the version f=
rom
> > next-20130715.
>=20
> I'd have expected both of those to have been fixed.  Are you sure you're
> seeing the same issue?

So these are the errors I got yesterday:

sound/soc/fsl/imx-mc13783.c:23:28: fatal error: asm/mach-types.h: No such f=
ile or directory
 #include <asm/mach-types.h>
                            ^

I didn't look closely enough, because this is the same error that I got
the previous day, but in a different file.

sound/soc/omap/omap-pcm.c: In function 'omap_pcm_preallocate_dma_buffer':
sound/soc/omap/omap-pcm.c:171:2: error: implicit declaration of function 'd=
ma_alloc_writecombine' [-Werror=3Dimplicit-function-declaration]
  buf->area =3D dma_alloc_writecombine(pcm->card->dev, size,
  ^
sound/soc/omap/omap-pcm.c:171:12: warning: assignment makes pointer from in=
teger without a cast [enabled by default]
  buf->area =3D dma_alloc_writecombine(pcm->card->dev, size,
            ^
sound/soc/omap/omap-pcm.c: In function 'omap_pcm_free_dma_buffers':
sound/soc/omap/omap-pcm.c:195:3: error: implicit declaration of function 'd=
ma_free_writecombine' [-Werror=3Dimplicit-function-declaration]
   dma_free_writecombine(pcm->card->dev, buf->bytes,
   ^

These are the same as the day before.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__18_Jul_2013_09_38_24_+1000_oQG.TdiODLshLYXk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR5yr0AAoJEECxmPOUX5FER+0P/iojiheklwrgThvNnSosMT8U
nlhW/CFsgItQ2Swgel8CCx4rreUCyayHtPZlZyzSQ/wmws4+EjEXrI0snnf33syf
eAzJkyjcU2zk6pIc8YZVHa9ddqIBd6f+fc0+FW7WaCMjgDwXlDpNJ4Z8WPWQ/KuS
TUYApAN7YD3Qj62alXzfwz9GDdqRhdPWEMQ2ZfsC8ZZsECDqO5xq/p2Mo1rTVyJy
RWJkYk4sq8leAZPIzqO/AXKjNiZePQEoIaGRxL6KbvIupYy0B9GA6xW5Tr1HnyFo
xQ60sBGk4j4NYs0nrtyntHNNZW+Rm3q5INYpeF/lJTvwqfdFfoqcG8KeoWegZf8M
QvcjwDjZtBEetbqQVWfY8rYh3OG4NNprmCETCZxcZcVaAJvuOfBOwMfVMorcnExX
AEJjxLXLnIVNLK+4Fl8OseeZ6DVN+JGGneC8tM3//9GevfaE+WVitcU0D72Vn13O
S5T+FlD1hoXhEth3i0b0E4vIsE5ANfO77CtsclBxP2qFTnTmovEDKuTyE26Mc7iI
7DkLygYe6fIpvyZzVGiyxUQiK5FxO5uFDFQpDtG8uGCPv5VSFF0a3/fInwMVi0cY
isa7HakdYE90UrGFjJY9C1/qNhrixuB3i7QR/h+6zAHJFT/w6bsAOr2XXThWCYWs
CQWrgXHqex/C2oCmWEGS
=oFtH
-----END PGP SIGNATURE-----

--Signature=_Thu__18_Jul_2013_09_38_24_+1000_oQG.TdiODLshLYXk--
