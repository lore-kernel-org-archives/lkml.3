Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbaDRRnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:43:13 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38186 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaDRRnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:43:10 -0400
Date: Fri, 18 Apr 2014 18:42:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Message-ID: <20140418174259.GW12304@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hkezENaauvF4Gk9M"
Content-Disposition: inline
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] Arizona DT handling updates
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hkezENaauvF4Gk9M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/arizona-dt

for you to fetch changes up to 2cce4be9e6b885c595816c45a80bcce95dae6d30:

  regulator: arizona-ldo1: Add processing of init_data from device tree (2014-04-18 18:35:06 +0100)

----------------------------------------------------------------
regulator: Arizona DT handling updates

Add support for externally supplied DCVDD and MICVDD when used with DT
- previously the DT code had assumed that these were supplied internally.

----------------------------------------------------------------
Charles Keepax (4):
      mfd: arizona: Factor out read of device tree GPIOs
      regulator: arizona-micsupp: Add processing of init_data from device tree
      regulator: arizona-ldo1: Move setup processing from arizona-core
      regulator: arizona-ldo1: Add processing of init_data from device tree

 drivers/mfd/arizona-core.c          | 41 +++++++++++++++-----------
 drivers/regulator/arizona-ldo1.c    | 57 +++++++++++++++++++++++++++++++++++++
 drivers/regulator/arizona-micsupp.c | 37 ++++++++++++++++++++++++
 include/linux/mfd/arizona/core.h    |  3 ++
 4 files changed, 121 insertions(+), 17 deletions(-)

--hkezENaauvF4Gk9M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTUWQfAAoJELSic+t+oim9kUsP/jwb5S+GJpNbdaSEDGhsOGGa
AiSY+NQ7AhvSznH6Xe61TA2j5kEDjcaT7uTre9lP1P4ptfMRTkrwE/rMGGMSQYyt
fonZLweI97r6ZcV6plKrDZPxySl9yqI+rSyotlw7f8UxpqWblWLVBYGdpA6IwY+Z
l9BK9fjjWG5CDfjBygZk4hu3GXsJUdWIaJwQeo5bBs3tBXUotx7w82xCD6bGZ2WD
86ZG3atFIKAnMjbYLyFLG+spf2mHY5NEA8zInqWbU3/9KEEIyofIcxazkpsYmEYq
jeGndLB2TmvkrPp8YukxtAcZTDWPQxBvS0NAQErhOtY11naIByliQhO++8lguCgh
bx92jYUkyF65htfxPCoe0i9qHTJDYLx3woQu5bk6mgaXOWg+do7z3RLQoJIXy3o6
bR2mdDartQnbyDkyMJLwwfXLHk8h1s7y8uINru6mD/cQdDqXOhR2EGzW4k0pP9FE
xsiWTJvTccZQz4En5y2D7gUOM9zRcmkCnQkROTBQ22DcFU4jEZj/K/+sx43WxFHR
Ju39yXu+JUrBlob1U4StXFsd5m/qYQY09j0CZH4GJSRXOCFw/Lw3mKWHm6Y6IXWo
erSyTRUfhcLn+KyhYITelcE0qf1AEieb6y0zGnJfiZ9965Y4T2vBa5oecSHvRIZo
sVGvIWyT7EBxomKbpsh1
=HRkl
-----END PGP SIGNATURE-----

--hkezENaauvF4Gk9M--
