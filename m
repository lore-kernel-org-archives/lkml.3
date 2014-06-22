Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaFVBOI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 21:14:08 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:53431 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbaFVBOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 21:14:06 -0400
Date: Sat, 21 Jun 2014 21:13:54 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: bfields@fieldses.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull file locking bugfixes for v3.16 (pile #2)
Message-ID: <20140621211354.291ea285@tlielax.poochiereds.net>
X-Mailer: Claws Mail 3.10.0 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/rIw.iHc00tPgsf8WpDwxdtC"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/rIw.iHc00tPgsf8WpDwxdtC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit 64b2d1fbbfda07765dae3f601862796a61b2c451:

  Merge tag 'for-f2fs-3.16' of git://git.kernel.org/pub/scm/linux/kernel/gi=
t/jaegeuk/f2fs (2014-06-09 19:11:44 -0700)

are available in the git repository at:


  git://git.samba.org/jlayton/linux.git tags/locks-v3.16-2

for you to fetch changes up to 0c27362998a8357f199501aa401e99c51c2eb46e:

  locks: set fl_owner for leases back to current->files (2014-06-10 12:29:0=
5 -0400)

----------------------------------------------------------------
(from the branch description for locks-3.16 local branch)

File locking related bugfixes for v3.16 (pile #2)

Nothing too earth-shattering here. A fix for a potential regression
due to a patch in pile #1, and the addition of a memory barrier to
prevent a race condition between break_deleg and generic_add_lease.

----------------------------------------------------------------
Jeff Layton (2):
      locks: add missing memory barrier in break_deleg
      locks: set fl_owner for leases back to current->files

 fs/locks.c         | 2 +-
 include/linux/fs.h | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

--=20
Jeff Layton <jlayton@poochiereds.net>

--Sig_/rIw.iHc00tPgsf8WpDwxdtC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTpi3YAAoJEAAOaEEZVoIVwWQQAKjDxZcS67EYMcsxGmiSOLeW
JSoPbXH9ULVHnJJ/M8cEVdi80QDJltvJ4p/wOzkmB+OaRlrWEDyJTVSkBYgUiPah
QsvRvBFMnltU9I0/+74zKewyjUp5ZjPWdP2QO9kO8ft/fC5dR1sSr0ZF9CoSImGl
UVRT4OeHFMERpcFglhHnmM+2pOU4DO8IRezCnlGBEGimQ2aBz9r8yfi5WdLt5YDU
Ks+PD6zsGtKa87UoblDARz0XFZnZUiI+6abI/pYD9qif2NrfukjN6mTUiGz5DdMe
wLUo7CeMbNNYHJHv5ZX8NUzW49gOEF5VmEKZy71anRS8Kh4ndfg/aWMERBl6WAxV
GczziznQgtAh0vouBUJStkVIJnYR626ZTjSu8msjkeF2VNR+F8dkITdSeppI1dgQ
TyqFd8MuGzZcAu32J5ZTEy8F0+NlYueFyH+ydunpB1+m6QCs7gJcRmggeLImEdYR
KLG8/SyYysdAaWqCSq2hkX8AJaeEWKBmJmqYajf/daNRtoSFiapK6Gq9cYakZ6QF
gdCw+vLdMDSKK/yTCZYTeFJ2elegtocgr1TSVRv3POaik/y0NR/pEOsjE9RR/jfD
b3NIBh6fB3z+AiiblsXzikgtW/SPrUkzfIqnChevDO1tSecwQBEFo+ayZYsydmAA
q5H69/e9o2H/fCdu/BTU
=982K
-----END PGP SIGNATURE-----

--Sig_/rIw.iHc00tPgsf8WpDwxdtC--
