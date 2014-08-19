Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbaHSHZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 03:25:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44200 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680AbaHSHZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 03:25:29 -0400
Date: Tue, 19 Aug 2014 17:25:18 +1000
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux RAID <linux-raid@vger.kernel.org>,
        mdraid.pkoch@dfgh.net (Peter Koch),
        Dan Williams <dan.j.williams@intel.com>
Subject: [GIT PULL REQUEST] bugfixes for md.
Message-ID: <20140819172518.63aaeea2@notabene.brown>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/oq_OViAl6=Tn8/_r9Y4lK0q"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/oq_OViAl6=Tn8/_r9Y4lK0q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Here are the bug-fixes I promised :-)
Funny how you start looking for one and other start appearing.

Thanks,
NeilBrown


The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md/3.17-fixes

for you to fetch changes up to cb8b12b5d81cf8522076f99a90bc3b795825c3b3:

  md/raid10: always initialise ->state on newly allocated r10_bio (2014-08-=
19 17:20:27 +1000)

----------------------------------------------------------------
md bugfixes for 3.17

 - raid6 data corruption during recovery
 - raid6 livelock
 - raid10 memory leaks.

----------------------------------------------------------------
NeilBrown (6):
      md/raid5: avoid livelock caused by non-aligned writes.
      md/raid6: avoid data corruption during recovery of double-degraded RA=
ID6
      md/raid10: fix memory leak when reshaping a RAID10.
      md/raid10: Fix memory leak when raid10 reshape completes.
      md/raid10: avoid memory leak on error path during reshape.
      md/raid10: always initialise ->state on newly allocated r10_bio

 drivers/md/raid10.c | 7 ++++++-
 drivers/md/raid5.c  | 4 +++-
 2 files changed, 9 insertions(+), 2 deletions(-)

--Sig_/oq_OViAl6=Tn8/_r9Y4lK0q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU/L73jnsnt1WYoG5AQJ+8Q/9GpdaFcujvSluo4j4pBpKDE48Wc+w4Vn/
n+TWzT1+3U8oqXUzBMYcQoMaN+o4JdxjPyoEQfGSadPtOsN7vfk3EeMWr2UJuB35
jT3B4+Rzn2cVYaklO5YR7gKCvA+9y8l6Bu968+o8qdfUviMbD4F7JsVE3D6mX0S2
UxCBCLSjSKBQLAk8IGZfWI7DmEzlEokDkX1B1TcjUoW9ITGKt4koae+q6DNE7va6
7fkPnbAAkVCEK6YixqRiBraDkyTo+eDGEoqHDZ976LJxEoctm2wUpVRnTs5QTFTX
qleEaZ5yFY/EfKfLJuiEiP3pfOl6pxB0C3yVxfSQz7o3fmNN5u78u7K2rsjR+0mo
HGHKZI+6IDPTCrm1qu2TtBw+kn5cdqdIyNALpGoY59uL6LvfQ3wv88VUGYgjehBu
tcu1kwP3jhgnZMo5c4tSpYYhjeFIDaYJifszbkavBr7fsz6z/+/BLzt2Oc+jWHt/
Mw+ZH5R05AEPMIJtS7QxLV2ZRlfvhnBUbVW422oZXrBdCh+OuAzuH9ejF5ViBtSi
rUUcQMvPRuuUHS3dpfElsmwBqSQC5I0hJ7dLe7RZ8v69Vzb0YyR8iZycQPLzDoPV
3fzy/lgjVmIJvdGa0Z6xk8Qr7+/34/RXYPif4S9GPzbmt7UOLl6AyIdCHgYBs/oi
RRYjA3Nha54=
=HXbp
-----END PGP SIGNATURE-----

--Sig_/oq_OViAl6=Tn8/_r9Y4lK0q--
