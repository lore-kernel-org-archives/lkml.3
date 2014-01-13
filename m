Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220AbaAMFAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 00:00:18 -0500
Received: from ozlabs.org ([203.10.76.45]:54863 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbaAMFAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 00:00:15 -0500
Date: Mon, 13 Jan 2014 16:00:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Turquette <mturquette@linaro.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>
Subject: linux-next: manual merge of the clk tree with the v4l-dvb tree
Message-Id: <20140113160001.f2b359a6a8cc312fd1286855@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_Jan_2014_16_00_01_+1100_Hk_IXk2xqxRy4HQW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Jan_2014_16_00_01_+1100_Hk_IXk2xqxRy4HQW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

Today's linux-next merge of the clk tree got a conflict in MAINTAINERS
between commit 7d459937dc09 ("[media] Add driver for Samsung S5K5BAF
camera sensor") from the v4l-dvb tree and commit 310e39c9b320
("MAINTAINERS: Add entry for Samsung SoC clock drivers") from the clk
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc MAINTAINERS
index 0188725a5658,273311e10b5b..000000000000
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@@ -7460,13 -7334,12 +7468,19 @@@ L:	linux-media@vger.kernel.or
  S:	Supported
  F:	drivers/media/i2c/s5c73m3/*
 =20
 +SAMSUNG S5K5BAF CAMERA DRIVER
 +M:	Kyungmin Park <kyungmin.park@samsung.com>
 +M:	Andrzej Hajda <a.hajda@samsung.com>
 +L:	linux-media@vger.kernel.org
 +S:	Supported
 +F:	drivers/media/i2c/s5k5baf.c
 +
+ SAMSUNG SOC CLOCK DRIVERS
+ M:	Tomasz Figa <t.figa@samsung.com>
+ S:	Supported
+ L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
+ F:	drivers/clk/samsung/
+=20
  SERIAL DRIVERS
  M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
  L:	linux-serial@vger.kernel.org

--Signature=_Mon__13_Jan_2014_16_00_01_+1100_Hk_IXk2xqxRy4HQW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS03LVAAoJEMDTa8Ir7ZwVMMgQAIDt4HgQiCn18/agE1q+tkva
xyXrdvzt7GC/D8h3BdHRIbaETTjclSiYiOPuY9S7Us+bDNhlNAFHs716Xga8WADT
YRVSVgaKfsPrBi4ATcpkNeZZTE6rlBDsFe1lFVOxEt133ieOyaASr4nrCRXsxVjv
Ix7PU2Z9YzeXwjmd5O++81hGLBsoL4EB2IYD5sINtB8WyznW3YNvwY8rjqcQBowH
rWW5GfD0ESlWiXJkKjOvACmzYqe7vw88pNj2IUx0QhtuiZnAA+AA499WeHBrvp4S
h7fllwCBq4CMbrudOaA4aga50TNEqh5+hvSJG7e+vVLn7h7vZopsCa/N1TljC/OC
4yOQF1girnxrM4R+huJEMtZoK5mJFGzp4jnafgn/JyWXFwBvsrlW8csCZx21WDlj
Ln8iTqQCJ5Kh0YWJXUxfTE4pIaNkpLS4jxOu9RfXbvdXpd74WffipuOm/yoUjYMn
KZ2JAidY6ezXePq9O1ZSzIrnpBbTVL40jiacG12h9bMSsMdSx39cXsBjSd/eJmBN
DUozR1jjXS/aOnMQxiymxWvsqxo9DNy8rdlI4x2qrAOJMqxitNs4s7rNpnt2F5tq
afmzKNPzMQUax0dGhzislt/EuQeMCBk6LWg9B6M1Zuq481TSzLkz0Kp/KntDod4L
3T5SM8Hwme79y7rWZtA3
=Igzc
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Jan_2014_16_00_01_+1100_Hk_IXk2xqxRy4HQW--
