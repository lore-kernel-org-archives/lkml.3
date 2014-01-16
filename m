Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaAPBmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:42:25 -0500
Received: from ozlabs.org ([203.10.76.45]:40817 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbaAPBmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:42:22 -0500
Date: Thu, 16 Jan 2014 12:42:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the net-next tree with the uml tree
Message-Id: <20140116124215.78ed8795c91309badc844566@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__16_Jan_2014_12_42_15_+1100_=HeLZ+GHKpMY2Mni"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Jan_2014_12_42_15_+1100_=HeLZ+GHKpMY2Mni
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in
arch/um/include/asm/Kbuild between commit 989e59fa41c5 ("um: Include
generic barrier.h") from the uml tree and commit e3fec2f74f7f ("lib: Add
missing arch generic-y entries for asm-generic/hash.h") from the net-next
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/um/include/asm/Kbuild
index fb3a6cc23015,75de4abe4f94..000000000000
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@@ -4,4 -4,4 +4,5 @@@ generic-y +=3D ftrace.h pci.h io.h param.
  generic-y +=3D switch_to.h clkdev.h
  generic-y +=3D trace_clock.h
  generic-y +=3D preempt.h
 +generic-y +=3D barrier.h
+ generic-y +=3D hash.h

--Signature=_Thu__16_Jan_2014_12_42_15_+1100_=HeLZ+GHKpMY2Mni
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS1zj8AAoJEMDTa8Ir7ZwVu2EP/iksyZxhZyelCYN4WBCV/Xtr
p46fkgA9APqife4RKErkoc21/+nof0YG0PYNT9bkAFgaSXq/DNQ5sRqdjPX7r1gM
dqHKz9t9WibgYL2pCJhES61l0fBJq1Ed1TLu4jQsJE2sTxZ3yE05RYzLV9aAPaPg
I1B0BfAoHPUooNECsiJtPftFK7yPwrHgpEagzd5Ld4/cjIBKsj4J/gmEe4f5mDXv
LesGUaICi1O6OGgCa0YtFyMxbgm9BOJXyxfYYH27DoNoJqXkiKc44FNJ3yfAIKEb
mv2PLbw5HdaC5QcTRdTUhW2NHxsnt5MnucqHTjinHzXvvIXuJg7kiSssjtyIcyVJ
xg1ajDm9KbVccpPQGRvjsRklb5rvZYQzs/Y2YqxcG9jBjFofew2MF9m2j8HM97vG
EVINnoMz4c7citU4UKdLe+sxN1KLvDIU3MXwvZkTlHoWzlVwvgKZugSysy5ihn2a
XB/xqVjZQxUCEKYSxIZfRg/HsVMAkrN7C4ivFPDaHMe2fPP+UrWnAiFcDdZLk/DG
1FEvcpgb3/WFZXLDKykH7CT2XAcbO5JsMNRyh579r5kE6wcKc4gnbKSoeXhHP615
lmCZ+Nm5/V1/aI6m72iqdAaX/BoVfrPe1pnbl98Wv/ogY30Oa8Fewaf2MwPrUM6x
GshqgaTxOWF3MKG489uF
=suFf
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Jan_2014_12_42_15_+1100_=HeLZ+GHKpMY2Mni--
