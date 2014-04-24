Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbaDXMKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:10:44 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43780 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbaDXMKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:10:36 -0400
Date: Thu, 24 Apr 2014 13:10:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@intel.com>
Message-ID: <20140424121021.GP12304@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wx4fROwh6iTAolpo"
Content-Disposition: inline
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator updates for v3.15
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Wx4fROwh6iTAolpo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit a798c10faf62a505d24e5f6213fbaf904a39623f:

  Linux 3.15-rc2 (2014-04-20 11:08:50 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.15-rc2

for you to fetch changes up to 38962571375149626cd282ef9d8e87e8faf21155:

  Merge remote-tracking branch 'regulator/fix/pbias' into regulator-linus (2014-04-23 13:50:12 +0100)

----------------------------------------------------------------

regulator: Fixes for v3.15

A couple of things here:

 - Fixes for pbias that didn't make it in during the merge window due to
   the driver coming in via MMC.  The conversion to use helpers is a
   fix as it implements list_voltage() which the main user (MMC) relies
   on for correct functioning.
 - Change the !REGULATOR stub for optional regulators to return an
   error rather than a dummy; this is more in keeping with the intended
   use of optional regulators and fixes some issues seen MMC where it
   got confused by a dummy being provided.

----------------------------------------------------------------
Axel Lin (2):
      regulator: pbias: Fix is_enabled callback implementation
      regulator: pbias: Convert to use regmap helper functions

Mark Brown (2):
      Merge remote-tracking branch 'regulator/fix/core' into regulator-linus
      Merge remote-tracking branch 'regulator/fix/pbias' into regulator-linus

Tim Kryger (1):
      regulator: core: Return error in get optional stub

 drivers/regulator/pbias-regulator.c | 76 ++++++++++---------------------------
 include/linux/regulator/consumer.h  |  4 +-
 2 files changed, 22 insertions(+), 58 deletions(-)

--Wx4fROwh6iTAolpo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTWP8qAAoJELSic+t+oim9Rc0P/3JaDuKvQFELrN7wE4efREPm
F7u+obHfTEPr+4z+lYLS7rjZf32I3xKuh+GoXEOJHRo8o3CdLQymd2ML5lNnBwlz
nwqLPh1Nhr1NtxEer3xQsUO3NnXduWWpTS+gpv51kNnW5Rm42E0B3TFdNyEsZFps
OzW6N7Tm5WTqPkfyPuSk6UMUbqGGtnbfzCy2/My+QiybDNdmovxQjUlpSHQpbru7
13RLJld6khZ8YtBsgeJzuH8JXq1ArtktlVvKK0+QOxGpjly4B8cGOCJEb1oH00Cw
nJUHS3ExqWMUghG7kkdU/X2W7dJRiz8qHWJUCHY2TO2RrgBkuSFGeJaidt9dt3pv
/82PVHpYqAc9w04IiHT5ziLXZEBLsUinjZRdPOez4V/3fvVW/GbCB/cRJgOCD+/1
3JuHjPiXgp1yck9VJBeON23u4BWdrsJ94k7PSX2ZkURx1vt5T+2UnGs7hnckjnxI
hLV+iHmPo4AXu78EWOTdygMXNnLpbvoqy3hetFA1hdDGIzNm7aDoj1IVxwnoLjVX
BdO9bARFBQGaU020evPO/+HY2mpJqxZ0wV2c7TNb2bD+YaiNxcMRgCvxEKiPnVkI
Wh6eo7a5mnYZE/TIdssjEbI9B6GJqFBhbSOIvJncr1zaUbGbqljRL/0/h62oUU/N
ltqT8Ft1ZGwluRUcjVgo
=kK/5
-----END PGP SIGNATURE-----

--Wx4fROwh6iTAolpo--
