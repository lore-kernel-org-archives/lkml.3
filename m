Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257Ab3JONLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 09:11:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44273 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759151Ab3JONLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 09:11:44 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-94-525d3f0f4f8b
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [GIT PULL] DMA-mapping fix for v3.12
Date: Tue, 15 Oct 2013 15:11:33 +0200
Message-id: <1381842693-10386-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDJMWRmVeSWpSXmKPExsVy+t9jQV1++9ggg2MTxS0u75rDZrH2yF12
	i0d9b9kdmD1OzPjN4tG3ZRWjx+dNcgHMUVw2Kak5mWWpRfp2CVwZj9unsxSc4aiY2/aOuYFx
	PnsXIyeHhICJxM55V5ghbDGJC/fWs3UxcnEICUxnlDg2r4EVJCEk0MokMWudPIjNJmAo0fW2
	iw3EFhEwkvj84gpYDbOAr8SdV6tYQGxhAV2J5mkQNSwCqhIHZ/aBLeAV8JDYMOkAYxcjB9Ay
	BYk5k2wmMHIvYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRHs52dSOxhXNlgcYhTgYFTi
	4f3BGxMkxJpYVlyZe4hRgoNZSYT3j1VskBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeA63WgUIC
	6YklqdmpqQWpRTBZJg5OqQbGqmWzSvsX33knvOeBDZvCqT0T1Q5nrD50tuq3geqDkun2l28f
	EWa4MftsMtOatTHPTutzbrp/u3JD+tNnvrUmffus1yeFLVzxcN+rT0KCk9N0P4gsLOpSXsF0
	6pzSpC9+aTE39/WvFHUtcJiUfPzUBMfjr8/mtInNdBV2jbwltlLjwLYH8YyMy5RYijMSDbWY
	i4oTAeIAvabvAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I would like to ask You for pulling a fix for dma-mapping subsystem for
ARM architecture for v3.12.

The following changes since commit 15c03dd4859ab16f9212238f29dd315654aa94f6:

  Linux 3.12-rc3 (2013-09-29 15:02:38 -0700)

are available in the git repository at:

  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git fixes-for-v3.12

for you to fetch changes up to c9b24996d5da1bf7d2bebab5770dfcc7834c53b7:

  ARM: dma-mapping: Always pass proper prot flags to iommu_map() (2013-10-02 13:23:11 +0200)

----------------------------------------------------------------
Andreas Herrmann (1):
      ARM: dma-mapping: Always pass proper prot flags to iommu_map()

 arch/arm/mm/dma-mapping.c |   43 ++++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 15 deletions(-)

----------------------------------------------------------------

This pull request contains a bugfix for the IOMMU-based implementation
of dma-mapping subsystem for ARM architecture.

Thanks!

Best regards
Marek Szyprowski
Samsung R&D Institute Poland
