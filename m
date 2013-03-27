Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab3C0Jql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:46:41 -0400
Received: from 8bytes.org ([85.214.48.195]:47151 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab3C0Jqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:46:39 -0400
Date: Wed, 27 Mar 2013 10:46:35 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU Fixes for v3.9-rc4
Message-ID: <20130327094547.GA8513@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Mar 27 10:46:37 2013
X-DSPAM-Confidence: 0.9990
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5152bffd23675863038432
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/iommu-fixes-v3.9-rc4

for you to fetch changes up to c2a2876e863356b092967ea62bebdb4dd663af80:

  iommu/amd: Make sure dma_ops are set for hotplug devices (2013-03-27 09:59:50 +0100)

----------------------------------------------------------------
IOMMU fixes for Linux v3.9-rc4

Here are some fixes which have collected since Linux v3.9-rc1. The most
important one fixes a long-standing regressen which make re-hotplugged
devices unusable when AMD IOMMU is used. The other patches fix build
issues (build regression on OMAP and a section mismatch). One patch just
removes a duplicate header include.

----------------------------------------------------------------
Arnd Bergmann (1):
      iommu: OMAP: build only on OMAP2+

Joerg Roedel (1):
      iommu/amd: Make sure dma_ops are set for hotplug devices

Nikola Pajkovsky (1):
      amd_iommu_init: remove __init from amd_iommu_erratum_746_workaround

Wei Yongjun (1):
      x86, io_apic: remove duplicated include from irq_remapping.c

 drivers/iommu/Kconfig          |    2 +-
 drivers/iommu/amd_iommu.c      |   22 ++++++++++------------
 drivers/iommu/amd_iommu_init.c |    2 +-
 drivers/iommu/irq_remapping.c  |    1 -
 4 files changed, 12 insertions(+), 15 deletions(-)

Please pull.

Regards,

	Joerg


--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJRUr/KAAoJECvwRC2XARrju6oP/inNCbmmpao4HPG3K5wYxCJJ
Tjfda0phxlaVZyaz1tpfZlWr7gtVshXw1YL4VRUKhVYqxNb7mDV33GvNz5cbU6Pe
keYP7WnF4MYMunrAa7B+jX+1rJkGaIDeD/cUUxjSGjvM3fySmYmJJc7GUBCXRjX8
Z6BuXSVjFaC0qqfD+IwUtpfwkvee9dgBnKHUBJdMoWLzkUmHwP0b/rb2H0pCT5sB
sYfuE1vZdCXbnQUKHmOARCXxDE8cc2EH8t4E9lCc76piEG0nDgIejRrfOJ2WkmyR
fiIwodGE3htN15WdOpO4LtOGBv8l50Lfe8mT6ErWPKnRKookPsqADVTbp+WmQLw+
W+adXocyxPbm3qH7OpYLfWjD3XZj8x85SQjRUdFY4ziJqeFyKv93CnFaalPwZTbN
EkNQhfS6QLemvbi0FPBmufXjIgUXJ3MlQolruGzr4p5va6+SqtssK61a0ewV4q05
H8RUbRsIFxp2uQWUwDQWj0uINwM2/M1Sp7zoEs1IRCnGIdDjc8XtO7sEzYSeOypG
7BsLvhU8bey5ott0Z7Skx7KMmIwzAH7DfiiPXmnZqiXK6Rt+lKrU00+DT07EJ09B
/glp1xCEPewTHpPOkdFYES0kIZDSASyDj6oXuWqqCymKekrnzcL1FcbTqF2R2jhf
y9pYgME+RBwkzs1M9uWW
=N4bp
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--


