Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779AbaJUNtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:49:55 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:39702 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932524AbaJUNtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:49:53 -0400
Date: Tue, 21 Oct 2014 09:49:43 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Rui Zhang <rui.zhang@intel.com>
Cc: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] thermal-soc changes
Message-ID: <20141021134941.GA4937@developer>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Rui,

Here are a couple of changes that are in my tree. They include:
- a few code refactoring improving the Exynos code base;
- new feature on the Exynos code base (TRIMINFO and TRIMRELOAD);
- a documentation of RCAR thermal; and
- a fix in the of-thermal, regarding the proper usage of of APIs.

They are based on your next branch.

BR,

Eduardo Valentin

The following changes since commit 6ceaf58abe25e86292152005c51169796bad3407:

  Merge branch 'int340x-thermal' of .git into next (2014-10-17 14:30:58 +0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.git next

for you to fetch changes up to df67e40f51398fef8dd705dfe4e287ad9b10ba4b:

  thermal: fix multiple disbalanced device node counters (2014-10-21 08:05:50 -0400)

----------------------------------------------------------------
Bartlomiej Zolnierkiewicz (9):
      thermal: exynos: remove unused struct exynos_tmu_registers entries
      thermal: exynos: remove dead code for HW_MODE calibration
      thermal: exynos: remove redundant pdata checks from exynos_tmu_initialize()
      thermal: exynos: remove redundant threshold_code checks from exynos_tmu_initialize()
      thermal: exynos: simplify temp_to_code() and code_to_temp()
      thermal: exynos: cache non_hw_trigger_levels in pdata
      thermal: exynos: remove redundant pdata checks from exynos_tmu_control()
      thermal: exynos: remove identical values from exynos*_tmu_registers structures
      thermal: samsung: Exynos5260 and Exynos5420 should not use TRIM_RELOAD flag

Chanwoo Choi (2):
      thermal: exynos: Add support for many TRIMINFO_CTRL registers
      thermal: exynos: Add support for TRIM_RELOAD feature at Exynos3250

Geert Uytterhoeven (1):
      thermal: rcar: Add binding docs for new R-Car Gen2 SoCs

Vladimir Zapolskiy (1):
      thermal: fix multiple disbalanced device node counters

 .../devicetree/bindings/thermal/rcar-thermal.txt   |   5 +-
 drivers/thermal/of-thermal.c                       |  40 ++++--
 drivers/thermal/samsung/exynos_thermal_common.h    |   2 +-
 drivers/thermal/samsung/exynos_tmu.c               | 141 ++++++---------------
 drivers/thermal/samsung/exynos_tmu.h               |  81 ++----------
 drivers/thermal/samsung/exynos_tmu_data.c          |  83 ++++--------
 drivers/thermal/samsung/exynos_tmu_data.h          |  39 +-----
 7 files changed, 111 insertions(+), 280 deletions(-)

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJURmRpAAoJEMLUO4d9pOJWVHIH/3ddEE553jwrxsjSmjvmlNjX
Up7jZBchAnzUS1Zv/Zy2Rii+kUBK/I8deDkN9+fJuAMnBtXT9mQRdbwDyKAhtwkq
zpUwxgDZ1gpZhwcpeH8PxmhXHKDM/LJUi7jp/avScFpw3xpmFX1DwK/L8hzAvouH
PPIowj/ajCSn1klLgmpq6C/bmb97MOx6krW71z++X/RuhRDMv8Iob2sD9TtuIU0w
qZnUfbVLGmaamCAj92zFAcXMKVnNRFvc28payOsw3DbfIiVhUlXFZKgvGJtpiz8i
Zc9otKtSq5iV/0EGBw7w7yyJSd7C5fGrgOlQkcgLYLm/c/dxKzIBi3D1ATqTVa4=
=0/1W
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
