Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236Ab3HSJ0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:26:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab3HSJZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:25:59 -0400
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-VmuFgtCXCFu5blfj74Gf"
Organization: Red Hat UK Ltd
Date: Mon, 19 Aug 2013 10:26:08 +0100
Message-ID: <1376904368.2679.9.camel@menhir>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VmuFgtCXCFu5blfj74Gf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Oops, forgot to sign this when I sent it first, so here is a signed copy of=
 it.

Hi,

Please consider pulling the following changes,

Steve.

---------------------------------------------------------------------------=
--
Out of these five patches, the one for ensuring that the number of         =
   =20
revokes is not exceeded, and the one for checking the glock is not         =
    =20
already held in gfs2_getxattr are the two most important. The latter       =
    =20
can be triggered by selinux.

The other three patches are very small and fix mostly fairly
trivial issues.

---------------------------------------------------------------------------=
---
The following changes since commit 47188d39b5deeebf41f87a02af1b3935866364cf=
:

  Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/g=
it/tytso/ext4 (2013-07-14 21:47:51 -0700)

are available in the git repository at:

  https://git.kernel.org/cgit/linux/kernel/git/steve/gfs2-3.0-fixes.git mas=
ter

Benjamin Marzinski (1):
      GFS2: don't overrun reserved revokes

Dan Carpenter (1):
      GFS2: alloc_workqueue() doesn't return an ERR_PTR

Steven Whitehouse (2):
      GFS2: Fix typo in gfs2_create_inode()
      GFS2: Check for glock already held in gfs2_getxattr

Tejun Heo (1):
      GFS2: WQ_NON_REENTRANT is meaningless and going away

 fs/gfs2/glock.c |    8 ++++----
 fs/gfs2/glops.c |   18 +++++++++++++-----
 fs/gfs2/inode.c |    6 +++++-
 fs/gfs2/main.c  |    2 +-
 4 files changed, 23 insertions(+), 11 deletions(-)



--=-VmuFgtCXCFu5blfj74Gf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJSEeSsAAoJEMrg3m4a/8jSnxUQAIsBrJWIqDypiShz9iND3Tl6
FWD4vnjEMBCoD4kcFAxKctmk1boDFLk/LkfVgJlAn21S0lnMYodMXe0Ts0lkC6wC
5ZhbkR/veTgVmKmFfRE6B1rlns4bvNb/liph8uGnTHpWQG4F1xR+KTTD1otpvF+l
nu/gziPn3cXYKKpp3AYtWNZthAEUsvmaB4V4t9CSOCOVq6+tnrntbyW7PuOwrk3B
MGqT5ZyaWCJejuu0bi0zlsiIfOyiEX8EsDsNUl1TrvDzGCfe4MFU73IfmWoryM7X
tPKeA3YUQD0brxRvvwbx/YkflHRABZ7U7qDoy9OqggmXXCkFuC5Z3Llr16lI+vlN
+UfVkj5K2QSgDajJ7HNj7EWo/uXPimznsD1nYH1eIkRAaWG5DkZ6R5HpuYwvl4SR
5HwFoaSgETXR5YSZ5fbarfnzA9/XbDSkvW+wxEZBOuAiP0PjkYsOeb60hxB7FGSi
+zJJb9z1hd3aEXys6mO5UptzGtdxT059Y5xiUAZIhlpGrH625WuQqbbp1RqKy8G3
beS7arLuQKyG4kXQkt5WLVzZXbycm28QbKnsH5uPRi79Mxh6MuWLUC4dOxw5gS8K
Yp0Awg5HDvbxf+uAjm6aeex7ii7JQcA+I56KOaAaJ2dFkyBR2oi0EDf6B6Kc0NuZ
0PK32+fMLdjJoCYkwqdZ
=6qpt
-----END PGP SIGNATURE-----

--=-VmuFgtCXCFu5blfj74Gf--

