Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab3EXOIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:08:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149Ab3EXOIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:08:15 -0400
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oYiGpb0OEUHUwysvwcq8"
Organization: Red Hat UK Ltd
Date: Fri, 24 May 2013 15:05:56 +0100
Message-ID: <1369404356.2749.4.camel@menhir>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oYiGpb0OEUHUwysvwcq8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Please consider pulling the following fixes,

Steve.

---------------------------------------------------------------------------=
-
This time there are just four fixes. There are a couple of minor updates
to the quota code, a fix for KConfig to ensure that only valid combinations
including GFS2 can be built, and a fix for a typo affecting end i/o
processing when writing the journal.

Also, there is a temporary fix for a performance regression relating to
block reservations and directories. A longer fix will be applied in
due course, but this deals with the most immediate problem for now.

---------------------------------------------------------------------------=
-
The following changes since commit c7788792a5e7b0d5d7f96d0766b4cb6112d47d75=
:

  Linux 3.10-rc2 (2013-05-20 14:37:38 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes.git ma=
ster

Bob Peterson (2):
      GFS2: two minor quota fixups
      GFS2: Use single-block reservations for directories

Randy Dunlap (1):
      GFS2: fix DLM depends to fix build errors

Steven Whitehouse (1):
      GFS2: Fix typo in gfs2_log_end_write loop

 fs/gfs2/Kconfig |    2 +-
 fs/gfs2/lops.c  |    2 +-
 fs/gfs2/quota.c |    4 ++--
 fs/gfs2/rgrp.c  |    9 +++++++--
 4 files changed, 11 insertions(+), 6 deletions(-)


--=-oYiGpb0OEUHUwysvwcq8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRn3PAAAoJEMrg3m4a/8jSxqMQAJDq7KPGI2ovR5gCxNpWJLjm
xWfmU/UaTGVntX13S36PDWC229Jk7OK6LVJ1wAVujrOJe8qUpp9Y9WiUmBIAOKS3
vR9DCygXjQofImkj70nQIwZEXeBSxz6idjH5p+rUoK1DEmNvTLSuWBCspfzLhlTW
fgfxJ2F4hYCbwZKLTBpY6matiETsHRosOsbfc5qUyfC9lGcnrBl5Va+TTUXppYJN
o+LsECgftrNcE+ZHe/lbN3+8IfGEJ7uAIqJuagU/0QuOwuGTnURlylqA7ynHb2cU
SzmNn0azxORb0Wxr3JRT9v/ivm/5gZFnvEYtKtN/y+u9tIPe9obyP5ZKf8xMnnJI
t/h+WZTK+j+FG7r2cs9oL+sEKSQlhhmsQUtS+p1+H4Vq8kCXBbUPalLBeTAL/9tx
7I0cGMvmiqW4r58+6wSPkWkkUwxtUKYAh7cCMuL2aLgD4yJ52v4yc8ETbYNL+Wok
g47VsvqJZJM255aNIf3gqST/8M99de+YaALl5kUJNp9+IHByrpTKhkH+dhiRiaZl
HeV4sz/gBpCGc/maq7himsYqkYmC9VJzhWLZfKJhhkiJ33F1QTmJ4jdKbkYKO7BE
BoX5oez1NRcIVRn6MTGsNQcDwTORO0qhNT98Bdm4eFY2MuZkDNm7adsODLH2KEqV
nloJuqF55pIY5nPxmwYA
=84w9
-----END PGP SIGNATURE-----

--=-oYiGpb0OEUHUwysvwcq8--

