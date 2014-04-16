Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbaDPECw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 00:02:52 -0400
Received: from ozlabs.org ([103.22.144.67]:56470 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbaDPECt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 00:02:49 -0400
Date: Wed, 16 Apr 2014 14:02:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the audit tree with Linus' tree
Message-Id: <20140416140240.dd99f42196991edcb73a969d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__16_Apr_2014_14_02_40_+1000_RSdjxG+9Sbl3Rk/N"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Apr_2014_14_02_40_+1000_RSdjxG+9Sbl3Rk/N
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the audit tree got conflicts in
arch/mips/include/asm/syscall.h, arch/x86/Kconfig and kernel/audit.c
between commits from Linus' tree and commit 596b0569084b ("Merge tag
'v3.14' into mergeing") from the audit tree.

This happened because you merged Linus' tag v3.14 into your tree.  In
this case, that merge had conflicts that you resolved differently to the
way Linus had resolved them when he merged your tree for v3.15-rc1.  I
fixed it up (by using Linus' version) and can carry the fix as necessary
(no action is required).

You could have avoided this by doing a fast forward merge of v3.15-rc1
instead of the v3.14 merge (since everything in your tree before that
merge was also in Linus' tree by v3.15-rc1).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__16_Apr_2014_14_02_40_+1000_RSdjxG+9Sbl3Rk/N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTTgDkAAoJEMDTa8Ir7ZwV2bcP/jtWk6ipR0Kh2G2rmeqRd0G9
g6TGBPqC6XEumCdIZY3Y5RYfwpXPyncvqiHlK/EeMi1Mu3FCo2NH6Z8pZp0U84d9
0sRbNZn6XGa7S6UGT7YGy2MBqsQuDP7+53Zv+a4rE5Efm3htd89FrB7rHY/mULD/
GboVzJb8fPligycbrrmWJ1I2KaGcxOdFsB1NafDBGPnWXLTPvP4EmpO9LULzaoqW
mnb+6mafwhdR2/om3LDjSK9cl+T4BTMNrX9za9yOghXcQQxYomV4gGQrEzWPjGdr
+zHKPQqBUBEXPrCysZHQDej45t39IdyrzBPz9ovJ0zLeIkOHSPd6tou33vXU2vLB
YVmVEWua6rObRJk0LV9sggh/7W6XwMJPAUm1f5qSewDcjL32HZmWUtTx5OSFQVUx
1Npu5MevgjiMK4XvTVwvy29ioKkUQLZ63n8Na+VEEJ3yWi23G1YlOLvH4pv9QwVG
1tkQ3opNklkIQus++7bGInSe66bW5KxZ1GAyH3JOg5i+oC6BdTNtQ3o5XD/3+y16
CwpIctx1ilIMQEsZxHzGMXogSXveozOpX+ggSObYTi/D02CtCEWImForp6M36724
i1IRy7M1il654gYNf7OMbH2gk7VxhuyICKO977RgEr41NrE2R+ayHNYxD2U8Feju
yj/j3FPtuE8o3h3F2Ajp
=je24
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Apr_2014_14_02_40_+1000_RSdjxG+9Sbl3Rk/N--
