Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbaDXLi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:38:26 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41105 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbaDXLiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:38:20 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-ce-5358f7a9d585
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Ritesh Harjani <ritesh.harjani@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [GIT PULL] DMA-mapping fix for v3.15
Date: Thu, 24 Apr 2014 13:38:11 +0200
Message-id: <1398339491-4014-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCJMWRmVeSWpSXmKPExsVy+t/xK7orv0cEG/TvMbHonLiE3eLyrjls
	FmuP3GW3eH6xm93iUd9bdgdWj52z7rJ7zO6YyepxYsZvFo++LasYPT5vkgtgjeKySUnNySxL
	LdK3S+DKmHXxH1tBE0fFxie9LA2MN9i6GDk5JARMJF5vncwKYYtJXLi3HijOxSEksJRR4s2t
	D4wQTh+TxMr1P5lAqtgEDCW63naBdYsIGEl8fnGFFaSIWWATo8SdDV/ZQRLCAroSvRtXARVx
	cLAIqEps+uwIEuYVcJfYfbsdapucxMljk1knMHIvYGRYxSiaWppcUJyUnmukV5yYW1yal66X
	nJ+7iRESEl93MC49ZnWIUYCDUYmHV+FWeLAQa2JZcWXuIUYJDmYlEd4/zyOChXhTEiurUovy
	44tKc1KLDzEycXBKNTBuKI/bL/NnZ1ruU4vI1muBM+evVy2Xunjl0w+j/SuOWv7iniV0vzL+
	8CbW2o3/Wjaq/rg7633Ip+MxSkkSX4992X9lQk+Du9FlIenT7Y37dbNL1rL2fbw8o3xSynnl
	jKTN3OrH18evr77zPnplYIVJxO4O6cY7J2K/Kc2uDY94yacmt5E/4fQnJZbijERDLeai4kQA
	luPmS+cBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I would like to ask You for pulling a small fix for dma-mapping
subsystem for ARM for v3.15.

The following changes since commit a798c10faf62a505d24e5f6213fbaf904a39623f:

  Linux 3.15-rc2 (2014-04-20 11:08:50 -0700)

are available in the git repository at:

  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git fixes_for_v3.15

for you to fetch changes up to 59f0f119e85cfb173db518328b55efbac4087c9f:

  arm: dma-mapping: Fix mapping size value (2014-04-23 15:07:00 +0200)

----------------------------------------------------------------
Ritesh Harjani (1):
      arm: dma-mapping: Fix mapping size value

 arch/arm/mm/dma-mapping.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
----------------------------------------------------------------

This pull request contains an important fix for dma-mapping subsystem
for ARM, which resolves a possible NULL pointer dereference and kernel
ops.

Thanks!

Best regards
Marek Szyprowski
Samsung R&D Institute Poland
