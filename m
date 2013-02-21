Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab3BUCBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 21:01:53 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:47838 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab3BUCBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 21:01:50 -0500
Date: Thu, 21 Feb 2013 13:01:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hauke Mehrtens <hauke@hauke-m.de>, John Crispin <blogic@openwrt.org>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: linux-next: manual merge of the net-next tree with the mips tree
Message-Id: <20130221130136.39e7e0fa939e749457ba1f52@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__21_Feb_2013_13_01_36_+1100_mW/_qQYgPDmuYDO4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Feb_2013_13_01_36_+1100_mW/_qQYgPDmuYDO4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in
include/linux/ssb/ssb_driver_gige.h between commit 111bd981e221 ("MIPS:
BCM47XX: add bcm47xx prefix in front of nvram function names") from the
mips tree and commit 180996c30517 ("ssb: get mac address from sprom
struct for gige driver") from the net-next tree.

I fixed it up (the latter seems to supercede the former, so I used that)
and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__21_Feb_2013_13_01_36_+1100_mW/_qQYgPDmuYDO4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRJYAAAAoJEECxmPOUX5FEt7QP/0avKyr2j4BUA22cL7/i2Tyi
2iDUOaxa2BvApBfxuSi5AMiQUNvQn/NPtPnhimpmfZxccwRelwubtT78GzsHFATO
pqno3nPBAVKvhtvSeMNm9vhOOJFeKdWGGXypW4/noZyw0OKuYXwvegFx3HU0iBdi
C/W3AOqTpFeDRWkXkTJnmcWRn2TkyRq0lOYOSFt1PC+J7HLvE8YSOqOwHI6664Ua
BKvaT2V7vPIYjq18X318d9qHPYJ3UY7cLH/5jw+F29C8l90kkLlCWwS5QtQ6TE55
xaNL/3ZNDrYKTcsZEzdgflpgtaLZIW2uqKctrxQFS2L+eDb5wNBQoLubfDihnl1H
qBRQTiYJOGG/aD8/07BhHaqIyOoruWQMxZKpDfzuOZ+00G2rOMD7DtNwsR81t6Fo
jHUNF54fZp/mYXG4EGLShhzWRCryqjTAhytCPbjizf1ON+WVp+8vCRS1vdTFHGgN
TpCuItFOPKS3B9P7XPqKIB9st8zYwkHtmYU2LtS4IPcbK5x/kvULJU3q9pPBMjGO
Z0AIsa3JE4PjGj5s7+HY1y3Vd6gFaeHKyHzxgxM1FJN/XymbCIj2Fjvw+CRFuLl4
jGzPkiQpPdQ050cQxTI5YC64ZTvaefuV2bCEBh8WkBU4NZVampaaW2lnzMj2guSh
H8MrWoLPZ4zFu4nY9KGC
=iaeS
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Feb_2013_13_01_36_+1100_mW/_qQYgPDmuYDO4--
