Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab3JDO4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 10:56:40 -0400
Received: from 8bytes.org ([85.214.48.195]:60289 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754694Ab3JDO4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 10:56:35 -0400
Date: Fri, 4 Oct 2013 16:56:32 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU Fixes for v3.12-rc3
Message-ID: <20131004145621.GB2717@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Oct  4 16:56:33 2013
X-DSPAM-Confidence: 0.9989
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 524ed72120861298515729
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:

  Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/iommu-fixes-v3.12-rc3

for you to fetch changes up to 82aeef0bf03684b377678c00c05e613f30dca39c:

  x86/iommu: correct ICS register offset (2013-09-24 13:04:07 +0200)

----------------------------------------------------------------
IOMMU Fixes for Linux v3.12-rc3

A couple of fixes from the IOMMU side:

	* Some small fixes for the new ARM-SMMU driver
	* A register offset correction for VT-d
	* Adding MAINTAINERS entry for drivers/iommu

Overall no really big or intrusive changes.

----------------------------------------------------------------
Dan Carpenter (2):
      iommu/arm-smmu: fix a signedness bug
      iommu/arm-smmu: fix iommu_present() test in init

Joerg Roedel (1):
      Merge branch 'for-joerg/arm-smmu/fixes' of git://git.kernel.org/.../will/linux into iommu/fixes

Li, Zhen-Hua (1):
      x86/iommu: correct ICS register offset

Stephen Warren (1):
      MAINTAINERS: add overall IOMMU section

Will Deacon (1):
      iommu/arm-smmu: don't enable SMMU device until probing has completed

 MAINTAINERS                 |    7 +++++++
 drivers/iommu/arm-smmu.c    |   13 +++++++------
 include/linux/intel-iommu.h |    2 +-
 3 files changed, 15 insertions(+), 7 deletions(-)

Please pull.

Thanks,

	Joerg


--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJSTtcUAAoJECvwRC2XARrjwVEQAJztUCF027P2tRxOmphh9ZdV
3VJb79TJCyI2XJJeREvy1pOuo+EcNmfqF5X8OxNGWIyb4l5JvacW4UvVI0bM+xUG
B98iAa+2T0QAG2Ngg68LqB66DuOLxpUpd5XJT66WcRjgA9neOBOGdht2wlf8j3I2
X610UO5BGZw4Fv6sco8//L2jSAG6WRmpc5wRyy7U3ZrbjM8+09QTczM6gam70SJX
avvMjbHxmZStBYXWuUu4yMg6b/CoOJFmaa5oiy0ONjgtmbHvvVQtkCXQUlxWKcaO
i39Px0fiLPVhznL8FYs7r9zGcdAB1DJ0WGlzmmed8ozhiUPbMB9U/WxjBAz89iPc
4aYdYN4VE/u7wI2bQ3ndLjEy91ct75UTbgtWITGUlBP+2WABW1fJT+v2NnJIOErp
dLgJr57ji2j6qnW8M4auG4GEi2s0gh+pQjtDdTqw+ZJZYIiW5VqV+Q2hb5Xe6Ei7
g4Y0M27FJc9PBS2OWnu3tD/wxPCLrR+9IyfqIESATJhEdE6sdIcx6mquR/9wsSF8
e+jljUp2mtUy8esKqiKvd8R81T6BHFpanxOeXbyK4PWNtD/xN7RbX6aVrV+rpvn3
gi0gxr6h08oATD8cQSbs24ZwLn0FEaleJj1VwfDga7COVGZf9KCJI8veApZrmDP6
J364ZIGo33pZ4Ga3oQiA
=q5QE
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--


