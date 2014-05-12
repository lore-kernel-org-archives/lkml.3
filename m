Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbaELTH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 15:07:28 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:56624 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaELTH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 15:07:26 -0400
Date: Mon, 12 May 2014 15:06:50 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull file locking changes for v3.15 (pile #4)
Message-ID: <20140512150650.646e4a85@tlielax.poochiereds.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/_DbOmSTt3Pt1F+C3jJo_A1B"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_DbOmSTt3Pt1F+C3jJo_A1B
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit afcf0a2d9289bbe50aab362e6fb2798038815973:

  Merge tag 'xfs-for-linus-3.15-rc5' of git://oss.sgi.com/xfs/xfs (2014-05-=
08 19:20:45 -0700)

are available in the git repository at:


  git://git.samba.org/jlayton/linux.git tags/locks-v3.15-4

for you to fetch changes up to cf01f4eef9fe367ec0d85b38dd7214e29e376cdb:

  locks: only validate the lock vs. f_mode in F_SETLK codepaths (2014-05-09=
 11:41:54 -0400)

----------------------------------------------------------------
(from the branch description for locks-3.15 local branch)

file locking patches for 3.15

File locking related changes for v3.15 (pile #4)

- fix for regression in handling of F_GETLK commands

----------------------------------------------------------------
Jeff Layton (1):
      locks: only validate the lock vs. f_mode in F_SETLK codepaths

 fs/locks.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

--=20
Jeff Layton <jlayton@poochiereds.net>

--Sig_/_DbOmSTt3Pt1F+C3jJo_A1B
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTcRvKAAoJEAAOaEEZVoIVMCAP/Rb37Bk3HK9d4MXynf/Btni5
p7PVXUY15qy5uLhTXVKgIx/BV7MfX260YEVhaYrWgXFax90N6OtRBeOoDsFB6r5p
/YGmDC2hbv1Vfzo/UiBU211ny+78E8+4jw4Jwm6RWfoR6HZMAlinpUdqYM8QVFRh
gla0n07iAzP8J7HI5Z97+vCIAmNqV3fGNz0pFKFAX6kVxndEJG+VIkfEAIK0TO5v
AuNZel5bsBeSGPsj4oI9F52wZRv0GLLWgXmpZt64wwf4CWG5CZ0qIcyBWNneh8Af
CozNRsOSfw2Wg7ziIdIg/m2Mdy+6qV5PhQgI+kqDXum2ZAFXwj5jcnc/82RtDFwa
gLMQAjEsqdcgCV8+kbk3p9FY1JdQl+ztlyA/+mDvlpCx/YKMsFAmV1sp1HspIi56
2m7/ztutgfeCVZ1hgyeNZ3CmNdkoY7p0dJi0toJtMs3JMg17OsKXdcSgS0dK5C3t
/TjBYm/IprLzu88GZluCk9H530mxDXCXKn4rRGEi2YWByPNxYchwDUbtdWPuJF53
cMA3GqsGXdXXIsXrLX1YezHHfr2MHSPDMDQWeDjYPa3gg5t8MGpSMjffWj4lDEvo
KMEQ1ZEwPRVhO6ncAJyRszd773w1V50GusmflK+B93HQWu4Z+OZrQOvitHsXg3EB
fnpwvtKv9RTa+xW0jN2A
=dTYK
-----END PGP SIGNATURE-----

--Sig_/_DbOmSTt3Pt1F+C3jJo_A1B--
