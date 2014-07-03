Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbaGCWVC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:21:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44226 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbaGCWU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:20:59 -0400
Date: Fri, 4 Jul 2014 08:20:48 +1000
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bill <billstuff2001@sbcglobal.net>,
        George Duffield <forumscollective@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        linux RAID <linux-raid@vger.kernel.org>
Subject: [GIT PULL REQUEST] two minor bugfixes for md in 3.16.
Message-ID: <20140704082048.4c0b5c59@notabene.brown>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/JpKUQlrh2DtXAe_ppXNhJFA"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/JpKUQlrh2DtXAe_ppXNhJFA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit 4c834452aad01531db949414f94f817a86348d59:

  Linux 3.16-rc3 (2014-06-29 14:11:36 -0700)

are available in the git repository at:

  git://neil.brown.name/md tags/md/3.16-fixes

for you to fetch changes up to 133d4527eab8d199a62eee6bd433f0776842df2e:

  md: flush writes before starting a recovery. (2014-07-03 10:44:45 +1000)

----------------------------------------------------------------
two minor bugfixes for md in 3.16.

----------------------------------------------------------------
NeilBrown (2):
      md: make sure GET_ARRAY_INFO ioctl reports correct "clean" status
      md: flush writes before starting a recovery.

 drivers/md/md.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--Sig_/JpKUQlrh2DtXAe_ppXNhJFA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU7XXQDnsnt1WYoG5AQI+xQ//b08gmYUSTWbLN1QBopUdy/fB/VUSoOrG
LhS+ZETgiYCCov69Tbgf08mnoqYBNcQI+O28kC0FJpSWVN0janxbPPS83rT5v5mB
QHhAQw67cqAO9pjw5a3OQCnevWVp5Kvlkj4/jWmgHBK6tbdopCBIpyE+ElWyJS4k
61XpmdskQM1IEiGhWd4vNl1b1Q/HHonAyQSYfn+BzHq+nxzt8H9blBG85u4Vl6DK
YKKMNAwS3KY+MvFrV4JYB7tVACoJKMFg5LSFivgoyNvz1a+Wp8FsGqxuRLaFXfRF
hXCT2LqBogu+2vvGUFEaPrVKe8UpUCBssM/JzIgYS29FMo+7brUdMlNDGEkB/f/X
+FsRYw2My0raTDiEqcjiZKifIhRftQ7amDPiSIb1UgLlzJJttNSJik4ugLe04E8h
HtlQiiFwqHm+3SdLiqfCFzf6LqyZKu87449lOHQaMHgwrG7j4todzRVUUlcPimOA
uyaaDDjfBd/o2UntTqlhzzvJce5CezND/m4WqFtZHld0SBwxtkayrKK37Pab6wU4
6/93lICrKQFSdLmUaqEN2W+UHsrPFM+pdLGr7qW5vTASXoimkdJ1ddp6pgBXtDxr
ja9NWc0fRiptinZkje0dRrpmFu2janC0H7BjOktoKfcSicvhVzlKqpSYHKG0RdMv
mMrp2ZGgTtk=
=R4AJ
-----END PGP SIGNATURE-----

--Sig_/JpKUQlrh2DtXAe_ppXNhJFA--
