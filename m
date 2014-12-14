Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaLNBiL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 20:38:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39787 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbaLNBiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 20:38:10 -0500
Date: Sun, 14 Dec 2014 12:37:58 +1100
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux RAID <linux-raid@vger.kernel.org>,
        Henry Cai <henryplusplus@gmail.com>
Subject: [GIT PULL REQUEST] md updates for 3.19
Message-ID: <20141214123758.2a737915@notabene.brown>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.25; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/5mrRlp2ZMSuJxhPC1h6nvdK"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5mrRlp2ZMSuJxhPC1h6nvdK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


hi Linus,
 please pull these three patches.

 I did have a largish set of locking changes queued, but late testing showed
 they weren't quite as stable as I thought and while I fixed what I found, I
 decided it safer to delay them a release ... particularly as I'll be AFK f=
or
 a few weeks.  So expect a larger batch next time :-)

Thanks,
NeilBrow

The following changes since commit 3a18ca061311f2f1ee9c44012f89c7436d392117:

  Merge tag 'ext4_for_linus_urgent' of git://git.kernel.org/pub/scm/linux/k=
ernel/git/tytso/ext4 (2014-12-01 20:11:49 -0800)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md/3.19

for you to fetch changes up to f851b60db0fd83a10034c5cc9d9e58c758457b1c:

  md: Check MD_RECOVERY_RUNNING as well as ->sync_thread. (2014-12-11 10:02=
:10 +1100)

----------------------------------------------------------------
Three fixes for md

----------------------------------------------------------------
NeilBrown (2):
      md/raid5: fetch_block must fetch all the blocks handle_stripe_dirtyin=
g wants.
      md: Check MD_RECOVERY_RUNNING as well as ->sync_thread.

kbuild test robot (1):
      md: fix semicolon.cocci warnings

 drivers/md/md.c    | 38 +++++++++++++++++++++++++++-----------
 drivers/md/raid5.c |  7 +++++--
 2 files changed, 32 insertions(+), 13 deletions(-)

--Sig_/5mrRlp2ZMSuJxhPC1h6nvdK
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVIzp9jnsnt1WYoG5AQKSmA/+LpzBMEOzL7hL/jPKMdYg3mCk/DMsuDQp
1XjirEjMQGtPMNxVhsJ8JLm7jToUpg9khM7W9ZS7A4Zc96Skb4hj19W7rTT975L5
UKJqVIppURnISMCElftOxXnb/n/0vctbrKGQibOzxTQRds/HOPJbEVpHGwgb14jG
RJENsEZ+Rbe3n7CbtUV6T8b2bpFCeFABcHrRRj9pE0LsJDPPNTt9RyxN2hqZV+XT
ieGXMXdL9otxEYBYxAK9Yh7bcAreRXuEuB7C295jaqiKBo+mfGqVLZMBTE8acYvc
u6FcqXh4DvOd7BPF3a/VjXooUAEBGFe85o3NL+bi5c03YsopzNTCFGsUO7mfOSGV
90Mij/VYwDaatiwBtooC0jbQFxGb1Y/1Kk33101Z/JsaJI1fVYFvS3t91rin+PZ9
joucxxtixAvVlYTAt3khhflCZeYFhaOHtQXbBu3PF8/wN44vQUNX9H1jqhYlD9/N
jsM8J9Qx/X8B4RBSJJjn09286eE+e1YuahAmO0I7BKozIMNVxYtuycsiifGnC9hL
iR0HQMHMps+lAjlZUP8qyrY4sTTqg1F9tie0qDfln1y+UrWWDyaI6J9+FhVp/KYp
Re94hFMCeiP+euuCbj60SskeD8hTLNfEJFzZ9zlPAc4Hkcqc1qmzi171hj41hIOe
harxNSLHx9w=
=kWCD
-----END PGP SIGNATURE-----

--Sig_/5mrRlp2ZMSuJxhPC1h6nvdK--
