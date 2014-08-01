Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbaHAGVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 02:21:52 -0400
Received: from ozlabs.org ([103.22.144.67]:55239 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624AbaHAGVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 02:21:50 -0400
Date: Fri, 1 Aug 2014 16:21:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>,
        Kristina =?UTF-8?B?TWFydMWhZW5rbw==?= 
	<kristina.martsenko@gmail.com>
Subject: linux-next: manual merge of the staging tree with the  tree
Message-ID: <20140801162142.24086152@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/kgiKMbccyYVOg2b2Zm2QGIN"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/kgiKMbccyYVOg2b2Zm2QGIN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
MAINTAINERS between commit 7eea35fe3df8 ("[media] MAINTAINERS: Update
go7007 pattern") from the v4l-dvb tree and commit 0d317b91d6d8
("staging: frontier: remove driver") from the staging tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc MAINTAINERS
index 10390ced5206,6d2c52ea407d..000000000000
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@@ -8685,11 -8542,11 +8661,6 @@@ M:	Marek Belisko <marek.belisko@gmail.c
  S:	Odd Fixes
  F:	drivers/staging/ft1000/
 =20
- STAGING - FRONTIER TRANZPORT AND ALPHATRACK
- M:	David T=C3=A4ht <d@teklibre.com>
- S:	Odd Fixes
- F:	drivers/staging/frontier/
 -STAGING - GO7007 MPEG CODEC
 -M:	Hans Verkuil <hans.verkuil@cisco.com>
 -S:	Maintained
 -F:	drivers/staging/media/go7007/
--
  STAGING - INDUSTRIAL IO
  M:	Jonathan Cameron <jic23@kernel.org>
  L:	linux-iio@vger.kernel.org

--Sig_/kgiKMbccyYVOg2b2Zm2QGIN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT2zH7AAoJEMDTa8Ir7ZwVUkMP/2g+m5pGSWe/GWlw0pHYBTVp
F4qmHixYQ221Itm7ba9TZNUF9w3zE4FDapP1v12sCMmu6ii7aEbVFzrLoBbsmE/K
BcI/cz0OAthEJTWMPQIsHyK4yUg3Wnz/Ny6qZ0WaQ3jmpBlYu8sD9cJueIs6rwVd
QqzqBiYaDKhcmqwARLqi13ZHQ75u1AtzXhrqN9sQpXgONTm0kLlfBLDkyWdHD7fX
nJm5o0KJHQQjpiFcSxMmG9bxWv6cg74XYy7RYdjimkAq3Jc8oFX6x9fyLYKTVF8C
wNFxENs6OzNsU1r+7T+mlfWiT20O1dLl8P0+6qfnVTJyCOcNG/RkSne+cIPq9YxU
ZANkfFMyUYJoOwX25Ka/4yKL168EREbpK0WibdJq4hWNhAJ7HGhTw6YGZUALVXpZ
fJDnK0e330xSISHbDOp2oaZxckwP4HrllQ3h5PpuQomveMc09TrbzCk7pfKl/DPW
tC3VfOsb2Dk5yp/I2Y/T4/+bPp0mAuavMPq42d1kDSIp0koeci9pdGolzGCiZOEj
SBQT01ANITWpD15YOwqoDmZf8TQ/YNdSorFYmMt118OXPs+m0TRZhEIWmTdXCRLV
nVaiEyEwAc2+de4rm+jZIY+77uG9BZge+Z9+1ADeHXPSrNdXlQgjr449nNCX4PNY
TJftzxtW/0ViZQc43qla
=sxH7
-----END PGP SIGNATURE-----

--Sig_/kgiKMbccyYVOg2b2Zm2QGIN--
