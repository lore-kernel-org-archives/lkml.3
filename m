Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab3BEO0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:26:36 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:26645 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab3BEO0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:26:35 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-65-5111169afa00
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [GIT PULL] DMA-mapping updates for v3.8-rc7
Date: Tue, 05 Feb 2013 15:26:17 +0100
Message-id: <1360074377-10348-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJMWRmVeSWpSXmKPExsVy+t9jAd1ZYoKBBm+75S0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGz327mQpeSVTMu7CWtYFxqUgXIyeHhICJxIr1bawQtpjEhXvr
	2boYuTiEBBYxSnT2PWGHcFYwSXxbsY0ZpIpNwFCi620XG4gtImAk8fnFFbBuZoEqieuHp7KA
	2MJAU9fNuwVWwyKgKvFs+l8wm1fAQ6KpfwKQzQG0TUFiziSbCYzcCxgZVjGKphYkFxQnpeca
	6RUn5haX5qXrJefnbmIEe/CZ9A7GVQ0WhxgFOBiVeHh/XOYPFGJNLCuuzD3EKMHBrCTCay4q
	GCjEm5JYWZValB9fVJqTWnyIUZqDRUmcl/HUkwAhgfTEktTs1NSC1CKYLBMHp1QDo3VD905e
	Bce7r6z1A5ncTpy5tyD3WeBaRdbDqgFpSh/f7ffOEa1yvlLGZN8TIGqa/3k3310V7rUvRZ/2
	XAmedf2MT7PJpfJQvazvx9/NDLwnqCOzaEZTbuX0IBFzUYmTAbJq/05cfiYtUFZcdFvzuc22
	V7sNzm9Nldu6soS7Mttfrs/9+mdJJZbijERDLeai4kQAx/JqktwBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I would like to ask You for pulling an important bugfix patch set for
DMA-mapping subsystem for v3.8-rc7.

The following changes since commit 949db153b6466c6f7cad5a427ecea94985927311:

  Linux 3.8-rc5 (2013-01-25 11:57:28 -0800)

are available in the git repository at:

  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git fixes-for-v3.8-rc7

for you to fetch changes up to da57b936ea7b328d1009b37a0a0ad1f14148e104:

  xtensa: Provide dummy dma_mmap_coherent() and dma_get_sgtable() (2013-01-29 08:27:41 +0100)

----------------------------------------------------------------

This pull request contains important bugfix patches for 9 architectures,
which finally fixes broken allmodconfig builds introduced in v3.8-rc1.
Those architectures don't use dma_map_ops based implementation and
require manual update or additional dummy implementations of the missing
new dma-mapping api functions: dma_mmap_coherent and dma_get_sgtable.

Thanks!

Best regards
Marek Szyprowski
Samsung Poland R&D Center


Patch summary:

Geert Uytterhoeven (9):
      avr32: Provide dma_mmap_coherent() and dma_get_sgtable()
      blackfin: Provide dma_mmap_coherent() and dma_get_sgtable()
      c6x: Provide dummy dma_mmap_coherent() and dma_get_sgtable()
      cris: Provide dma_mmap_coherent() and dma_get_sgtable()
      frv: Provide dummy dma_mmap_coherent() and dma_get_sgtable()
      m68k: Provide dma_mmap_coherent() and dma_get_sgtable()
      mn10300: Provide dummy dma_mmap_coherent() and dma_get_sgtable()
      parisc: Provide dummy dma_mmap_coherent() and dma_get_sgtable()
      xtensa: Provide dummy dma_mmap_coherent() and dma_get_sgtable()

 arch/avr32/include/asm/dma-mapping.h    |   10 ++++++++++
 arch/blackfin/include/asm/dma-mapping.h |   10 ++++++++++
 arch/c6x/include/asm/dma-mapping.h      |   15 +++++++++++++++
 arch/cris/include/asm/dma-mapping.h     |   10 ++++++++++
 arch/frv/include/asm/dma-mapping.h      |   15 +++++++++++++++
 arch/m68k/include/asm/dma-mapping.h     |   10 ++++++++++
 arch/mn10300/include/asm/dma-mapping.h  |   15 +++++++++++++++
 arch/parisc/include/asm/dma-mapping.h   |   15 +++++++++++++++
 arch/xtensa/include/asm/dma-mapping.h   |   15 +++++++++++++++
 9 files changed, 115 insertions(+)















The following changes since commit 29594404d7fe73cd80eaa4ee8c43dcc53970c60e:

  Linux 3.7 (2012-12-10 19:30:57 -0800)

are available in the git repository at:

  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git for-v3.8

for you to fetch changes up to 4009793e15d44469da1547a46ab129cc08ffa503:

  drivers: cma: represent physical addresses as phys_addr_t (2012-12-11 09:28:09 +0100)


Marek Szyprowski (1):
      mm: dmapool: use provided gfp flags for all dma_alloc_coherent() calls

Vitaly Andrianov (1):
      drivers: cma: represent physical addresses as phys_addr_t

 drivers/base/dma-contiguous.c  |   24 ++++++++++--------------
 include/linux/dma-contiguous.h |    4 ++--
 mm/dmapool.c                   |   31 +++++++------------------------
 3 files changed, 19 insertions(+), 40 deletions(-)
