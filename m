Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbaAOFU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 00:20:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39286 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbaAOFU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 00:20:56 -0500
Date: Wed, 15 Jan 2014 16:20:41 +1100
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux RAID <linux-raid@vger.kernel.org>,
        Andrei Warkentin <andreiw@vmware.com>, Damian Nowak <spam@nowaker.net>,
        Bruno Wolff III <bruno@wolff.to>, majianpeng <majianpeng@gmail.com>,
        Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: [GIT PULL REQUEST] last minute md fixes for 3.13
Message-ID: <20140115162041.4ab345da@notabene.brown>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/btgVWss==AqM9wSXht3qXII"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/btgVWss==AqM9wSXht3qXII
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Sorry they are late .... Christmas holidays and all that.  Hopefully they c=
an
still squeak into 3.13.

NeilBrown


The following changes since commit 6d183de4077191d1201283a9035ce57a9b05254d:

  md/raid5: fix newly-broken locking in get_active_stripe. (2013-11-28 11:0=
0:15 +1100)

are available in the git repository at:

  git://neil.brown.name/md tags/md/3.13-fixes

for you to fetch changes up to 8313b8e57f55b15e5b7f7fc5d1630bbf686a9a97:

  md: fix problem when adding device to read-only array with bitmap. (2014-=
01-14 16:44:08 +1100)

----------------------------------------------------------------
md: half a dozen bug fixes for 3.13

All of these fix real bugs the people have hit, and are tagged
for -stable.

----------------------------------------------------------------
NeilBrown (6):
      md/raid5: Fix possible confusion when multiple write errors occur.
      md/raid10: fix two bugs in handling of known-bad-blocks.
      md/raid1: fix request counting bug in new 'barrier' code.
      md/raid5: fix a recently broken BUG_ON().
      md/raid10: fix bug when raid10 recovery fails to recover a block.
      md: fix problem when adding device to read-only array with bitmap.

 drivers/md/md.c     | 18 +++++++++++++++---
 drivers/md/md.h     |  3 +++
 drivers/md/raid1.c  |  3 +--
 drivers/md/raid10.c | 12 ++++++------
 drivers/md/raid5.c  |  7 ++++---
 5 files changed, 29 insertions(+), 14 deletions(-)

--Sig_/btgVWss==AqM9wSXht3qXII
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUtYaqTnsnt1WYoG5AQKT3g/7BLGTNU9M6M8tTg4iqG2TnmxdLPhSeedd
TfOU2A2OybKw7z49qCp9rkA2vjYIv9ZyGVD2AdxdmpA0ZTPyJVUlXLAU3qMk/a2R
CWVud11+I+qnvMKPrO+Q1MGVtiB3Q8v7Jky3zPIrh8bNWeh0KplIs1BA9EOdUHF7
lvtMFQ9FVO3cI/r+anSFVvPQTCKLGnCLHCBB//Ehxg8HSsflblyrLv0pQmAKC7ck
iuy1vK8JLOgL9P5ZlxmAB44hkYCJJHwu1vOqDyv8VsV6UdDKreYL5AP/32xKFA0G
i3FTtQIfJXWdRewfiuZT9BxhFu41w/2nb/LKKJnG07zNUt4PQMZo1xoySlhYFcrk
3xuu7dsypJmz4BskWJAolgqp5xbLJcQUCYGl4nd9v5Fd1WACxdBSUG2j9DBkD7gp
X9Jq46o4L/CDWZYoUyLSIgEXqWSq5bolMdD5E6ckJauS551j4+fyVsVikoIZwbDS
W8XnKb+x6hSTTzfNS5lyZaki2kdIXd4dHC7ae/2dRCsfggK4+vHjmQjwfkYB4lwD
9cpxdO6LplJac/h0tKpPpy+2e6kqgvnyHWFG8jGjNlBWWB9ASPiIqiqkXXv69X6q
iHnrxHBV2RmMBs4Tbuo3KJSMRV3euigmvGo7rcp4BvCCX4dCivFHrk2edmc4ZTWL
w28wpxUayTc=
=2pMi
-----END PGP SIGNATURE-----

--Sig_/btgVWss==AqM9wSXht3qXII--
