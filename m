Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936660Ab3DJIdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 04:33:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38782 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935214Ab3DJIda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 04:33:30 -0400
Date: Wed, 10 Apr 2013 18:33:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the akpm tree
Message-Id: <20130410183320.106df2fad7059cb72df921d1@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__10_Apr_2013_18_33_20_+1000_rdBwx5ky08u1y.B="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Apr_2013_18_33_20_+1000_rdBwx5ky08u1y.B=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc44x_defconfig) produced these warnings:

ipc/util.c: In function 'ipc_init':
ipc/util.c:105:2: warning: statement with no effect [-Wunused-value]
mm/slub.c: In function 'kmem_cache_init':
mm/slub.c:3600:2: warning: statement with no effect [-Wunused-value]

Introduced by commit 23e9e430f87e ("include/linux/memory.h: implement
register_hotmemory_notifier()").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__10_Apr_2013_18_33_20_+1000_rdBwx5ky08u1y.B=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRZSPQAAoJEECxmPOUX5FEqm8QAIii8DnKCac4QcOoEPCD+t4a
CYp/96wJgnOe+xQ4TtCpNBE70nR5TmJEkIiLq38mElVJVp2gsaki6433AO/RrTF3
XsYCn9v85m4K0n7aFBzSznX9racYXEXY2AdBm/3GFhTtlYRjXK3RqHZobAOqJhk6
TyU4sonIBm605/2X770cO70Hksq8IBRvqLfA1Njuqh/INr/3h15/mF5HqFetFqC9
92gHc2ehLsH3d/WPLOgiZ+UZDs7s3WIcs+sg2Ch5JuvapVqkFoMCN/8n52zc6sY6
cNTZ5zQggdIMmCJflkEMYl+EMlbIGthzW0h+aVTSQMH4rjdV5gyen+zJhhfERbzP
l30iK1nZkjsKXVkDn/7cMqTTl9BN2kPPqR5tVbQ7y39eIrQ67RTnWD7aJzlDv6sD
IyiWIiPCCJjIGdGUtqR3flG7D12z7e0dg+dRnuogAZybus1m0ipHLjj84S7ub4wI
fsIn37bPR2vqcjg2tm2pIUH2pvTt8y6QUCukCSnVcT7audZpIfpelYBSVpLvFjBg
pZQ8LQEdxtxIALWdUq3CCsROLnWSFyGD4RDKVG0kk9vA0BqsIFqghXE3mmGcCavr
DCUkOYGSO9MVv/5uBv77V3d7ObtD7Qaw5cjyfDKanq9PzQJ5+JMeqdl0SHgi9+Ho
5F7sXAT9RsRGyUROSUi3
=LpPX
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Apr_2013_18_33_20_+1000_rdBwx5ky08u1y.B=--
