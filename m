Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbaIQDru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 23:47:50 -0400
Received: from ozlabs.org ([103.22.144.67]:58661 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886AbaIQDrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 23:47:48 -0400
Date: Wed, 17 Sep 2014 13:47:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
Message-ID: <20140917134740.32dae50b@canb.auug.org.au>
In-Reply-To: <20140909124306.2d5a0d76@canb.auug.org.au>
References: <20140909124306.2d5a0d76@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/rpL3zsI5C.XEYuJq/0jx+ep"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/rpL3zsI5C.XEYuJq/0jx+ep
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 9 Sep 2014 12:43:06 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> After merging the v4l-dvb tree, today's linux-next build (x86_64 allmodco=
nfig)
> failed like this:
>=20
> ERROR: "omap_stop_dma" [drivers/media/platform/soc_camera/omap1_camera.ko=
] undefined!
> ERROR: "omap_start_dma" [drivers/media/platform/soc_camera/omap1_camera.k=
o] undefined!
> ERROR: "omap_dma_link_lch" [drivers/media/platform/soc_camera/omap1_camer=
a.ko] undefined!
> ERROR: "omap_set_dma_dest_burst_mode" [drivers/media/platform/soc_camera/=
omap1_camera.ko] undefined!
> ERROR: "omap_set_dma_src_params" [drivers/media/platform/soc_camera/omap1=
_camera.ko] undefined!
> ERROR: "omap_request_dma" [drivers/media/platform/soc_camera/omap1_camera=
.ko] undefined!
> ERROR: "omap_set_dma_transfer_params" [drivers/media/platform/soc_camera/=
omap1_camera.ko] undefined!
> ERROR: "omap_set_dma_dest_params" [drivers/media/platform/soc_camera/omap=
1_camera.ko] undefined!
> ERROR: "omap_free_dma" [drivers/media/platform/soc_camera/omap1_camera.ko=
] undefined!
> ERROR: "__bad_ndelay" [drivers/media/platform/s5p-jpeg/s5p-jpeg.ko] undef=
ined!
> ERROR: "vpif_lock" [drivers/media/platform/davinci/vpif_display.ko] undef=
ined!
> ERROR: "vpif_lock" [drivers/media/platform/davinci/vpif_capture.ko] undef=
ined!

Still getting these ...

> I have used the v4l-dvb tree from next-20140908 for today.

So this still applies.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/rpL3zsI5C.XEYuJq/0jx+ep
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUGQRhAAoJEMDTa8Ir7ZwVeN0QAJatBYn5HBWmet/x+Zr+rzK7
o2zt8krLEgcNZDCW2YdTHsMMNdxXZg2j8CqC1WK3VmFn2t/ZzXPH3N0HzjMHlz+n
bewnkiIsAjH0TxL0SAW7GCgGlvU4nvGqv54Hr8v83qCEZXB0JILNehzT5CFdlS5e
+pVX91uRyP/CTndNY0k97SNcl2cz+QaqNZB9CLITWF/6X+7lR5CckcTzlBuAdhrQ
6G6ioRa0dNeSEztpwzXjBRQxTEbzWl+iKLfrixGrk5XkQ1zF4GcZPMBnnwoPC10S
JxgNxhb47kE/P9/bWd2pZDCgKcYbTnDYtKfd6L/c9/zCsMybNK1NXfmDtEaBtZPy
UUWjh+M6sLPnrS5b/3aGhbbNncIZdKEFjtvSBviQMWgYw7MCCkIS39Zap/wnSYpo
eIM+HBkDa7UzOxfScJOrFcv7N3R3+0iXTBnLljwGKpR7GaXRCKYRvzEU0pOrw8Jr
in+NP33f6cguZ/qjpYd8Uq0WB/S7YqknlNY0aN+F5uxSId1SEGDDItcC+4PKrpIU
FlWANX/uRiR0LWqBimUhw2P/fC78KbyN9am+fNZJCptRHYEBr5VnA4I6255n2BUn
KMnwyNJEQZ4iUdyCjEouEJi6A3E+oPh5udsGRTwBYFdFQI0RLCRkKY1R+cgDcr8m
zs+b/ApNiP/Nx3GPikS7
=3WBV
-----END PGP SIGNATURE-----

--Sig_/rpL3zsI5C.XEYuJq/0jx+ep--
