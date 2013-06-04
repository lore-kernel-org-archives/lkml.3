Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab3FDPnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 11:43:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab3FDPnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 11:43:09 -0400
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-yxiRlUhWErN3KgdWp4rr"
Organization: Red Hat UK Ltd
Date: Tue, 04 Jun 2013 16:40:41 +0100
Message-ID: <1370360441.2705.10.camel@menhir>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yxiRlUhWErN3KgdWp4rr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Please consider pulling the following fixes for GFS2,

Steve.

---------------------------------------------------------------------------=
---

There are four patches this time. The first fixes a problem where the
wrong descriptor type was being written into the log for journaled data
blocks. The second fixes a race relating to the deallocation of allocator
data. The third provides a fallback if kmalloc is unable to satisfy a
request to allocate a directory hash table. The fourth fixes the iopen
glock caching so that inodes are deleted in a more timely manner after
rmdir/unlink.

---------------------------------------------------------------------------=
--
The following changes since commit aa4f608478acb7ed69dfcff4f3c404100b78ac49=
:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git=
/geert/linux-m68k (2013-06-03 18:09:42 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes.git ma=
ster

Bob Peterson (4):
      GFS2: Set log descriptor type for jdata blocks
      GFS2: Increase i_writecount during gfs2_setattr_size
      GFS2: Fall back to vmalloc if kmalloc fails for dir hash tables
      GFS2: Don't cache iopen glocks

 fs/gfs2/bmap.c  |   17 +++++++++++++----
 fs/gfs2/dir.c   |   43 +++++++++++++++++++++++++++++++++----------
 fs/gfs2/file.c  |   19 +++++++++++++------
 fs/gfs2/inode.c |    1 +
 fs/gfs2/lops.c  |    4 +++-
 fs/gfs2/rgrp.c  |    4 +++-
 fs/gfs2/super.c |    6 +++++-
 7 files changed, 71 insertions(+), 23 deletions(-)


--=-yxiRlUhWErN3KgdWp4rr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRrgpvAAoJEMrg3m4a/8jSfzMP/iJGIEPIMV+S1724/6sZg6tf
yIpMgegk78LTTPL3qgKmu2lfbiZ6Z4i6jdJPDYp7nIvTYX2AvTvPsQnx4nP4Iy+t
2CxIdzDFFY+knSmG3NXHl4wEo0eEQzJhMaksEVPNy24beZhSLk4II0y/3bOl9wO6
wbusFGFrOYeRr3WuMhUKLF8y6w2l4Sr0XOe1vGQUbbBnQeCJdMZ/aF97knwU4EWm
vrRzb/fQnX6SGHTso3/bP2SniqhpE6V99UNQGnou5KZ06C7vaEB+Lgg+MFtMS8kd
AE6cd8D4bjWHG+c6vYy1bzMC7WJtL4be/iVsu+XlqCgMoNCsjZBPiRIqc4UZ32Xt
33DtP1Gy0m4nO74xJDj5giI/DJIJf4p2vUozuW/td/r7bbXt4wg36/+8sozIsU2w
0BUCk8NJSGqDfbzrp9rs8kVQhTo41T68Qqb8cxuD9ZOPfTm96CNC5rVvAscNs3cY
Cp7d2q8tJlHxckVyvKKSYX99ZapoMJfRG/dRdDHZTXp8r+CbtzmOM6EUVfqD1iCF
4zkcPugP8TeSpMoVIbuP13Yrkj8DgVQ7Lkcgr/dti3290R3CyVmQjqIiwT7tO1Qk
DrbCDEUCSA4kd7ugxKnXXKsgD0dA++xvHbPMjrEgSQNzTZPgUDoaX9IeKrLx6DGq
aRSP5ehJafJgvy2i91MW
=trzS
-----END PGP SIGNATURE-----

--=-yxiRlUhWErN3KgdWp4rr--

