Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaIPXfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 19:35:41 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46418 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870AbaIPXfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 19:35:40 -0400
Date: Tue, 16 Sep 2014 16:35:27 -0700
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140916233527.GH7960@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fd+sk2bWqLlmZvRT"
Content-Disposition: inline
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator fixes for v3.17
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Fd+sk2bWqLlmZvRT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.17-rc5

for you to fetch changes up to b8b27a44ddf1987e9bae84b99741b0a61192e017:

  regulator: remove unnecessary of_node_get() to parent (2014-09-10 11:35:02 +0100)

----------------------------------------------------------------
regulator: Fixes for v3.17

Fix some leaked OF node references in regulator drivers that have been
left over following a fix on a fix to the reference counting.

----------------------------------------------------------------
Guodong Xu (1):
      regulator: remove unnecessary of_node_get() to parent

 drivers/regulator/88pm8607.c           | 2 +-
 drivers/regulator/da9052-regulator.c   | 4 ++--
 drivers/regulator/max8907-regulator.c  | 2 +-
 drivers/regulator/max8925-regulator.c  | 2 +-
 drivers/regulator/max8997.c            | 2 +-
 drivers/regulator/palmas-regulator.c   | 1 -
 drivers/regulator/tps65910-regulator.c | 2 +-
 7 files changed, 7 insertions(+), 8 deletions(-)

--Fd+sk2bWqLlmZvRT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUGMk+AAoJECTWi3JdVIfQOeMH/jRMWHlioK0INwTqZBDSybtm
d1b9B7rMgcDMgIwmnZtQjgkvuIIP8OxebD5V5JPyTfSMJ2lRS3aim5Igs5df58EE
+WQSVSWFoWwMjdd542F5Eg87zNYp6w7Zu7rKx0+NhWNS9ZWP+5TjIC0YkWFFdh7D
a6XRVc8ADPENh6yPUK2R43JZ5fPmKPm/Jq7L4B/Fj4svZEmdkfVOF9JgaJzOrwi8
y0lakq8XHpeVimXsInoFFOftlKceNoklAz0/VqOGtprsSAiUz7XTEizbuTfgo26x
NehjcslAMapS9Nttuipq/9pur6/ldfZJlEy0lzA3wdR7ojA172Yj8FJTpFaWX5o=
=EJcs
-----END PGP SIGNATURE-----

--Fd+sk2bWqLlmZvRT--
