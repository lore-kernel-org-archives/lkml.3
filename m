Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbaKDQRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:17:40 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:39970 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646AbaKDQRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:17:32 -0500
Date: Tue, 4 Nov 2014 12:17:39 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Rui Zhang <rui.zhang@intel.com>
Subject: [GIT PULL] Thermal management updates for 3.18-rc4
Message-ID: <20141104161733.GA1570@developer>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Linus,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.=
git fixes

to receive Thermal Management updates for v3.18-rc4 with top-most=20

14015860565a1464193ddb3fbd3f7253a37dfcf9:

  Thermal:Remove usless if(!result) before return tz (2014-11-03 18:59:50 -=
0400)

on top of commit cac7f2429872d3733dc3f9915857b1691da2eb2f:

  Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)

Specifics:

- I am sending thermal fixes for 3.18-rc4 on behalf of Rui Zhang this
  time. He is currently unable to send pull requests due to troubles with
  his machine and he's currently in a business trip.

- In this pull request the changes include:
  . A few code fixes improving the Exynos code base. They remove
    dead and unreachable code. No functional changes here;
  . On Exynos code base, fixes regarding the right usage of
    features (TRIMINFO and TRIMRELOAD);
  . Documentation of RCAR thermal;
  . Fix in the of-thermal, regarding the proper usage
    of of-APIs; and
  . Fixes on thermal-core, removal of unreachable code.

BR,

Eduardo Valentin

----------------------------------------------------------------
Bartlomiej Zolnierkiewicz (10):
      thermal: exynos: remove unused struct exynos_tmu_registers entries
      thermal: exynos: remove dead code for HW_MODE calibration
      thermal: exynos: remove redundant pdata checks from exynos_tmu_initia=
lize()
      thermal: exynos: remove redundant threshold_code checks from exynos_t=
mu_initialize()
      thermal: exynos: simplify temp_to_code() and code_to_temp()
      thermal: exynos: cache non_hw_trigger_levels in pdata
      thermal: exynos: remove redundant pdata checks from exynos_tmu_contro=
l()
      thermal: exynos: remove identical values from exynos*_tmu_registers s=
tructures
      thermal: samsung: Exynos5260 and Exynos5420 should not use TRIM_RELOA=
D flag
      thermal: exynos: fix IRQ clearing on TMU initialization

Chanwoo Choi (2):
      thermal: exynos: Add support for many TRIMINFO_CTRL registers
      thermal: exynos: Add support for TRIM_RELOAD feature at Exynos3250

Geert Uytterhoeven (1):
      thermal: rcar: Add binding docs for new R-Car Gen2 SoCs

Vladimir Zapolskiy (1):
      thermal: fix multiple disbalanced device node counters

Yao Dongdong (1):
      Thermal:Remove usless if(!result) before return tz

 .../devicetree/bindings/thermal/rcar-thermal.txt   |   5 +-
 drivers/thermal/of-thermal.c                       |  40 ++++-
 drivers/thermal/samsung/exynos_thermal_common.h    |   2 +-
 drivers/thermal/samsung/exynos_tmu.c               | 170 +++++++----------=
----
 drivers/thermal/samsung/exynos_tmu.h               |  89 ++---------
 drivers/thermal/samsung/exynos_tmu_data.c          | 104 +++----------
 drivers/thermal/samsung/exynos_tmu_data.h          |  54 +------
 drivers/thermal/thermal_core.c                     |   3 +-
 8 files changed, 133 insertions(+), 334 deletions(-)

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUWPwUAAoJEMLUO4d9pOJWElgIAJE9gFZvBCGcwgUNmV3+hrot
HUi1M6vfEa5RrLx9Z0o+ix7MsU9BzJzhsmYH+5gi8C/NIvw4bRvMQLwRCFrevc1g
5pnLSmgqP95YcA8DksJG3hLB0DqLUO41s+Dw4S8Q/sTWXYNvwSS+hZVrEgcNXwL7
VeKoy41TwFvvajxFufqsrlL7gZwROjpjrvGKdTW9KMXu3pCa3eABzHAGLaRwe2ZM
D4+I524SMa/z4mKhLWfXySxKn6kk6ESy/mc314GbHSdzmYmXWcknQ6w80p62iJoF
uDGh+n5/MnYrrqeSFoczmRb4eDPpy68ksFWhkYE4uf4L3ygggJMg91DSPBFSzaE=
=eLak
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
