Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbaJHTZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:25:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273AbaJHTZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:25:57 -0400
Message-ID: <1412796346.10045.2.camel@menhir>
Subject: GFS2: Pull request (merge window)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        cluster-devel@redhat.com
Date: Wed, 08 Oct 2014 20:25:46 +0100
Organization: Red Hat UK Ltd
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-RIK4QBcK4mZ80LmQBmYu"
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RIK4QBcK4mZ80LmQBmYu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Please consider pulling the following changes,

Steve.

-------------------------------------------------------------------------
The following changes since commit 37504a3be90b69438426d74ccf467a9fe192932b=
:

  Merge tag 'gfs2-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/s=
teve/gfs2-3.0-fixes (2014-09-16 07:47:04 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-nmw.git tags=
/gfs2-merge-window

for you to fetch changes up to d29c0afe4db72ceb72149c3894a6079674e9751f:

  GFS2: use _RET_IP_ instead of (unsigned long)__builtin_return_address(0) =
(2014-10-08 09:57:07 +0100)

----------------------------------------------------------------
This time we have a couple of bug fixes, one relating to bad i_goal values
which are now ignored (i_goal is basically a hint so it is safe to so this)
and another relating to the saving of the dirent location during rename.

There is one performance improvement, which is an optimisation in rgblk_fre=
e
so that multiple block deallocations will now be more efficient,
and one clean up patch to use _RET_IP_ rather than writing it out longhand.

----------------------------------------------------------------
Abhi Das (1):
      GFS2: fix bad inode i_goal values during block allocation

Bob Peterson (2):
      GFS2: Make rename not save dirent location
      GFS2: Use gfs2_rbm_incr in rgblk_free

Fabian Frederick (1):
      GFS2: use _RET_IP_ instead of (unsigned long)__builtin_return_address=
(0)

 fs/gfs2/dir.c   |  9 +++++++--
 fs/gfs2/dir.h   |  1 +
 fs/gfs2/glock.c |  4 ++--
 fs/gfs2/glops.c |  2 +-
 fs/gfs2/inode.c |  7 ++++---
 fs/gfs2/rgrp.c  | 30 +++++++++++++++++++++---------
 fs/gfs2/rgrp.h  |  1 +
 fs/gfs2/trans.c |  2 +-
 8 files changed, 38 insertions(+), 18 deletions(-)


--=-RIK4QBcK4mZ80LmQBmYu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUNY/AAAoJEMrg3m4a/8jSppoQAIXOUyPGKp+HmBLYOhvASTko
ibGmBdmSp0aLVprPlplXYkOLdaKEcgL4hS2quFATcAeLnwdQOf1fZvpF0H8ZHye0
C7JCCLzh1Wq+O8zg8Q8i3MXibhJ+SbkbrCVJuqPjSV0dm02U8b1KvfkPuvN0u004
Slft1bdmLWsZ84y2FPGuND6OI92adAcY6Qxk2GXMQbPF24glYYOxbvBdt3th4ANi
zP4C6tfHtU4EKFm6OnOsUemlaDRn83hKhU+nZtABTtdKfgV8kzHWoLrelpl0c4Ov
qVr8sboB6YpRbMS8C6+gK9+e/t21JhDOpTJvi2XRjpLvV6TCy1zvd0O79ph3JLY/
s2SAoVLLAZKRk873ilIYMu04btohIlj6mfAoccsAe/X1id9lfK+oy1OtW0uMiVKK
RTaqMTxk72wRijC98N6M/G12Nr+bU32xnadSVbEETXEqY7ZIaHy9x5t9Md5A+toG
54grQsRZcglhFCUahWIxTHfXzco+MHSjbYRjfqwQMPqn4FktnDgiMdw4flpAVs4K
I/LYimJvdffaNqSrdiX0CiOQ8PRJ3ZgXrigz1Zd83Nin5NDERiC0e5FAS2e/WAS9
cEc26LzHtBgi8iUhxzdymX6CqBCZ1Ol3nA2l06q4RN3XE02ZiNAt/qxoONddb4o1
y1hvZPMpQNnPowZIj0nT
=LSCn
-----END PGP SIGNATURE-----

--=-RIK4QBcK4mZ80LmQBmYu--

