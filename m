Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466Ab3GRVxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 17:53:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49953 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759308Ab3GRVxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 17:53:41 -0400
Date: Fri, 19 Jul 2013 07:53:25 +1000
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PULL REQUEST] 3 md bug fixes for 3.11 (and 3.10.y)
Message-ID: <20130719075325.5e5a9f80@notabene.brown>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/n55vc0732+H65odkXaw0pxW"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/n55vc0732+H65odkXaw0pxW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Sorry boss, back at work now boss.  Here's them nice shiny patches ya wante=
d.
All nicely tagged and justified for -stable and everyfing.

[And to linux-raid people: please don't use 3.10, or 3.10.1.  The result
 probably wouldn't be catastrophic, but it could be uncomfortable]

NeilBrown


The following changes since commit 47188d39b5deeebf41f87a02af1b3935866364cf:

  Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/g=
it/tytso/ext4 (2013-07-14 21:47:51 -0700)

are available in the git repository at:


  git://neil.brown.name/md tags/md-3.11-fixes

for you to fetch changes up to 30bc9b53878a9921b02e3b5bc4283ac1c6de102a:

  md/raid1: fix bio handling problems in process_checks() (2013-07-18 14:18=
:04 +1000)

----------------------------------------------------------------
3 bug fixes for md in 3.10

3.10 wasn't a good release for md.  The bio changes left a couple of
bugs, and an md "fix" created another one.

These three patches appear to fix the issues and have been tagged for
-stable.

----------------------------------------------------------------
NeilBrown (3):
      md/raid10: fix two problems with RAID10 resync.
      md: Remove recent change which allows devices to skip recovery.
      md/raid1: fix bio handling problems in process_checks()

 drivers/md/md.c     | 14 --------------
 drivers/md/raid1.c  | 53 ++++++++++++++++++++++++++++++-------------------=
----
 drivers/md/raid10.c | 11 +++++++++--
 3 files changed, 39 insertions(+), 39 deletions(-)

--Sig_/n55vc0732+H65odkXaw0pxW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUehj1Tnsnt1WYoG5AQKePBAAmyYznoQZaO1pKYiWQ2DW7WvgMcLzkxr1
h+t4vHAOQ12ct6+2d8HZnHZV1qB4CwTSuBKUbfe5gUP0Q+2bSk7gqDwUxUN5yUxn
YNA369yem9SzQDDbg2JiRYayDawkqDWeqMXYl/BVbVSPMefppditHFP5+Kb71VqJ
4YvS5WaARTSOk02tMu8vX8xiAJo/Lfx+O03Mn0rDnhWHvFJxeoQEdHTBQRZbsRxo
E5WNN1vUG4E15uMIkfoO7vR7KsJVsHs4VW3yg1cHtu0PhvU0TOe0PHvc0qmiLV83
cxmD8Lt+Z51Bn5ovxqH3/3NckpzVHZDg0CUNVpMhyLHGXfW2/ZzVf0Hdpoza1q41
Ifzs4AlmYjrnP86NSQmRiiVfCyzLguVFPGzEjPJnT2WyQXhsZ3a48OHAhIuP02cK
xsMF3I6Z6wwk5hjPSnqAx1RvWQIZG/U4R5U7f/PT0SavTz/IopjpxEmNFFjzUt7f
2fp5J32e7siwk6etlytXcVvND4OJjtdnTjh1+kOzcMfTEBVDHrWtRn/04/2W+6Ml
TPbrffOsSxrqwKTxqrLEgfE+lrw8sTH5TK69aKX4q0SDfqMFLxfvYcfVS06OVT5L
F0QPd66oxBPKrsVgubT5urbIerxLJjPEebZwqRCQ3khhHebmMtF2WBetslDOIfEU
QTj3AM9EC3U=
=atVk
-----END PGP SIGNATURE-----

--Sig_/n55vc0732+H65odkXaw0pxW--
