Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab3KZDgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 22:36:01 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59344 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab3KZDgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 22:36:00 -0500
Date: Tue, 26 Nov 2013 14:35:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: Re: linux-next: build warnings after merge of the block tree
Message-Id: <20131126143550.7a2195476ff4aa5c73db20b2@canb.auug.org.au>
In-Reply-To: <20131126132946.e402679788ae8269f0c5128a@canb.auug.org.au>
References: <20131126132946.e402679788ae8269f0c5128a@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__26_Nov_2013_14_35_50_+1100_Y/PZPIYZJkUSC7iG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Nov_2013_14_35_50_+1100_Y/PZPIYZJkUSC7iG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 26 Nov 2013 13:29:46 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the block tree, today's linux-next build (arm
> multi_v7_defconfig) produced these warnings:
>=20
> block/blk-merge.c: In function 'blk_rq_map_sg':
> block/blk-merge.c:133:8: warning: 'bvprv.bv_len' may be used uninitialize=
d in this function [-Wuninitialized]
> block/blk-merge.c:171:23: note: 'bvprv.bv_len' was declared here
> block/blk-merge.c:133:8: warning: 'bvprv.bv_page' may be used uninitializ=
ed in this function [-Wuninitialized]
> block/blk-merge.c:171:23: note: 'bvprv.bv_page' was declared here
> block/blk-merge.c:133:8: warning: 'bvprv.bv_offset' may be used uninitial=
ized in this function [-Wuninitialized]
> block/blk-merge.c:171:23: note: 'bvprv.bv_offset' was declared here
> block/blk-merge.c: In function 'blk_bio_map_sg':
> block/blk-merge.c:133:8: warning: 'bvprv.bv_len' may be used uninitialize=
d in this function [-Wuninitialized]
> block/blk-merge.c:233:23: note: 'bvprv.bv_len' was declared here
> block/blk-merge.c:133:8: warning: 'bvprv.bv_offset' may be used uninitial=
ized in this function [-Wuninitialized]
> block/blk-merge.c:233:23: note: 'bvprv.bv_offset' was declared here
> block/blk-merge.c:133:8: warning: 'bvprv.bv_page' may be used uninitializ=
ed in this function [-Wuninitialized]
> block/blk-merge.c:233:23: note: 'bvprv.bv_page' was declared here
> block/blk-merge.c: In function 'attempt_merge':
> block/blk-merge.c:108:7: warning: 'end_bv.bv_offset' may be used uninitia=
lized in this function [-Wuninitialized]
> block/blk-merge.c:89:17: note: 'end_bv.bv_offset' was declared here
> block/blk-merge.c:108:7: warning: 'end_bv.bv_page' may be used uninitiali=
zed in this function [-Wuninitialized]
> block/blk-merge.c:89:17: note: 'end_bv.bv_page' was declared here
> block/blk-merge.c:108:7: warning: 'end_bv.bv_len' may be used uninitializ=
ed in this function [-Wuninitialized]
> block/blk-merge.c:89:17: note: 'end_bv.bv_len' was declared here
>=20
> arm has its own definition of BIOVEC_PHYS_MERGEABLE() if that is relevant.

For an easier test case, the i386 defcongig does this as well.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__26_Nov_2013_14_35_50_+1100_Y/PZPIYZJkUSC7iG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSlBcaAAoJEMDTa8Ir7ZwVOZoP/1u40BvJu2GkxHGmr8l/fbbb
Af9odClkERbHeC9KDI6RGkRCc7aECvs/k8A/fAcclmdK/qnw4purUHxgTx6wvr4y
wToQv0t6qJpuHSQ6jJ1zOknDIzTmWW8HVwbosUJ6WLu56fA1JxSEDNOYFcuXq9CS
S/t3HIIvG74LNJfXLITicjY1mxNySUz29kkAXGtP3m5tA/4QJn4nTQQXSCpjfEU+
ZccfDQ1URYOEs4iuGBauyiCyABOioYRVA1VUHxCWqGi/hTlyvX+WOvhZ7nDyMYtS
GKPC1cvZJ6RpOJ1VQnEAHauO7AlS6frjytJVrn2fNhA5pTbqc7Z02S4AA0VBBrzc
+T7IR/U/QywsJYWN6Qpu52p4v4bgXLeSBYuQYPJhlsNONXc41gplTCXpgdVWzfQg
YgiHwM8spk6yW8BJ1hHt/2mCRWcDtdyS2XgD9bWNib2thCGVFkHcN4m5vSQkp1O2
20cJvmJEqJqbZUHfA+OARW6TnzfDAqF8Ao1nmCITRNmLi0fNJl+oiMkRT5y2sSWP
nJfAmYVz4p2nDntFu0i4e0hbPHUVymd00kSObfkl+4ls9n2iRK76idRZqpBcATvL
VbYnCsuGNhRP+n4VcgdWtQtxUPFhZg3vfRLVXF1wvyiADLbRg3rnOnmuoyTg2mvE
onu0NLQA7tjc5yzkepNl
=3fG1
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Nov_2013_14_35_50_+1100_Y/PZPIYZJkUSC7iG--
