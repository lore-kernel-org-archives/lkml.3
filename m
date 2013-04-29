Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab3D2LLQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 07:11:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab3D2LLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 07:11:15 -0400
Subject: GFS2: Pull request (merge window)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-sKG/J23YodRJ0uKgVCbf"
Organization: Red Hat UK Ltd
Date: Mon, 29 Apr 2013 12:08:55 +0100
Message-ID: <1367233735.2858.13.camel@menhir>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sKG/J23YodRJ0uKgVCbf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Please consider pulling the following changes,

Steve.

----------------------------------------------------------------------

There is not a whole lot of change this time - there are some further
changes which are in the works, but those will be held over until next
time.

Here there are some clean ups to inode creation, the addition of an
origin (local or remote) indicator to glock demote requests, removal
of one of the remaining GFP_NOFAIL allocations during log flushes,
one minor clean up, and a one liner bug fix.

----------------------------------------------------------------------
The following changes since commit 31880c37c11e28cb81c70757e38392b42e695dc6=
:

  Linux 3.9-rc6 (2013-04-07 20:49:54 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-nmw.git mast=
er

Benjamin Marzinski (1):
      GFS2: replace gfs2_ail structure with gfs2_trans

Bob Peterson (2):
      GFS2: Remove vestigial parameter ip from function rs_deltree
      GFS2: Flush work queue before clearing glock hash tables

Steven Whitehouse (5):
      GFS2: Clean up inode creation path
      GFS2: Remove gfs2_refresh_inode from inode creation path
      GFS2: Use gfs2_dinode_out() in the inode create path
      GFS2: Add origin indicator to glock callbacks
      GFS2: Add origin indicator to glock demote tracing

 fs/gfs2/aops.c       |    2 +-
 fs/gfs2/bmap.c       |    2 +-
 fs/gfs2/glock.c      |   28 ++-----
 fs/gfs2/glock.h      |    1 -
 fs/gfs2/glops.c      |    4 +-
 fs/gfs2/incore.h     |   19 +++---
 fs/gfs2/inode.c      |  188 +++++++++++++++++-----------------------------=
----
 fs/gfs2/log.c        |  104 +++++++++++++++-------------
 fs/gfs2/lops.c       |   32 ++++++---
 fs/gfs2/lops.h       |    5 +-
 fs/gfs2/meta_io.c    |    2 +-
 fs/gfs2/rgrp.c       |   24 +++----
 fs/gfs2/rgrp.h       |    2 +-
 fs/gfs2/super.c      |    2 +-
 fs/gfs2/trace_gfs2.h |   11 ++-
 fs/gfs2/trans.c      |    4 +-
 16 files changed, 188 insertions(+), 242 deletions(-)


--=-sKG/J23YodRJ0uKgVCbf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRflTDAAoJEMrg3m4a/8jS9woP/iuG8dWd5uUchuIErxBHAxLI
CFJOkWmZrdyWyh4Rj8XMpSfV4V92MDh9NJKxLD09BSnJ3SOKWlhcOK6fPrFEN8hy
1lM1/0QNCOknUU6K9l80E0gWQ/fiwc3lw8vmLX/fZxJd9tHvISMyYA1KKDu/HTbF
msETxt9ENIFjldqAVpWdUlf9IxHKCU9u8JJ2WZ7jbJrZKHElsVa3KVlhfDvy/jZE
e6aVYOOVpUUIjeuP/V51wK/Uexa/J7/RQMVAOTEZt0uYcjEXEClti3Gj1P32mQ8W
trrmVpQGwOMXdOPXOk4hQyB0A4vBxnYaQLvJAHiPeOKoeLY7qPysMY7qcJp3PnQC
koB0eTlQkal3/wE99nZJivDzSaCaKZwAgHgz2XFjebYsMsXS/VjNxQnfYY5tjGTe
QMKYTyI4sGyXjOiyJLzRjq2wCHyjJo5pr4eWikcYQeZF8S1u6ScY+cTodeTmiWQt
aqxc2zhEaIuI+LX45J4bSZFX/qUtpFppzGgNbZXM/RpMuPpzUhUWoyBOORaj+jWd
nv28n7B6dPAhCT8CDpKKJRjCKl+OYd5I3oNoDYrjjq0LpGyiwWWYNf2WGOIPa+Ux
Y+0FtaWm6SZsKOIN77D9/6JqvgANxMPSy1O6xD7tuVDyj8R60oP4k/fRE+nbumQX
sdhZA2Ej5dTUueX45SMG
=lhbJ
-----END PGP SIGNATURE-----

--=-sKG/J23YodRJ0uKgVCbf--

