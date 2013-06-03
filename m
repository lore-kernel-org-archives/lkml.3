Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145Ab3FCP7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:59:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50242 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759120Ab3FCP7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:59:19 -0400
Date: Mon, 3 Jun 2013 16:58:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20130603155855.GQ31367@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kaF1vgn83Aa7CiXN"
Content-Disposition: inline
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator fixes for v3.10
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kaF1vgn83Aa7CiXN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit e4aa937ec75df0eea0bee03bffa3303ad36c986b:

  Linux 3.10-rc3 (2013-05-26 16:00:47 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.10-rc4

for you to fetch changes up to dcbd8eec68500beed75cf41630b89da6c85ad1e4:

  Merge remote-tracking branch 'regulator/fix/palmas' into regulator-linus (2013-05-30 11:58:40 +0100)

----------------------------------------------------------------

regulator: Fixes for v3.10

A few small fixes for v3.10, documentation things in the core and a few
driver bugs.

----------------------------------------------------------------
Charles Keepax (1):
      regulator: core: Correct spelling mistake in comment

Kishon Vijay Abraham I (1):
      regulator: palmas: Fix "enable_reg" to point to the correct reg for SMPS10

Mark Brown (4):
      Merge remote-tracking branch 'regulator/fix/core' into regulator-linus
      Merge remote-tracking branch 'regulator/fix/dbx500' into regulator-linus
      Merge remote-tracking branch 'regulator/fix/doc' into regulator-linus
      Merge remote-tracking branch 'regulator/fix/palmas' into regulator-linus

Robert P. J. Day (1):
      regulator: Fix kernel-doc generation warnings.

Sachin Kamat (2):
      regulator: dbx500: Make local symbol static
      regulator: palmas: Fix incorrect condition

 drivers/regulator/core.c             |    7 +++++--
 drivers/regulator/dbx500-prcmu.c     |   24 ++++++++++++------------
 drivers/regulator/palmas-regulator.c |    4 ++--
 3 files changed, 19 insertions(+), 16 deletions(-)

--kaF1vgn83Aa7CiXN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRrL08AAoJELSic+t+oim9BugP/iQ7dmf5+mpbFF1E/mfrlFYI
CvIb6FgdZdj+MQQi2vDfLdI773tpR9hWnkQHfRuxXKYoeVCK5ZVclmo9Is1/tTCs
4On/4aXOYX58gjP2dZndFWpju4k8la3K5H5e5TBvToObBUppgUgDHljm4eXMlvwJ
8JoYDExr8xZoDEpUrn/pnlNcD4m267eyTzah7J/evukKaetxBQQ3wAS6n3rzv0oM
jCW13nkIyz1b1SfD1gNWcB5V0ASqzbz4NHYCtFjXybGi37XDjctsV5+wfUd4s/bC
2VBPZd21DQbX1tB3VGcfoyplvNsvXlLRysLdNtobeJXMxMv93acYnEKhbo784IWf
1KoMCoCs3E6einNWTHAz/Klxx8gIcxybPvA1mjDLxeK4UbKCsmWStyACO/V0HJa+
ICroOV0NSAhW7HU2TwpKOnyexT+JQDjTaIHr/lP+Jeg8KM1+xqTTS4vYgyE2XQh2
NBG5D3u1N9f3u0eXS1tl3TM9K7c68VlaOVyPSBuLVtMuSi3TjG3VvmGbgHIEtP0P
2H4gB/xlVMx5fNJffxXSLbjuVbLJqPZ2mATUZKM4oD8w5dE8zbKsPnUMTS88Z50R
MpPuyOMbM1HB9YJxWb+cE26mKq6A9n4c4J3ZaSJhUovq4/iZ0uUkos4Aq1Oyz6ud
leAljHhPIxSWbwtfnX/b
=EWDR
-----END PGP SIGNATURE-----

--kaF1vgn83Aa7CiXN--
