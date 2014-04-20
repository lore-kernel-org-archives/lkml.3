Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbaDTJps (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 05:45:48 -0400
Received: from 8bytes.org ([85.214.48.195]:37575 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793AbaDTJpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 05:45:40 -0400
Date: Sun, 20 Apr 2014 11:45:37 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU Fixes for Linux v3.15-rc1
Message-ID: <20140420094535.GA3237@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sun Apr 20 11:45:38 2014
X-DSPAM-Confidence: 0.9990
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5353974220861011553431
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/iommu-fixes-v3.15-rc1

for you to fetch changes up to 3426cb3d3578eab55ec231e0ce4dfc12ec3abc1f:

  Merge git://git.infradead.org/iommu-2.6 into iommu/fixes (2014-04-16 16:09:40 +0200)

----------------------------------------------------------------

IOMMU Fixes for Linux v3.15-rc1

Fixes for regressions:

	* Fix wrong IOMMU enumeration causing some SCSI device drivers
	  initialization failures
	* ARM-SMMU fixes for a panic condition and a wrong return value.

----------------------------------------------------------------
Bin Wang (1):
      iommu/arm-smmu: fix panic in arm_smmu_alloc_init_pte

David Woodhouse (1):
      iommu/vt-d: Fix get_domain_for_dev() handling of upstream PCIe bridges

Jiang Liu (2):
      iommu/vt-d: fix memory leakage caused by commit ea8ea46
      iommu/vt-d: fix bug in matching PCI devices with DRHD/RMRR descriptors

Joerg Roedel (1):
      Merge git://git.infradead.org/iommu-2.6 into iommu/fixes

Laurent Pinchart (1):
      iommu/arm-smmu: Return 0 on unmap failure

 drivers/iommu/arm-smmu.c    |    4 ++--
 drivers/iommu/dmar.c        |    3 ++-
 drivers/iommu/intel-iommu.c |   10 +++++++---
 3 files changed, 11 insertions(+), 6 deletions(-)

Please pull.

Thanks,

	Joerg


--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJTU5c/AAoJECvwRC2XARrjXXYP/jYyncsBx46WjWXWd6Qa+hqt
Iv4Gr8ciZROJv97o8funMev41kmkUT48Air8fHbcxA7LQJC9DmXv7EOJlO8Pqo2M
5yIMc9MvqUx8/EHLIem7xk6APJWksvRWhPwR8KYd7KO9vROd6SKUD4VRwPQuMP8S
U15S6b+Ybu/XlK34WL8vneiT1C7jY8qU0fDfd/da0EnprBOum8r5aMVd6KaYXrFW
xVscU9SzXhCtVW9+Vl0ZpvJtTy75atMFtFcB/PTQJk9qXzVuQrBizr9luqJjy3vp
ewB5JK3VKNdvXlIjTjgBe2puDjUPOHlQDwiZEh8gIZSJ4Eze5bSCPb/Oqym/hJsJ
3eS+HWg6XGc1kR6OYbvOGudXULGwvk/vQkQvDtG/LbGWcANmrRZvKrsbjGugqzF+
uLod5I5KUxzkLYT1Z0ZTyTgvN6zvvkif67uZYzZd7bTX6zneUMShhbX58BmartYY
QfYK6shuNtC0yQW3WEahYVXKvJDjkfSRycuf199OuAYq0pycTc9zKAAhh/ckhTs6
SI4D8QqmMBceP9aTiRQmADHvM+oazNTQ3wQJLqkUaFqI56SJupko6CWnMDku9bPF
xiVDCTF1mljcSa+hjPXUtSfS8PfAaghupRO62FComQDMPVv8CoVahJ3ddgzEtWaO
flURoUOqhjiRHm0RR6nB
=SRpi
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--


