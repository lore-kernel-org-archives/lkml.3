Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965231AbaGRLVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 07:21:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761525AbaGRLVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:21:50 -0400
Message-ID: <1405682502.6396.2.camel@menhir>
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Date: Fri, 18 Jul 2014 12:21:42 +0100
Organization: Red Hat UK Ltd
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-h3a/VmTHmq07EwJMma2K"
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-h3a/VmTHmq07EwJMma2K
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The following changes since commit 3c8fb50445833b93f69b6b703a29aae3523cad0c=
:

  Merge tag 'pm+acpi-3.16-rc2' of git://git.kernel.org/pub/scm/linux/kernel=
/git/rafael/linux-pm (2014-06-19 18:58:57 -1000)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes.git ta=
gs/gfs2-fixes

for you to fetch changes up to 27ff6a0f7f5bf500e9d2a8760c062789b52c551f:

  GFS2: fs/gfs2/rgrp.c: kernel-doc warning fixes (2014-07-18 11:15:14 +0100=
)

----------------------------------------------------------------
This patch set contains two minor docs/spelling fixes, some fixes for
flock, a change to use GFP_NOFS to avoid recursion on a rarely used
code path and a fix for a race relating to the glock lru.

----------------------------------------------------------------
Bob Peterson (3):
      GFS2: Only wait for demote when last holder is dequeued
      GFS2: Allow flocks to use normal glock dq rather than dq_wait
      GFS2: Allow caching of glocks for flock

Fabian Frederick (2):
      GFS2: replace count*size kzalloc by kcalloc
      GFS2: fs/gfs2/rgrp.c: kernel-doc warning fixes

Geert Uytterhoeven (1):
      GFS2: memcontrol: Spelling s/invlidate/invalidate/

Steven Whitehouse (2):
      GFS2: Fix race in glock lru glock disposal
      GFS2: Use GFP_NOFS when allocating glocks

 fs/gfs2/file.c     |  4 ++--
 fs/gfs2/glock.c    | 14 +++++++++-----
 fs/gfs2/glops.c    |  4 ++--
 fs/gfs2/lock_dlm.c |  4 ++--
 fs/gfs2/rgrp.c     |  4 ++--
 5 files changed, 17 insertions(+), 13 deletions(-)


--=-h3a/VmTHmq07EwJMma2K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJTyQNKAAoJEMrg3m4a/8jSXSAQAIvkm0TNYj4Bi50ChFldvCOa
ewMoR0Pdf2laFbrETt4Zg6g31Gx4byQVmBzkP9GPUFPP6g6rVTcRXPQ111wBMxZT
My9+5AbLZGb7DzRNGgVIy6n1eCcXyg4rpCMODb4E5UOtJjtQu0RI8Z5FmLEriAlx
2XRntzUgCM3XPTZ0TLFT6Rmw5w3XtiE07D/o5CfbVCJhBEAtVK0cVJboIMaYN5MY
YwgXpgN1+nRC4f2I02CO+R1z7H4RPooXgyvDuxi671Knzlpzq0rNoYSyRMK0Vpfz
wZrSzKovsvG4vMbA6aFSYfxYjc0GvsEKGRgrOtRubtvrtl24Id+KofgH7/FCnL/z
tY/0zhs/elVI4BFGXQU3/diW+1V7LaZe0bMmPGgeSluAY9R/Mt8dVhBUL797/a2I
ng9QAop11spoxRQS8YE1TUJqGNDgVMmcJSENjMPZ8NYpyi0nvwK9J+1Mnlr+CgEx
nCEq+dnUpckKJh95IFcSSwdxri5nFE5k77ocmzxNnHTbNBbaBupZSS/z9zSP2Ihi
QyevfKFLqnT8aBokYO10kq7UCvd/rjmLd5dG3GtfrEh3VKT9ZPPdWvKK/SJgnsGs
r36JLpRm0RCu7bYNmUZXKy2D/0ZZCvvjrxdZtp9N/HG/kbV2Da/g15XOZNZrLdFe
GILSIZFA2/CzEyiAJT6z
=KsDC
-----END PGP SIGNATURE-----

--=-h3a/VmTHmq07EwJMma2K--

