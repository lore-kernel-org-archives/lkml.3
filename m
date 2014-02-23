Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbaBWEZJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 23:25:09 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49922 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbaBWEZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 23:25:07 -0500
Date: Sun, 23 Feb 2014 13:24:54 +0900
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140223042454.GI25940@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lE3gG894P96VuAc/"
Content-Disposition: inline
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.159.64
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator fixes for v3.14
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lE3gG894P96VuAc/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2:

  Linux 3.14-rc3 (2014-02-16 13:30:25 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.14-rc4

for you to fetch changes up to bcad2ca37296ab6c09de7975e850cb8f90c44c08:

  Merge remote-tracking branches 'regulator/fix/da9063', 'regulator/fix/max14577' and 'regulator/fix/s5m8767' into regulator-linus (2014-02-23 12:22:18 +0900)

----------------------------------------------------------------

regulator: Fixes for v3.14

Mostly unexciting driver fixes, plus one fix to lower the severity of
the log message when we don't use an optional regulator - the fixes for
ACPI system made this come up more often and it was correctly observed
that it was causing undue concern for users.

----------------------------------------------------------------
Krzysztof Kozlowski (1):
      regulator: max14577: Fix invalid return value on DT parse success

Mark Brown (2):
      Merge remote-tracking branch 'regulator/fix/core' into regulator-linus
      Merge remote-tracking branches 'regulator/fix/da9063', 'regulator/fix/max14577' and 'regulator/fix/s5m8767' into regulator-linus

Sachin Kamat (2):
      regulator: s5m8767: Use of_get_child_by_name
      regulator: s5m8767: Add missing of_node_put

Shuah Khan (1):
      regulator: core: Change dummy supplies error message to a warning

Steve Twiss (1):
      regulator: da9063: Bug fix when setting max voltage on LDOs 5-11

 drivers/regulator/core.c             | 2 +-
 drivers/regulator/da9063-regulator.c | 4 +++-
 drivers/regulator/max14577.c         | 5 +++--
 drivers/regulator/s5m8767.c          | 4 +++-
 4 files changed, 10 insertions(+), 5 deletions(-)

--lE3gG894P96VuAc/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCXgSAAoJELSic+t+oim9e4oP/i/dEKrJuDfRUP9pKhdQUYWb
R6TnrSBJlmpacTcEC3nXAYsrC1WrJWU7wqG7hF0bAgftlEWWQKRVGtUW9FjBrBBC
ZpgP90hT0xHmRI92PDiMhI7tvBT8qdczRAJk8oct//p17AjcvCxL4Mp0Fth4v9/1
LH+GPHR8t8urWH73YrR2RnF/KEbDr6ZAgnoWLgEBPcugvq+WydT9jDDiuj89Mfu2
WgWP4rBftkKEXPkjTyXSIX8vwnyUWbKUHrti1Qm1sSb228t0GJc65/PLUeW43EIP
kk7re7cC3PoXDRYzr6q5Y//jdq3EzQmSF4GB47/hH+jt0KVbZISwHP4koBJAwqZU
aQM0DbE/8wGpSzu060SOIv0uIP06/DntVkw1LZ3sMJWSuw0dh/0fJedEZ6Z9aes1
RuryXo/p/7M8SzAwGWUEeRUN9CMmhhuhGSuukUs6AZuCuS1TF6H9CKFDNa+CA3Rz
qmHMhyKUzV3vIVsSRLF/Yq4f/+lTAqFLc2FGl7SmTv1yRBev0J+JujDnBIyqEs4q
nVrPm709Ir0imiMOI6/5BHpJR7HLt/vpCxj6ML0r6M0gVlJ2j7RaLbJE4Bex7Sbk
1L4L2fgt4vRKxWkcLtyt4tj099Tw6D1JHtXLxu6thZ6OojsuoCtMCstla9TkcgC4
XS57nQB0/pWoUa1txMfw
=JiRs
-----END PGP SIGNATURE-----

--lE3gG894P96VuAc/--
