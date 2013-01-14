Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab3AND6V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 22:58:21 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46761 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab3AND6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 22:58:20 -0500
Date: Mon, 14 Jan 2013 14:58:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Sam Bradshaw <sbradshaw@micron.com>, Jens Axboe <axboe@kernel.dk>,
        Kent Overstreet <koverstreet@google.com>
Subject: linux-next: manual merge of the akpm tree with the block tree
Message-Id: <20130114145816.397108bb0b1aec82e77d5a7a@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_Jan_2013_14_58_16_+1100_w7uAFjr6aqLwPEzm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Jan_2013_14_58_16_+1100_w7uAFjr6aqLwPEzm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/block/mtip32xx/mtip32xx.c between commit 16c906e51c6f ("mtip32xx:
Add workqueue and NUMA support") from the  tree and commit "mtip32xx:
convert to batch completion" from the akpm tree.

I couldn't see how to fix up the conflicts, so I just dropped the akpm
tree patch.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__14_Jan_2013_14_58_16_+1100_w7uAFjr6aqLwPEzm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ84JYAAoJEECxmPOUX5FEHT4P/R9cywnfgp+/fkodusOxzoCc
fs53gliQcSWYqtvmcuJcIwwROW1YjDWxy4Ds/jVPnjnSHXpFeYupgbb+sBC4R4+d
svpDtjjXC4dBzfbz2ePr0vJVP4MC9xuffQcxtI3Ly6/KV8dkyh/ofrjld/IcyUMR
5kmv2pmtbfDfY3b1/uYQiM2rfy00kS/DBpYKK6i4rinCLxRzBmw6ht5BQiWXTNfX
W7xB8d1lfdY0ssvOnH//NxEaVX8Mz218e5jLI2i1TtDyukBJirP93mhlmDP0WKWs
tbiVxOBlmmBwPvzwaIDp4jwjMeKHN5sJ6egI3GbghEaA4W4kwDFpFygmgeQMVm/f
2bxpftn9zBUPiatYyQOTj6wwsTtTxugoffP5x1WrOvfSihiJNZLNmezXjaSChcLG
A5rmXJeq9EAruWAj/CjlHMwxA1JfI2hWBMI3/37mcLZCEJ35BFSkGHTC5K0UI6Lm
QNck7ofMgzVXCNm6oz388/Eh2YCQngRth04wY1nRj+4vWvv+FDcT9bhyHD8/rCsT
/MrQDv+KEhHTnuk8CGiTeS7fc1EhYRAqLyWZ3SByt5mU+TDBn4M7FdiBseDMJZe3
cEfSBc7XvUKvaBXNTTqrhrsNjl1w3/aWSWYqSphLjUg8tv6JKNdJPhcwsjxLPm88
hvUS59+Qza81ygRqGBEL
=fnOp
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Jan_2013_14_58_16_+1100_w7uAFjr6aqLwPEzm--
