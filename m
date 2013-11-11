Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597Ab3KKBx4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 20:53:56 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58488 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab3KKBxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 20:53:48 -0500
Date: Mon, 11 Nov 2013 12:53:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Kleikamp <dave.kleikamp@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the aio-direct tree with the vfs tree
Message-Id: <20131111125328.ef8f0641ccdbb28a0d0564da@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__11_Nov_2013_12_53_28_+1100_JNsIcONsRvkXBi_p"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__11_Nov_2013_12_53_28_+1100_JNsIcONsRvkXBi_p
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the aio-direct tree got a conflict in
drivers/mtd/nand/nandsim.c between commit 72c2d5319200 ("file->f_op is
never NULL...") from the vfs tree and commit dd458300240b ("fs: create
file_readable() and file_writable() functions") from the aio-direct tree.

I fixed it up (I just used the aio-direct tree version) and can carry the
fix as necessary (no action is required).

There may be some question as to whether file_readable() needs to check
its filp argument for NULL, but that would require auditing all its call
sites.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__11_Nov_2013_12_53_28_+1100_JNsIcONsRvkXBi_p
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSgDikAAoJEMDTa8Ir7ZwV1SAP/3i2t98494PDNNKM30KfIGPA
hopWtqZikqgslbwdBBfjtJVFTym3zV7Le73IRJZihXhpDvLjjf87b7gJAiDD4su9
Ixzi5w5G0vcsGVHqEVR+nECa+uZ0O/UOM9DHS4f1exvDsyiX8i16ysNVXnY0pSUf
Lyv+OBgLhQwPHEDMAb1vP5gBe0nt9ZFeqdgx1E0GOzj2iBuL5ZEyNLgJOqKqAmf5
6lJ6Xj4ygYBvdbH3w9HRen0daBuZUhyDGyiUc0fMhuYuR+XsdtPnXsq/R/YD/8g/
0F4qxZvKZfHQteAjFi4pIc9INaopkHVvtbjstSn7ffHpxbdpNKzODihYZUCOYkNa
crMO36tUY7HzURWSdELdQkIbOmatA8gNUQTz8c0bYBmnH8DqISCgnYDnwZYkAAqK
bh7UcVKIwSphCqD59HJ29SjyvTS+NTm2g6y8/A1vqPRX/aUIyDMOGIVrRPiVnN/c
5ja83o7Tzypaaf+sDdcdYgklPdtWF/HNAtRoYi5Aod1HceF2kodPDBL0danULCvD
T3HLYFLBOce+iGtbmG43I1zthJi5oAVUTtBx4jxPqgAp/IOVyeHYQtE6I85hnceB
v6Zn44ww1sfbItdIXS1H6WRLWX22Z5tme8rJxxOcdVqm0smUsuMwqyE2fa29x9XF
ZpkQgcTT3gLO71D3C2YX
=NTJK
-----END PGP SIGNATURE-----

--Signature=_Mon__11_Nov_2013_12_53_28_+1100_JNsIcONsRvkXBi_p--
