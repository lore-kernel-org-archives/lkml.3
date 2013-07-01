Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab3GAQBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 12:01:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab3GAQBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 12:01:19 -0400
Subject: GFS2: Pull request (merge window)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-I+tRTAZCB8CjxYQHFF5O"
Organization: Red Hat UK Ltd
Date: Mon, 01 Jul 2013 16:20:13 +0100
Message-ID: <1372692013.2723.27.camel@menhir>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-I+tRTAZCB8CjxYQHFF5O
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Please consider pulling the following changes,

Steve.

---------------------------------------------------------------------------=
-------
There are a few bug fixes for various, mostly very minor corner
cases, plus some interesting new features. The new features
include atomic_open whose main benefit will be the reduction in
locking overhead in case of combined lookup/create and open operations,
sorting the log buffer lists by block number to improve the efficiency
of AIL writeback, and aggressively issuing revokes in gfs2_log_flush
to reduce overhead when dropping glocks.

---------------------------------------------------------------------------=
-------

The following changes since commit 844ce9f2044723a9da0f4bce588cca410e774d24=
:

  Merge tag 'mmc-fixes-for-3.10-rc5' of git://git.kernel.org/pub/scm/linux/=
kernel/git/cjb/mmc (2013-06-05 09:13:06 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-nmw.git mast=
er

Abhijith Das (1):
      GFS2: Fix fstrim boundary conditions

Alexey Khoroshilov (1):
      GFS2: fix error propagation in init_threads()

Benjamin Marzinski (3):
      GFS2: Sort buffer lists by inplace block number
      GFS2: aggressively issue revokes in gfs2_log_flush
      GFS2: fix warning message

Bob Peterson (3):
      GFS2: Eliminate gfs2_rg_lops
      GFS2: fix regression in dir_double_exhash
      GFS2: Reserve journal space for quota change in do_grow

Steven Whitehouse (3):
      GFS2: Remove no-op wrapper function
      GFS2: Only do one directory search on create
      GFS2: Add atomic_open support

Thomas Meyer (1):
      GFS2: Cocci spatch "ptr_ret.spatch"

 fs/dcache.c          |   11 +++-
 fs/gfs2/bmap.c       |    4 +-
 fs/gfs2/dir.c        |   26 +++++----
 fs/gfs2/dir.h        |    3 +-
 fs/gfs2/file.c       |   69 +++++++++++++++--------
 fs/gfs2/glops.c      |    8 ---
 fs/gfs2/inode.c      |  150 ++++++++++++++++++++++++++++++++++++----------=
----
 fs/gfs2/inode.h      |    1 +
 fs/gfs2/log.c        |   78 +++++++++++++++++++++++++-
 fs/gfs2/log.h        |    2 +
 fs/gfs2/lops.c       |   22 ++++++--
 fs/gfs2/lops.h       |    1 -
 fs/gfs2/meta_io.c    |    4 -
 fs/gfs2/ops_fstype.c |    8 +-
 fs/gfs2/quota.c      |    7 +--
 fs/gfs2/rgrp.c       |   14 +++--
 fs/gfs2/trans.c      |    9 +---
 17 files changed, 291 insertions(+), 126 deletions(-)


--=-I+tRTAZCB8CjxYQHFF5O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJR0Z4pAAoJEMrg3m4a/8jSAPcP/0Tct4OTBCLqWPftTeOaWkFT
0hmuTaAMqKWpIyS/leFpU/wxB3KG70H/MWnTT/DXATxNquIaCMaE6BeyBTl50So2
9YAyhvYi26s5mNntMeO5mB8LI2YWb5AfcdIMASJm5zO/wWnwzy0UNhB4F2HTPti+
VDoCiYdwIr/ZokFFaMp4LWFjFIYWG2arGnCN3jar3Daf0xI6MED/7awH5Sh0xInu
fAtelEO3lHZcO7Z+U8VmzvIwvIlgxUYZeaxhOpX89oOpNIP5YaKUf9ZeBbPXTPLA
c8jNZ8H3/ytxtgVR2ZI0TylfYhyDLa8keukQjOKaJHySgqtDPUDWtY46T5bD7oBh
0K4vSXubMD6LFgT39YKJLvQnApwjLYgcfDfQ+oT5L5Rc6OFDO1cLBsDhUDEBkNy2
U4dQQ2GOQytt/KRF8sn8X+PA4f8lOc1FiKd2OCCX6DNRkHH+SX2OeTKS63qBoga1
RgsjgATmvUuA/4Rjxhqf/jIUGi+pIuvT7EwcQsI+AOzQB+MVr5U3jJ3YFD3v1xlb
Tlekfkk7jQ+CKb7L1tlb6x8R8HwNryqtXtrTGCTJZWIJv1aCBgyzpPuwqSQu/xMU
rgukCEbxvhAg+YLfmrIJBJB6k9zRL7hWT1hEI81XeLZn4vYz2GHa5O4PzleuH7gU
hyT4qT9bqBLM9sTdWDW3
=yaOB
-----END PGP SIGNATURE-----

--=-I+tRTAZCB8CjxYQHFF5O--

