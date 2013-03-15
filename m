Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab3CONfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:35:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:12736 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab3CONfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:35:38 -0400
X-AuditID: cbfee61a-b7fa86d0000045ae-ef-514323a9fbe4
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [GIT PULL] DMA-mapping updates for v3.9-rc3
Date: Fri, 15 Mar 2013 14:35:29 +0100
Message-id: <1363354529-1430-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJMWRmVeSWpSXmKPExsVy+t9jAd2Vys6BBjvv8Fhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MlosPWQo2cVR0HellbmD8zNbFyMkhIWAi0TdhGSOELSZx4d56
	oDgXh5DAIkaJuSsvQzkrmCS2Nz4E62ATMJToetsFZosIGEl8fnGFFcRmFvCVuPNqFQuILQw0
	ddmZr0wgNouAqsTiHy/BangF3CXWzPwC1MsBtE1BYs4kmwmM3AsYGVYxiqYWJBcUJ6XnGuoV
	J+YWl+al6yXn525iBHvwmdQOxpUNFocYBTgYlXh4D/Q7BAqxJpYVV+YeYpTgYFYS4fX0cgwU
	4k1JrKxKLcqPLyrNSS0+xCjNwaIkznug1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwFg8vdRq5pbJ
	q6anmnp4Xj7Gtfhs/P/wtRJNf/v/cX8Rml7kJZ5lfE9LQnuL69G8oKelnL5v4m69qmvw5JSf
	Vaq9sOA4c0Gkwyzpyu9iNw7ctzuj/V93i1bjpvUiO5KdnuocXNt+LnLH4TyL2g17Jsyv2mq/
	7Vqa7bafxsW7pNZy2ERtKf0ZvV2JpTgj0VCLuag4EQByBmE73AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I would like to ask You for pulling a fix for ARM dma-mapping subsystem
for v3.9-rc3.

The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git fixes-for-3.9

for you to fetch changes up to 9d1400cf79afb49584b4873eb22cd5130cb341db:

  ARM: DMA-mapping: add missing GFP_DMA flag for atomic buffer allocation (2013-03-14 09:25:19 +0100)

----------------------------------------------------------------

This pull contains an important fix for all ARM architectures which use
ZONE_DMA. Without it dma_alloc_* calls with GFP_ATOMIC flag might have
allocated buffers outsize DMA zone.

Thanks!

Best regards
Marek Szyprowski
Samsung Poland R&D Center


Patch summary:

Marek Szyprowski (1):
      ARM: DMA-mapping: add missing GFP_DMA flag for atomic buffer allocation

 arch/arm/mm/dma-mapping.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)
