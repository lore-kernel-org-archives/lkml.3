Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbaIIDFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 23:05:35 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46623 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbaIIDFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 23:05:34 -0400
Date: Tue, 9 Sep 2014 00:05:09 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
Message-ID: <20140909000509.13d83a83@recife.lan>
In-Reply-To: <20140909124306.2d5a0d76@canb.auug.org.au>
References: <20140909124306.2d5a0d76@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/=e04jII9HXpAwXZobskLxgs"; protocol="application/pgp-signature"
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/=e04jII9HXpAwXZobskLxgs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

Em Tue, 9 Sep 2014 12:43:06 +1000
Stephen Rothwell <sfr@canb.auug.org.au> escreveu:

> Hi Mauro,
>=20
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
>=20

Yeah, there are several drivers that are now enabled with COMPILE_TEST.

Not sure what's the best thing to do with those errors. Perhaps I should
add some stub functions for those drivers to not complain about linking
issues if COMPILE_TEST.

> I have used the v4l-dvb tree from next-20140908 for today.

>=20
> There were also lots of new warnings like:
>=20
> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c: In function 's5p_mfc_get=
_crop_info_h_v6':
> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:2039:3: warning: cast fro=
m pointer to integer of different size [-Wpointer-to-int-cast]
>    (unsigned int) ctx->dev->mfc_regs->d_display_crop_info1);
>    ^
>=20

Those warnings are harmless in practice, but they should be fixed.

I'll be handling them before the next merge window.

Regards,
Mauro

--Sig_/=e04jII9HXpAwXZobskLxgs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUDm5tAAoJEAhfPr2O5OEV/sAP/0RWkAGX5C7ZuyXIa28SHAvp
cHHJHWhGSHmaCQErJxLEeK0veVSIQsE40tnKo4K1NgTGXj+Qec3vkizs33T7vKkl
y0Ub9p0tCwTW6MT6vniEQEKg/JX2tAWUgAkFQ+y4PqFDNE+BChzCW4H50oEXyF+s
9idPWW/zRuaD7MT3hfuQTCERytRKuILsB4AK5cRAOiGVojCt3RMiD6/agkNuXAqr
tOV5PABs6QZErJCEZoSLA6UibIYTJ4n5GMaulW8PRmYr/QoXUAiIkOiHfg5UnMDm
WaWWAhROFpmEUl2Uou4RQcYEkFDhpE/9IndegbXnPmZq8Eab7clJfr9to7zFMhKE
dlC21m/v5RHEsEXwRcQs9Ac0OtCy2jnwTwls6vUT2mJ+21G6lvbTBrha9fCtoaTC
ivlba35VmG0uWh9+lWDQqNa7bt+ZZEW8wFvtoaGNpiCYfTo2KIy/OIhimEdGdZez
/9vLB/+4JaEpLmBQIJs/gdFuz9pnfh1hDJsOChshmWn8SFPpyXpDmcuA7xhiXk6L
VRKJTjVr+Vu9HoZaFobjD/6MwtAEpnGGtIGngUS99KzU252IjY/VJ0kv9wq/7aFN
IiQUFEfdJH60rxYO3nLxOD2k5BwmIY+cEEDcuMi39SeS9nvto128Y4tRQg+6k3g9
R5ab4YFSjLPxk2zcpkpk
=WySB
-----END PGP SIGNATURE-----

--Sig_/=e04jII9HXpAwXZobskLxgs--
