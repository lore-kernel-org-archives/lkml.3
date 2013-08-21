Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab3HUEI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 00:08:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47699 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab3HUEI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 00:08:58 -0400
Date: Wed, 21 Aug 2013 14:08:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masanari Iida <standby24x7@gmail.com>, Joe Perches <joe@perches.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: linux-next: manual merge of the trivial tree with the crypto tree
Message-Id: <20130821140846.d4d85896c7d5afb06b6fc16a@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__21_Aug_2013_14_08_46_+1000_VMym3w9L9bSB4R9C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Aug_2013_14_08_46_+1000_VMym3w9L9bSB4R9C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
drivers/crypto/ux500/hash/hash_core.c between commit 69d2884debaa
("crypto: ux500 - Fix logging, make arrays const, neatening") from the
crypto tree and commit 0b1587b18bfe ("treewide: Fix typo in printk") from
the trivial tree.

I fixed it up (the former is a superset of the latter, so I used that)
and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__21_Aug_2013_14_08_46_+1000_VMym3w9L9bSB4R9C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSFD1SAAoJEECxmPOUX5FEub0P/RPTOm3P3WJ+/fwT6w6LJ0DW
FxAVq+C9DwZ74y7dTx49ff8okL+5da0uX1iT6fXzv+DOkMD/qZZ/vSOAU/YZ7Slf
+3TNVaOur8bMBHHF/xKjBB1yAMbJ9uGqZuTYMyn+bvajmMQJksqdGisFLk9WUGSr
2DtSuTg2xtC9VUyPMO7YSPJtAYhR4AZ3Lecukk4R6ZjYDqu9X7nETHRZG1XS/Nzv
Rl0c+xJbRWFS5efzG/EhtPve48FBFGmBmhz03QjHYAd4RJ+g09dWmFIMIpBHke0A
lscIdBeabCnKSashpg+YhJbri47nXX26xNGE7HkZ0DTt4VBlkUoDm+uk0hAQBLo2
lkZc0t6dvXcT+6D0Yfr6Nkex6BjgGlHdGO4TVXydaEmrVVyBXq4u2c1hTz6+vYqW
av12BMk+l8oH5Xsse72KnpTGH7lwm0KMGC1NxR+f+ZsNbiAAZWq0aRi94SN7N4Ht
h3/ls9dwC3R5HvpHiqsm49PsLMdYWEo5/7TsaSvsAvBLQIoL/0UDoMRCRhQ7ep3F
16ssdJhV3bStOM0iUrp6hOT8ZlK9Plk5IIaD9ZSmQrElMwpcx1gH/JcYlj/Hyv1O
y4KxghCQgG5mcD7g5rHHW6L9BDpaQy3yShyFBf2ETRo8gAViu6SixvEXCiMJUbuY
pSw69N69ZuZv5oegdOHr
=503s
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Aug_2013_14_08_46_+1000_VMym3w9L9bSB4R9C--
