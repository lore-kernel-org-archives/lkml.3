Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab3KZCaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 21:30:15 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46195 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3KZCaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 21:30:14 -0500
Date: Tue, 26 Nov 2013 13:29:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: linux-next: build warnings after merge of the block tree
Message-Id: <20131126132946.e402679788ae8269f0c5128a@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__26_Nov_2013_13_29_46_+1100_G8qkB_sFFX6B/9G6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Nov_2013_13_29_46_+1100_G8qkB_sFFX6B/9G6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

After merging the block tree, today's linux-next build (arm
multi_v7_defconfig) produced these warnings:

block/blk-merge.c: In function 'blk_rq_map_sg':
block/blk-merge.c:133:8: warning: 'bvprv.bv_len' may be used uninitialized =
in this function [-Wuninitialized]
block/blk-merge.c:171:23: note: 'bvprv.bv_len' was declared here
block/blk-merge.c:133:8: warning: 'bvprv.bv_page' may be used uninitialized=
 in this function [-Wuninitialized]
block/blk-merge.c:171:23: note: 'bvprv.bv_page' was declared here
block/blk-merge.c:133:8: warning: 'bvprv.bv_offset' may be used uninitializ=
ed in this function [-Wuninitialized]
block/blk-merge.c:171:23: note: 'bvprv.bv_offset' was declared here
block/blk-merge.c: In function 'blk_bio_map_sg':
block/blk-merge.c:133:8: warning: 'bvprv.bv_len' may be used uninitialized =
in this function [-Wuninitialized]
block/blk-merge.c:233:23: note: 'bvprv.bv_len' was declared here
block/blk-merge.c:133:8: warning: 'bvprv.bv_offset' may be used uninitializ=
ed in this function [-Wuninitialized]
block/blk-merge.c:233:23: note: 'bvprv.bv_offset' was declared here
block/blk-merge.c:133:8: warning: 'bvprv.bv_page' may be used uninitialized=
 in this function [-Wuninitialized]
block/blk-merge.c:233:23: note: 'bvprv.bv_page' was declared here
block/blk-merge.c: In function 'attempt_merge':
block/blk-merge.c:108:7: warning: 'end_bv.bv_offset' may be used uninitiali=
zed in this function [-Wuninitialized]
block/blk-merge.c:89:17: note: 'end_bv.bv_offset' was declared here
block/blk-merge.c:108:7: warning: 'end_bv.bv_page' may be used uninitialize=
d in this function [-Wuninitialized]
block/blk-merge.c:89:17: note: 'end_bv.bv_page' was declared here
block/blk-merge.c:108:7: warning: 'end_bv.bv_len' may be used uninitialized=
 in this function [-Wuninitialized]
block/blk-merge.c:89:17: note: 'end_bv.bv_len' was declared here

arm has its own definition of BIOVEC_PHYS_MERGEABLE() if that is relevant.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__26_Nov_2013_13_29_46_+1100_G8qkB_sFFX6B/9G6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSlAeeAAoJEMDTa8Ir7ZwVB08P/3kHITWK9aOvj0NducY/Q9zg
kdC1HofJUdURZj3WNPqDexewjFcfzAOGun89t2CLccfyxVkJTNJ6mhaH56+LnL8V
faVtg66O6IM6vJaOomSkdhJAVTSHQZq751yj6QXwGMaTdLDtkItfsQXQ8r5id7d2
Qd6ll95YG1IfJx9Bvf3N29oZyM1h/TBPG+d98Fg6rbsjAWmVPqckRWpHMpxgpLSf
ED55uxErgJ4jmQ4TQ9HY4GpfCYmKplNdqysQysfzbLiz9j2zwqOgrFqVwZ5e5Yua
GJvReyAIRc9bHZmYSGI7m0qkFdCDrZaJN7VoMB8JO3S3ZYj+ElXIr5Yg0aB7axMG
Gizwxefp1GUx9DluKz2v9Ty0pF0+v+E6aq9iFv6T+puMAMGB7dGuez0T/H5v8Q5H
GUrEXJxj4VOLeMTfB2IBQWfUqfZHLjhh+ui++UpHnlGhi5hpGdcXoCiLBiQ1eGit
W7mQw0CeIdK3LuqVi1jnf8sgCmZIn8y+Gk8l4XrTCwEM2HwlX0bkLTLwrW3zoKAZ
0t8UGFxwfniBJUP0ovG8yIv2CB1HLQcJpqRdirSvTG5NYwo1fizpqPNHSi492OiP
o36scg9mZZY7GVEuJtIWDqcACsjeBo+m73RayiTaIlRkEU/LEXUn2hyhHyQdTvN5
waTgsqEpQR1RcopKK4U8
=CsG3
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Nov_2013_13_29_46_+1100_G8qkB_sFFX6B/9G6--
