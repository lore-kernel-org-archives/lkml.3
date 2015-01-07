Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbbAGPzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 10:55:24 -0500
Received: from 8bytes.org ([81.169.241.247]:47493 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829AbbAGPzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 10:55:22 -0500
Date: Wed, 7 Jan 2015 16:55:19 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU Fixes for Linux v3.19-rc3
Message-ID: <20150107155519.GA13933@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit b7392d2247cfe6771f95d256374f1a8e6a6f48d6:

  Linux 3.19-rc2 (2014-12-28 16:49:37 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/iommu-fixes-v3.19-rc3

for you to fetch changes up to 2c0ee8b85aae427fa8432788ddf05c8a87510657:

  iommu/rockchip: Drop owner assignment from platform_drivers (2015-01-05 12:40:06 +0100)

----------------------------------------------------------------
IOMMU Fixes for Linux v3.19-rc3

Including:

	* A domain structure leak fix in the Intel VT-d driver

	* Compile error fix for the VMSA IPMMU driver because of the
	  IOMMU_EXEC -> IOMMU_NOEXEC conversion

	* Two small cleanups as an aftermath of the merge window and the
	  domain-leak fix

----------------------------------------------------------------
Joerg Roedel (2):
      iommu/vt-d: Fix dmar_domain leak in iommu_attach_device
      iommu/vt-d: Remove dead code in device_notifier

Laurent Pinchart (1):
      iommu/ipmmu-vmsa: Change IOMMU_EXEC to IOMMU_NOEXEC

Wolfram Sang (1):
      iommu/rockchip: Drop owner assignment from platform_drivers

 drivers/iommu/intel-iommu.c    | 12 ++++--------
 drivers/iommu/ipmmu-vmsa.c     |  6 +++---
 drivers/iommu/rockchip-iommu.c |  1 -
 3 files changed, 7 insertions(+), 12 deletions(-)

Please pull.

Thanks,

	Joerg


--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJUrVbnAAoJECvwRC2XARrjkmsP/RCIj73MfgY2RZ6z3DOtOOEQ
c3BY8FTVp4/una6Zd8zRA8PV8B0o28X+iVqSLPo/XU7CoK0/enSSszx/tEBMMhDl
2an0TwMshVpUAoRwthXSgeCaNNAfCiBG91vpYNS2g/euQglINlKx4CthKx7nptvH
NndKuS2Bhd5z0RbOCP0q+C4Fjv+NXHqb4W/X7bKP+sBfDBE6cuWEwaMymHB+WwjE
fcN071vu96RkcD3C7Cb1hkbuZgi/aU0cQBk5Nc5KrESB4+djSz7TjtOS5RFXkNqZ
cbSYfYpu1JNTM24k7dAEnH0Q+wrx/pcGMTCvMmqI7ljSdJ8Pal9v91iOF42AnFqx
hwdRyQhHCDFfMguhUxrD22VAWIIvNhKbpGpoGSgHCHlpGw5Cm7WygPtbeOPBfp1E
a+E5lJtJpG53kledhol09et8tr3OXZa8xUIvDYzXcS1uxolMP79VpkB6Swp4gq8i
ZupYHOQqALOtoi04o3VdscOr3NEadCfnEtn/MsmhdmIx5bcSsVPgkTK88pwP9qkp
JrdgzVFe6rTefQleksBnuiHl+h2mcuCBEvKzpi5bLQa2mnXjdqKzslEexQaaZSzy
T1sBKRn6/eJ8rymXJoxxK54uIlDU1KJCq/WnfQd1OUafcUsFq/C33r4PLPtuQ0iL
k1qoJ+BHpd/AwgWz3ScG
=D4Q3
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
