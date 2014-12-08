Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbaLHS0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 13:26:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbaLHS0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 13:26:52 -0500
Message-ID: <1418063199.2985.2.camel@localhost>
Subject: GFS2: Pull request (merge window)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Date: Mon, 08 Dec 2014 18:26:39 +0000
Organization: Red Hat UK Ltd
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-aL6w2hbKVN5YjkRGAnIX"
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-aL6w2hbKVN5YjkRGAnIX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Please consider pulling the following changes,

Steve.

---------------------------------------------------------------------------=
-------

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4=
:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-nmw.git tags=
/gfs2-merge-window

for you to fetch changes up to ec7d879c457611e540cb465c25f3040facbd1185:

  GFS2: gfs2_atomic_open(): simplify the use of finish_no_open() (2014-11-2=
0 11:18:08 +0000)

----------------------------------------------------------------
In contrast to recent merge windows, there are a number of interesting feat=
ures
this time. There is a set of patches to improve performance in relation to
block reservations. Some correctness fixes for fallocate, and an update
to the freeze/thaw code which greatly simplyfies this code path. In
addition there is a set of clean ups from Al Viro too.

----------------------------------------------------------------
Al Viro (5):
      GFS2: bugger off early if O_CREAT open finds a directory
      GFS2: gfs2_create_inode(): don't bother with d_splice_alias()
      GFS2: use kvfree() instead of open-coding it
      GFS2: gfs2_dir_get_hash_table(): avoiding deferred vfree() is easy he=
re...
      GFS2: gfs2_atomic_open(): simplify the use of finish_no_open()

Andrew Price (3):
      GFS2: Use inode_newsize_ok and get_write_access in fallocate
      GFS2: Update i_size properly on fallocate
      GFS2: Update timestamps on fallocate

Benjamin Marzinski (2):
      fs: add freeze_super/thaw_super fs hooks
      GFS2: update freeze code to use freeze/thaw_super on all nodes

Bob Peterson (3):
      GFS2: Set of distributed preferences for rgrps
      GFS2: Only increase rs_sizehint
      GFS2: If we use up our block reservation, request more next time

Fabian Frederick (1):
      GFS2: directly return gfs2_dir_check()

Markus Elfring (1):
      GFS2: Deletion of unnecessary checks before two function calls

 fs/block_dev.c       |  10 ++++-
 fs/gfs2/dir.c        |  39 ++++--------------
 fs/gfs2/file.c       |  83 ++++++++++++++++++++++++--------------
 fs/gfs2/glock.c      |   3 +-
 fs/gfs2/glops.c      |  26 ++++++------
 fs/gfs2/glops.h      |   2 +
 fs/gfs2/incore.h     |  19 ++++++---
 fs/gfs2/inode.c      |  72 +++++++++------------------------
 fs/gfs2/log.c        |  42 +++++++++----------
 fs/gfs2/main.c       |  11 ++++-
 fs/gfs2/ops_fstype.c |  18 +++------
 fs/gfs2/quota.c      |   9 +----
 fs/gfs2/rgrp.c       |  69 ++++++++++++++++++++++++++++---
 fs/gfs2/rgrp.h       |   1 +
 fs/gfs2/super.c      | 112 ++++++++++++++++++++++++++++++++++-------------=
----
 fs/gfs2/super.h      |   1 +
 fs/gfs2/trans.c      |  17 ++++++--
 fs/ioctl.c           |   6 ++-
 include/linux/fs.h   |   2 +
 19 files changed, 315 insertions(+), 227 deletions(-)


--=-aL6w2hbKVN5YjkRGAnIX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUhe1mAAoJEMrg3m4a/8jSzc4P/09LEXcbQXt+pmbHaNNoTuo6
9WZKpVX13pLUYE9TopB52a5xQiMl9bbAPBFFCYGKf/qtKoI8b3zGqWuhpXbkTPbX
mGbo/cNJDOqZc1XU8P1t55jeDccU8VjkLwZ33mf8UYSvF9aky4p8Lka5Mtbq9Lc0
qjed2EnhRVuUMBW4yk+lZxeX5CgLmmfMdWu/lnCDaH0PI1wIzFmMlCJlgQSK2O75
vPNE4vwTmHjbWSXgL4weLwFLVd1RNzGm8tYxGj415m7dw05zh5s9yTSTdV4rb3Xs
R0SwBVRpkan5SuVtpDoJTqCRN9WSqGDiJCAhZbGbVz3l2nIXRRxjC0NfuDv9fVY2
DXjargfWaDJA7WSOi3kokXowczLyTSyH3MR9vd1bpVO2rAn8pBuPn739V9pK7vJ5
9GwtkIyZFJccJes8G8pIePKCruEgvCDEdrCwWrJCSeOaxWSQB/fw1hZvVlDvZ4vk
7hVrArj7TRXLMxnyuepUt2hVb53/koKVr6Xp4VecjG4OGR3z2KqF1XXra/K0s8Pe
XeMkA5Tyv6b+vraoUeMmbUMv+FP3e0i827LDoVEoDlqdZ44wuDzH4xb+KJtOIAy6
ACjCSheh2i3dm2XKssgYEXpvsca3nIWFe6Zz2UAbCOy22JSl4/Qs7zU+vqZQ5H32
+LDIkYHcaqaemwkqabAF
=qsyV
-----END PGP SIGNATURE-----

--=-aL6w2hbKVN5YjkRGAnIX--

