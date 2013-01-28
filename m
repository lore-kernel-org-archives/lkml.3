Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab3A1WVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 17:21:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab3A1WVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 17:21:37 -0500
Date: Tue, 29 Jan 2013 09:00:24 +1100
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jonathan Brassow <jbrassow@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        linux RAID <linux-raid@vger.kernel.org>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [PULL REQUEST] md - one fix for dmraid in 3.8
Message-ID: <20130129090024.02845387@notabene.brown>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HRj5arPfaudE=iYnTmMrC=z"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/HRj5arPfaudE=iYnTmMrC=z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


The following changes since commit 5f243b9b46a22e5790dbbc36f574c2417af49a41:

  Merge tag 'arm64-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/=
cmarinas/linux-aarch64 (2013-01-04 10:41:54 -0800)

are available in the git repository at:


  git://neil.brown.name/md/ tags/md-3.8-fixes

for you to fetch changes up to 55ebbb59c1c6eb1b040f62b8c4ae0b724de6e55a:

  DM-RAID: Fix RAID10's check for sufficient redundancy (2013-01-24 12:02:3=
6 +1100)

----------------------------------------------------------------
Just one fix for md in 3.8

dmraid assess redundancy and replacements slightly inaccurately which
could lead to some degraded arrays failing to assemble.

----------------------------------------------------------------
Jonathan Brassow (1):
      DM-RAID: Fix RAID10's check for sufficient redundancy

 Documentation/device-mapper/dm-raid.txt |   1 +
 drivers/md/dm-raid.c                    | 101 ++++++++++++----------------=
----
 2 files changed, 38 insertions(+), 64 deletions(-)

--Sig_/HRj5arPfaudE=iYnTmMrC=z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUQb0+Dnsnt1WYoG5AQIPaxAAjt9LqGzE4GTzBjs+Y2IaaIeAZibWoz2+
j93Q8fpExsw/BMLkg8eltgRp3yJH19rol39/KRCNr1lirNVF+/6zFAepEvFO2/i/
ChfUOsmJwJKr+ADPtiXZQ8V8KYiTqPI8b33X3IVIgV9FNCO6mmG6LmpcZbRf8GGC
XK/8yCUCciiFt4DjY2JpCsxQeI6iHHyFv6StQVuWQ+2C4LGjErZs13xLlTVvXe4A
ZbDG8dC1Lxo7b0QtMZ5opBktAgWbGIC5UT6qevVhw9iOxTyBahhUhIMkK/spODXI
BgOmj/pahnfnshxmIKTK5rLDk3X6gQw2mYIOf6wSrm0vjZC+I4IszP0667edLao4
vQdnHPOqAWfdDdAs3XUCeIL0pHayCuqYbvq806LcmnU3aPBskOyiRH4IcrJwGqpJ
A9ezvnEqe1iiLvdximXrrpU8bfaE06S3oz3hq1y2SDrysYQi+3hj27rjAlPjM9+z
w3ivmV7j8T49Rx/Gcd1pAQzxnz732QfTKa6JGhRTLKx1YDyfcA9z5LxFM2V9UxCw
b9UTqthxC9KCWKw8AiM7U58tBgOa3SpgQp9CFYgTcPT/gOksVPlemaL7epKLf8VT
wSh7kKTk0eoKWVkoUCrh4aUjO0WURBAygAf7eK0panha6Q9R8Hh//Rm9FIreytOV
EWl10VaugH8=
=mVri
-----END PGP SIGNATURE-----

--Sig_/HRj5arPfaudE=iYnTmMrC=z--
