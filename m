Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab3GZAiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 20:38:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38831 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756785Ab3GZAiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 20:38:07 -0400
Date: Fri, 26 Jul 2013 10:37:53 +1000
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PULL REQUEST] 2 more bug fixes for md in 3.11
Message-ID: <20130726103753.6e0fe5a5@notabene.brown>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+QD4oyYgfnw7MxMokXXqWmE"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/+QD4oyYgfnw7MxMokXXqWmE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit 30bc9b53878a9921b02e3b5bc4283ac1c6de102a:

  md/raid1: fix bio handling problems in process_checks() (2013-07-18 14:18=
:04 +1000)

are available in the git repository at:

  git://neil.brown.name/md tags/md/3.11-fixes

for you to fetch changes up to f94c0b6658c7edea8bc19d13be321e3860a3fa54:

  md/raid5: fix interaction of 'replace' and 'recovery'. (2013-07-25 16:46:=
57 +1000)

----------------------------------------------------------------
2 more bugfixes for md in 3.11

Both marked for -stable, both since 3.3.  I guess I should spend more
time testing...

----------------------------------------------------------------
NeilBrown (2):
      md/raid10: remove use-after-free bug.
      md/raid5: fix interaction of 'replace' and 'recovery'.

 drivers/md/raid10.c |  8 +++++++-
 drivers/md/raid5.c  | 15 ++++++++++-----
 drivers/md/raid5.h  |  1 +
 3 files changed, 18 insertions(+), 6 deletions(-)

--Sig_/+QD4oyYgfnw7MxMokXXqWmE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUfHE4jnsnt1WYoG5AQJrLxAAoKxMwJU6eHNkl1GPwXXBy7uvbeUnoCak
SGQq2I6j+N9KZ4XCAoG/rsnLhkns3fcEmzTeLa6lK8J3F24Z/XM0q/c+7L/VJdCf
9oKXAHnUqJRULD48WECQwOBw2twMYTDEvp/9nRKsbR/jBFm+Svw2ZWuX4NDRwvt8
OhguOvCB7momJA705NQJI63NqzIykmVx2K1+Ko//Jl3J+uJbQtmQA7ftGHS1Odmp
Bomi1B/mjo1umcnegO8RLwMOCZbJ9PvJS5kciA+esq1XeCA2QDRzjYqNyo8tjxY/
k5nnq3MaXmwY2NicwQa6M9Pgx9NTJo+n605N/V+lBZiQrXFXybjPdafO3ihSjooR
h/X0UBgzGwQIgnOgAn/ckceft4VQ/FxaSui7cOhcogAad8oXlAOjMvGeK5Uhz6R6
aDECJXf+Rs0xGCcKqgXu6W4Wgg9VhwIqfv4QBOx6fqbK6QLj1Us6XW1j331ULhm2
50tBpGowoaGYbWEL93oUV4DsSOqB3I74UpJVtSsO3gIWOSpntt842MaAcI6i4xUx
Dk6VrFyWyC9HlfWZD2CJ9uFlIrLNxw8WBoBbHnqucQUIkTQJY4O21INi9Et4xJkw
stjgR4MFYpMTVL8cWOjwm/YkudZZYt/M7JpdDocLmcgg/m4dUJkprXTbfgV14fh7
0dgPq/PPzgI=
=XJ3X
-----END PGP SIGNATURE-----

--Sig_/+QD4oyYgfnw7MxMokXXqWmE--
