Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965019Ab3GEPcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 11:32:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:47881 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458Ab3GEPcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 11:32:10 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-d7-51d6e6f8bd90
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [GIT PULL] DMA-mapping updates for v3.11
Date: Fri, 05 Jul 2013 17:31:59 +0200
Message-id: <1373038319-6935-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDJMWRmVeSWpSXmKPExsVy+t9jQd2fz64FGnz5z2xxedccNou1R+6y
	Wzzqe8vuwOxxYsZvFo++LasYPT5vkgtgjuKySUnNySxLLdK3S+DK+PVkB2NBJ0/F5CufWBsY
	P3B2MXJySAiYSHxc844dwhaTuHBvPVsXIxeHkMB0RonfDW1QTjuTxPEtN8Cq2AQMJbredrGB
	2CICRhKfX1xhBbGZBXwl7rxaxQJiCwPVrNlxE8xmEVCV+HJ8B1AvBwevgLvEkedJIKaEgILE
	nEk2Exi5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQI9vMzqR2MKxssDjEKcDAq8fBm
	3LgWKMSaWFZcmXuIUYKDWUmE1z4BKMSbklhZlVqUH19UmpNafIhRmoNFSZz3QKt1oJBAemJJ
	anZqakFqEUyWiYNTqoHR5/Ul2ez4Ld5JzdtzhOZn2GVI+Fxk/PKl7SXnlJhjIumMb7VLDbkW
	bmDZ+2Z7wMbNBSLBV9d+1dablPjHXlSRR0K++H7lMSczo7In2Xs7q224Vy2x/2g4YSLPp9dL
	2eMc4xe7X5ts/6fDKkhdSW9PBOvSRTK/Kp8UCqy/+nDivz9WfvIK3rVKLMUZiYZazEXFiQCA
	DdyZ7wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I'm really sorry for the rebased tree last time. I restored the tree
that was in linux next for a long time till 2nd July. I would like to
ask You for pulling fixes for ARM dma-mapping subsystem for v3.11.


The following changes since commit 9e895ace5d82df8929b16f58e9f515f6d54ab82d:

  Linux 3.10-rc7 (2013-06-22 09:47:31 -1000)

are available in the git repository at:

  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git for-v3.11

for you to fetch changes up to 5b91a98c61abe914e6a80d7dc15e435c47ea0004:

  ARM: dma: Drop __GFP_COMP for iommu dma memory allocations (2013-06-28 15:14:29 +0200)

----------------------------------------------------------------
Ming Lei (1):
      ARM: DMA-mapping: mark all !DMA_TO_DEVICE pages in unmapping as clean

Richard Zhao (1):
      ARM: dma: Drop __GFP_COMP for iommu dma memory allocations

Will Deacon (2):
      ARM: dma-mapping: convert DMA direction into IOMMU protection attributes
      ARM: dma-mapping: NULLify dev->archdata.mapping pointer on detach

YoungJun Cho (1):
      ARM: dma-mapping: Get pages if the cpu_addr is out of atomic_pool

 arch/arm/mm/dma-mapping.c |   60 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 49 insertions(+), 11 deletions(-)

----------------------------------------------------------------

This pull request contains an important bugfixes and update for IOMMU
integration support for ARM architecture.

Thanks!

Best regards
Marek Szyprowski
Samsung Poland R&D Center
