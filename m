Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab3GBIgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 04:36:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:14988 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab3GBIgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 04:36:07 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-f7-51d290f0b285
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [GIT PULL] DMA-mapping updates for v3.11
Date: Tue, 02 Jul 2013 10:35:08 +0200
Message-id: <1372754108-21075-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLJMWRmVeSWpSXmKPExsVy+t9jAd0PEy4FGnRcF7a4vGsOm8XaI3fZ
	LR71vWV3YPY4MeM3i0ffllWMHp83yQUwR3HZpKTmZJalFunbJXBl3Fj+gb3gF2dF/6clrA2M
	fRxdjJwcEgImEh3vOxkhbDGJC/fWs3UxcnEICSxilLgw4S0LhNPOJHGq/ScTSBWbgKFE19su
	NhBbRMBI4vOLK6wgNrOAr8SdV6tYQGxhoJo1O26C2SwCqhLLp94Cs3kFPCQ+Pj4KVM8BtE1B
	Ys4kmwmM3AsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBHv6mfQOxlUNFocYBTgYlXh4
	FeZdDBRiTSwrrsw9xCjBwawkwnvTGyjEm5JYWZValB9fVJqTWnyIUZqDRUmc92CrdaCQQHpi
	SWp2ampBahFMlomDU6qBkeOrQvSD0GucJ97Ou3n91uZLXTEXnk4QyF/9yOlD19GV35dvbDgX
	embDw0U3ihepz2AXTWmdaf2Db4p06hrvbG3jY91lAUv0/m7X0Fp5vYM/8YavhCPbObGIDuan
	eWlFz1suLz3KfCTn65lN1m0Vyd0S626eU2Qo40k2/bA4/cxxZcPsW4Z11UosxRmJhlrMRcWJ
	AM/KG4nwAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I would like to ask You for pulling some fixes for ARM dma-mapping subsystem
for v3.11.


The following changes since commit 8bb495e3f02401ee6f76d1b1d77f3ac9f079e376:

  Linux 3.10 (2013-06-30 15:13:29 -0700)

are available in the git repository at:

  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git for-v3.11

for you to fetch changes up to 1e3d09b223f349a5f6cc14d62b4df66c0798d762:

  ARM: dma: Drop __GFP_COMP for iommu dma memory allocations (2013-07-02 10:30:59 +0200)

----------------------------------------------------------------

This pull request contains an important bugfixes and update for IOMMU
integration support for ARM architecture.

Thanks!

Best regards
Marek Szyprowski
Samsung Poland R&D Center

Patch summary:

Richard Zhao (1):
      ARM: dma: Drop __GFP_COMP for iommu dma memory allocations

Will Deacon (2):
      ARM: dma-mapping: convert DMA direction into IOMMU protection attributes
      ARM: dma-mapping: NULLify dev->archdata.mapping pointer on detach

YoungJun Cho (1):
      ARM: dma-mapping: Get pages if the cpu_addr is out of atomic_pool

 arch/arm/mm/dma-mapping.c |   40 ++++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)
