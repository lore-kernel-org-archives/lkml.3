Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab3FJKGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 06:06:20 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39831 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab3FJKGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 06:06:19 -0400
Date: Mon, 10 Jun 2013 11:06:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20130610100615.GP31367@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Mdo7Sfo9s1ayEb6q"
Content-Disposition: inline
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regmap updates for v3.10
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Mdo7Sfo9s1ayEb6q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit d683b96b072dc4680fc74964eca77e6a23d1fa6e:

  Linux 3.10-rc4 (2013-06-02 17:11:17 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-v3.10-rc4

for you to fetch changes up to 998a4f2f1caf3106dfa8ce7abd8e87c118ea4fc9:

  Merge remote-tracking branch 'regmap/fix/debugfs' into regmap-linus (2013-06-03 18:07:38 +0100)

----------------------------------------------------------------

regmap: Fixes for v3.10

The biggest fix here is Lars-Peter's fix for custom locking callbacks
which is pretty localised but important for those devices that use the
feature.  Otherwise we've got a couple of fairly small cleanups which
would have been sent sooner were it not for letting Lars-Peter's patch
soak for a while.

----------------------------------------------------------------
Dimitris Papastamos (1):
      regmap: debugfs: Check return value of regmap_write()

Lars-Peter Clausen (1):
      regmap: regcache: Fixup locking for custom lock callbacks

Maarten ter Huurne (1):
      regmap: rbtree: Fixed node range check on sync

Mark Brown (2):
      Merge remote-tracking branch 'regmap/fix/cache' into regmap-linus
      Merge remote-tracking branch 'regmap/fix/debugfs' into regmap-linus

 drivers/base/regmap/regcache-rbtree.c |    6 ++----
 drivers/base/regmap/regcache.c        |   20 ++++++++++----------
 drivers/base/regmap/regmap-debugfs.c  |    5 ++++-
 3 files changed, 16 insertions(+), 15 deletions(-)

--Mdo7Sfo9s1ayEb6q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRtaUUAAoJELSic+t+oim9q2IP/iQjHedDTcB/CR2pKdSTi254
zlB4OK2yDcAZYQbSK0g1uw89tGFnJzN6iaUi9Yrj8XsT6YkYnZkkUdVuEVFzjOeh
sJoyPNl9jqQrjsNZ8YGa2J4XYCrCMKshVQKRlYv4+tmIJS6I2og4G0MGXLzzK/VT
MWsJbs2QMA9NKNFQpBDNdb5+IQmcrT/eDtX6Jstni7XpsIEb3XfCE7EyDp7ppuBW
epX92g59CYLtwpHi/WuqQcBsDN6HOuram/2x2nsplMWG3GBAXI1pwgMSwM4ozx+G
u9x+IiKDxfOf/4Znie/qdn7X+Z9RJhkW4w0/Hr/GKWv9VuQYs9hAjHw+lbufdQL9
74rx/xia4T+jvEuRCp636jUhUNoREeFm9yggNQICZ3JQhJeN4i1/+U0FhIKIY9sd
VC3Sk0UrpKfHq+NdM+62ZWX3225wSUEY7lN08sC7Cl9VFE6Ts4eZrCL2bGggfAD9
L3h/9u9cQkwwt0FqmXKnNsj4yvUWxsw+yEfcHQFclHGaq7TeP3pkUzIbibqfVQ/5
VY5HfuftbiqRdQmx1o85YN8PVMeebJ8qJU3aiQW/QIh0acgVCQqw9igPiavEy4iR
PcQ4Gf0iH+tueTNtTRNLz6Px+TrAuCZQ6C2z6fyVk/K4rznxy9tqaDdCX83gd9Uu
9vuKUejsN8CMzhoCxik+
=lqKM
-----END PGP SIGNATURE-----

--Mdo7Sfo9s1ayEb6q--
