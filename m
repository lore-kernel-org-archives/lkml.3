Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab3AOU7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 15:59:49 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:33446 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab3AOU7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 15:59:48 -0500
Date: Tue, 15 Jan 2013 14:10:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Kent Overstreet <koverstreet@google.com>
Subject: linux-next: manual merge of the akpm tree with the block tree
Message-Id: <20130115141018.5135198bda8b6c63f6b7d0ee@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__15_Jan_2013_14_10_18_+1100_iLkcnINP9eBo_JSo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_Jan_2013_14_10_18_+1100_iLkcnINP9eBo_JSo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in fs/bio.c
between commit 3a366e614d08 ("block: add missing block_bio_complete()
tracepoint") from the block tree and commit "block, aio: batch completion
for bios/kiocbs" from the akpm tree.

I am not sure how to fix this up, so I just dropped the block tree
additions of "trace_block_bio_complete(bio, error);" to this file.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__15_Jan_2013_14_10_18_+1100_iLkcnINP9eBo_JSo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ9MiaAAoJEECxmPOUX5FEkVoP/AvCYHSD/aelKKn8Uf6qtcfq
iuerjJc5h8wYxwzf+aKDXpjRNBSr6vxgF1tQ11SsbN4ytFSbsDugDnG/IQa0Samg
7k96zdYY2yvVllmeOgv9kl2ouwWvTKvy8MCjsc573d4L6YWlCdCQjIHt9yymbKXw
KVPH04VZDxR+oOzxI43J7r2KCsIwDc4OZk4sq3ZgEwOXi1BLX/AfjU9zzG3m3XG7
tHgKGP6MK+7df4B0Zv/iby5UvnNZhbznTopVyx4bPWv62iOls/VmdVteungKr/nj
8Yw91F9FdS0WJGQvTNsKGXOtd5y+3oyE9PJA/kcb0V9n4iiPBqYfsZsDsZs9XCb1
wtJyPovITW9zfF/FR3LxA2VoHr0WipFYV/TWNrFCWm0I9aq+iXw3P17iLZIBZKJ3
nNemNn4omwv01PYSFwj2m9pEUuXCybMlKp74DoNBdwLrfG3otQVlsRJGRYi3Juv6
QMgKPozcLudnF4ojhPEgDBDkqOCWXrM6tBxsw+tc0dWXWDxrvkNxRIDVWgTaXiM1
AWphe1YRbgoxVdQx9gQnzV7Q40eZJaNbpDE8X8ldeYN0gCpZss7dYYMQ+oliavsg
ogw+Tlbmbm1fhtD9bFw5HUmxJ9es90bybv0ho8gGzyOCa3hqPnQFG2qlXJwjNYqu
GJJpBsjwvlRP8+3HBLkB
=g2Dh
-----END PGP SIGNATURE-----

--Signature=_Tue__15_Jan_2013_14_10_18_+1100_iLkcnINP9eBo_JSo--
