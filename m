Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab3LJUYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:24:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168Ab3LJUYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:24:10 -0500
Message-ID: <1386707033.22974.14.camel@ul30vt.home>
Subject: [GIT PULL] IOMMU fixes for v3.13-rc4
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joerg Roedel <joro@8bytes.org>, iommu <iommu@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>
Date: Tue, 10 Dec 2013 13:23:53 -0700
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Joerg is on holiday and asked me to pickup IOMMU fixes[1].  Thanks,

Alex

[1] https://lkml.org/lkml/2013/11/15/344

The following changes since commit 374b105797c3d4f29c685f3be535c35f5689b30e:

  Linux 3.13-rc3 (2013-12-06 09:34:04 -0800)

are available in the git repository at:

  git://github.com/awilliam/linux-vfio.git tags/iommu-fixes-for-v3.13-rc4

for you to fetch changes up to 239a87020b263fe7e70adc5803cb157955023d3c:

  Merge branch 'for-joerg/arm-smmu/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into for-linus (2013-12-06 14:32:15 -0700)

----------------------------------------------------------------

arm/smmu driver updates via Will Deacon fixing locking around page
table walks and a couple other issues.

----------------------------------------------------------------
Alex Williamson (1):
      Merge branch 'for-joerg/arm-smmu/fixes' of git://git.kernel.org/.../will/linux into for-linus

Wei Yongjun (1):
      iommu/arm-smmu: fix error return code in arm_smmu_device_dt_probe()

Will Deacon (2):
      iommu/arm-smmu: use mutex instead of spinlock for locking page tables
      iommu/arm-smmu: remove potential NULL dereference on mapping path

 drivers/iommu/arm-smmu.c | 66 ++++++++++++++++++++----------------------------
 1 file changed, 28 insertions(+), 38 deletions(-)


