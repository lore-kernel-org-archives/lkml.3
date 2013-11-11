Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab3KKB6i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 20:58:38 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:57660 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab3KKB6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 20:58:31 -0500
Date: Mon, 11 Nov 2013 12:58:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Kleikamp <dave.kleikamp@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the aio-direct tree with the vfs tree
Message-Id: <20131111125823.132831a43c3b1c50334f9411@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__11_Nov_2013_12_58_23_+1100_RB93f7NktPBEUr3N"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__11_Nov_2013_12_58_23_+1100_RB93f7NktPBEUr3N
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the aio-direct tree got a conflict in
fs/read_write.c between commit 72c2d5319200 ("file->f_op is never
NULL...") from the vfs tree and commit dd458300240b ("fs: create
file_readable() and file_writable() functions") from the aio-direct tree.

I fixed it up (I used the aio-direct tree version) and can carry the fix
as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__11_Nov_2013_12_58_23_+1100_RB93f7NktPBEUr3N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSgDnEAAoJEMDTa8Ir7ZwV/2QP/jJqpC8X8DIGl4Gm0ckfyANN
DbTAWahvOW2HEfj1jMi7+ZfN1zocg3j3TKXeJQy6Pq2Z7Vkveg2FwEvsBSoTgUO5
6qLCmy8JT1UZ84e0wA4D5cSzcvsfdMEJEvhOdJAYU0mijXq6eGBHJh1GvU9qVwnT
GrTWAFYCiwL8GmeauhPIa9Vw06YxYdZxWZdswhTN0yziXbTmItl0NdywZ8W74P4M
K+WEYVA2ub4HY2uLq5AY95SGWYs63rUboC2LvIApIDSlmd6gRMIza3q0zkVcuJ+Z
gfZH6A/1WyE8yJzDAwMTfqPEODLXlUBHjxKaiCeUlE/MFlK3JKc2Qifn9rOxRcJC
YxHBJTd7M4gfA8PM7LRatlxVLm1joBHKeYXHOnt9m57Tv5wiFHmU5pdHcLvbxLgt
fBNKEIM0WH6Kzbr7qozBiNtwUIgja+njlV5RFldZgV5iuXBacBykjS9eXCrJAfrM
FsSUy0+G8/yrLNTYt+TULHurBypFjZdbcPXvRX6qcuTa4OPxL0y2C01b5NQvybrw
vHlhFDgp0rDDAwYRQqx0Ssa5bAyZOYI14hWeznEKIB67/yZhXhfurt60YJiFq2qH
4aC++eTxj6y/mUZ38Xi2Wbl2qRnyVs49iK5/4wk0UhaJD8krBbM4gMFTowCvm82f
jq2TxqGeUvUsRD/TzhgZ
=zAuk
-----END PGP SIGNATURE-----

--Signature=_Mon__11_Nov_2013_12_58_23_+1100_RB93f7NktPBEUr3N--
