Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbaIICnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 22:43:17 -0400
Received: from ozlabs.org ([103.22.144.67]:39618 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512AbaIICnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 22:43:16 -0400
Date: Tue, 9 Sep 2014 12:43:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the v4l-dvb tree
Message-ID: <20140909124306.2d5a0d76@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/sPsHYl2js_flSE/tgXQJb3X"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/sPsHYl2js_flSE/tgXQJb3X
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

After merging the v4l-dvb tree, today's linux-next build (x86_64 allmodconf=
ig)
failed like this:

ERROR: "omap_stop_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] =
undefined!
ERROR: "omap_start_dma" [drivers/media/platform/soc_camera/omap1_camera.ko]=
 undefined!
ERROR: "omap_dma_link_lch" [drivers/media/platform/soc_camera/omap1_camera.=
ko] undefined!
ERROR: "omap_set_dma_dest_burst_mode" [drivers/media/platform/soc_camera/om=
ap1_camera.ko] undefined!
ERROR: "omap_set_dma_src_params" [drivers/media/platform/soc_camera/omap1_c=
amera.ko] undefined!
ERROR: "omap_request_dma" [drivers/media/platform/soc_camera/omap1_camera.k=
o] undefined!
ERROR: "omap_set_dma_transfer_params" [drivers/media/platform/soc_camera/om=
ap1_camera.ko] undefined!
ERROR: "omap_set_dma_dest_params" [drivers/media/platform/soc_camera/omap1_=
camera.ko] undefined!
ERROR: "omap_free_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] =
undefined!
ERROR: "__bad_ndelay" [drivers/media/platform/s5p-jpeg/s5p-jpeg.ko] undefin=
ed!
ERROR: "vpif_lock" [drivers/media/platform/davinci/vpif_display.ko] undefin=
ed!
ERROR: "vpif_lock" [drivers/media/platform/davinci/vpif_capture.ko] undefin=
ed!

I have used the v4l-dvb tree from next-20140908 for today.

There were also lots of new warnings like:

drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c: In function 's5p_mfc_get_c=
rop_info_h_v6':
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:2039:3: warning: cast from =
pointer to integer of different size [-Wpointer-to-int-cast]
   (unsigned int) ctx->dev->mfc_regs->d_display_crop_info1);
   ^

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/sPsHYl2js_flSE/tgXQJb3X
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUDmlBAAoJEMDTa8Ir7ZwVUScQAJD5Gg3WHokB/NjVnyDiZM+M
AM02zwBuYFBXqURlep/vagqqD8bZfK64a9ITI8sNQZdhM9BM+GNUTJfHPrgTLBnY
yPCsnoaUm8TdY/Vy2mZx0LxaV7EfnxEC3KISLWDAJfVNLIQMk5PU0KzwUkKZmulf
svK5w6oDwe9LkQmJ0cYIMXbTtddxcBjNYIBX6l6xPUgJUxJnoKjj00gb4S+6RTdm
+1t0vxltQrBRi0rz+ELrK3WWzNdgoSOPaLm40X7DharDTluhX1HuBa+g0TvomP8+
g71vcuyyfkhv1hq5lchgMd8yoIx1+GgUQL18/Ca+28R7swpNIWnXwsh5LRZVQNmm
TBXlyxUcpNGic9eUpzX3NWeYnCPyxzUE628D6OAOhmKBEWDRPBgodFH1dTOMcE/i
ECu9fAxKiRIJpQX4aIxTVvqtZxiJmmdJ+/uudcRy8JwVH7+37Si9xUV5AqCwqku7
6YXw9jhVEXml5GV3h/53Iy1+VSo4xXdgai0MRrONTFDG3X9jNCuc3JyEQ9OKPxEP
ksjHZhUCHNw5hSVrgv3QAl4lE2C34tSvuVK9xno2ZG9MWyxrUlqH+fqXX+RfAYxK
aNPplb5n14mYigk/7whvvOU7z5Jb0mq9HFCiw9Hjx4RhzHNF/sMocuSs6rJ7cQM9
KqZ57GDviiHch/e7YL3l
=dZBi
-----END PGP SIGNATURE-----

--Sig_/sPsHYl2js_flSE/tgXQJb3X--
