Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab3IAXCU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 19:02:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60345 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753509Ab3IAXCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 19:02:19 -0400
Message-ID: <1378076526.25743.55.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH] pch_dma: Add MODULE_DEVICE_TABLE
From: Ben Hutchings <ben@decadent.org.uk>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Mon, 02 Sep 2013 00:02:06 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-w+FPu2n/obLr/Zens6EY"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-w+FPu2n/obLr/Zens6EY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

pch_dma currently isn't auto-loaded if built as a module.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
Compile-tested only.

Ben.

 drivers/dma/pch_dma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 0bbdea5..c4b02d1 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -1036,3 +1036,4 @@ MODULE_DESCRIPTION("Intel EG20T PCH / LAPIS Semicon M=
L7213/ML7223/ML7831 IOH "
 		   "DMA controller driver");
 MODULE_AUTHOR("Yong Wang <yong.y.wang@intel.com>");
 MODULE_LICENSE("GPL v2");
+MODULE_DEVICE_TABLE(pci, pch_dma_id_table);


--=-w+FPu2n/obLr/Zens6EY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUiPHbue/yOyVhhEJAQoZ5RAAr8WjIkavWTbfFX5jDIoHNEqqvLMbLVzt
v8FScOd0MUfhrRlCA7qL+3nuSmJ9dtNla3dNHYXNk2wknChEWhun7v38eHggbYpR
1RAweOHAVMXt3C+eoKOJ6l2os5UHxs/Bm2I5pLzgOsUn8nL3ROjDB68FIjBvQSJH
ZEyO6NqPnwSxEi7eYE79NZPzQuHUAlE+WgH+4B2Dp2TozFQotQjBimD/O9Vnvvke
d3o15iBI5b79POefexQPJJo/R3BMcDUZSFtY1YqGWu4uei4UJe7dgB0VP7vZ789q
P5eqppu0fwuEnDyPmK3waefZiP+6LXjDotTusrj7K/qSGA1cTYYkdvXZgHp/bxwn
4WLKyvBEmwZ33qs65vlr7dlXUoYzIR6pZYyP9fzoVitxcEBL0WWIbLyc0wYRxNNF
FAmRt//6Qg2M902WuH4HChYu/f/fmaq/LMYhkO1LOjiinldtAORqKYDQPgA6dOmm
z1w/UwxvNyVafteAPC1MHs0AheldDjmbMtVMmnNLfsVL/pfSAj8M5+LM0eUNjqf+
B+DoLZK87bW9ikqJz25jWvPStkm+AfiL7frBAt7W1NJBPVDj779bpGw0i/weDr2U
3bizseMVOJq1+xQX9W0zNFwT6317w26cLHGy32xkVeXvVvGsy3Yie6Htrpa7os0P
qJh8goeyBPw=
=i2Wi
-----END PGP SIGNATURE-----

--=-w+FPu2n/obLr/Zens6EY--
