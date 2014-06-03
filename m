Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbaFCMNN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:13:13 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32736 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbaFCMNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 08:13:10 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-78-538dbbd35314
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [GIT PULL] CMA and DMA-mapping fixes for v3.16
Date: Tue, 03 Jun 2014 14:13:02 +0200
Message-id: <1401797582-19371-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAJMWRmVeSWpSXmKPExsVy+t/xy7qXd/cGGxzq4bS4vGsOm8XaI3fZ
	LR71vWV3YPY4MeM3i0ffllWMHp83yQUwR3HZpKTmZJalFunbJXBlnLk1k6lgAnfFhiU72RoY
	+zi7GDk5JARMJN5d2MwEYYtJXLi3nq2LkYtDSGApo0TX18MsEE4fk8TkL08YQarYBAwlut52
	sYHYIgJGEp9fXGEFsZkFfCXuvFrFAmILC5hLPHg7F8xmEVCVODqhGayeV8BD4vbzi6wQ2+Qk
	/r9cwTSBkXsBI8MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjBBff93BuPSY1SFGAQ5GJR7e
	m296goVYE8uKK3MPMUpwMCuJ8P5b3xssxJuSWFmVWpQfX1Sak1p8iJGJg1OqgVHH1q/KWZFj
	du2JuWvusqrM4lrwZPlWcYvyD/pLyq/EWCmtfHqy/r3R9p8+M5ULn0etmN7Pan+5kPk2fymf
	Yaig7AM9oTC73rS9nLOjjfoN+3n8l81QeaJd9//RTj3hkMqEVY+5rR/eXatZkj9D1GNfteFD
	ppvZxXd7/bZobucU25Y+c8JMWSWW4oxEQy3mouJEAHDUlizTAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I would like to ask You for pulling a few fixes for dma-mapping and CMA
subsystems for v3.16.

The following changes since commit d6d211db37e75de2ddc3a4f979038c40df7cc79c:

  Linux 3.15-rc5 (2014-05-09 13:10:52 -0700)

are available in the git repository at:

  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git for-v3.16

for you to fetch changes up to f70e3c4f8b6ab61f713e040822ec51f5de498146:

  CMA: correct unlock target (2014-05-29 09:25:14 +0200)

----------------------------------------------------------------
Gioh Kim (2):
      arm: dma-mapping: add checking cma area initialized
      drivers/base/dma-contiguous.c: erratum of dev_get_cma_area

Joonsoo Kim (1):
      CMA: correct unlock target

Laura Abbott (1):
      cma: Remove potential deadlock situation

Ritesh Harjani (1):
      arm: dma-iommu: Clean up redundant variable

 arch/arm/include/asm/dma-iommu.h |  1 -
 arch/arm/mm/dma-mapping.c        | 17 +++++++++--------
 drivers/base/dma-contiguous.c    | 34 ++++++++++++++++++++++++++--------
 3 files changed, 35 insertions(+), 17 deletions(-)
----------------------------------------------------------------

This pull request contains a patches for solving potential deadlock
caused by CMA code, bugfix for ARM dma-mapping subsystem and minor code
cleanups.

Thanks!

Best regards
Marek Szyprowski
Samsung R&D Institute Poland
