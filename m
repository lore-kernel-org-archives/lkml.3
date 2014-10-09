Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbaJILTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 07:19:38 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:44050 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaJILT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 07:19:28 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-9e-54366f39e004
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [GIT PULL] DMA-mapping update for v3.18
Date: Thu, 09 Oct 2014 13:19:17 +0200
Message-id: <1412853557-14574-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAJMWRmVeSWpSXmKPExsVy+t/xq7qW+WYhBntmiVtc3jWHzWLtkbvs
	Fo/63rI7MHucmPGbxaNvyypGj8+b5AKYo7hsUlJzMstSi/TtErgybn3Yw1Twgbvi97XXLA2M
	Tzi7GDk5JARMJOau3MQIYYtJXLi3nq2LkYtDSGApo8TxCb2MEE4fk8Sh3YuZQKrYBAwlut52
	sYHYIgJGEp9fXGEFsZkFfCXuvFrFAmILCxhIvHu0F6yeRUBVYt+vP2A1vAIeElfuP2GB2CYn
	8f/lCqYJjNwLGBlWMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoT4+ssOxsXHrA4xCnAwKvHw
	PvhnGiLEmlhWXJl7iFGCg1lJhPdNllmIEG9KYmVValF+fFFpTmrxIUYmDk6pBsb12fkKl8s3
	6jG/6/31JOSe3YZFrf4bJZ/uE3dcL7p615xfq1qC3jrLMClt4sjZfaNcY2E1a4Dsio5rhyMW
	C/870fPjqHprxYoXbP6Pd655uFaX4auPefftpBPcl3zLOm5v6i2/p2q2+H/Uu+Xi/7d/UnQ9
	/itk4tXqlZa6u14t7+J663Pnz6NFSizFGYmGWsxFxYkAt6310dMBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I would like to ask You for pulling patches for dma-mapping subsystem
for v3.18.

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git for-v3.18

for you to fetch changes up to b4bbb107d73bbc0d92c9ae7fd8e69580aa9381e7:

  dma-mapping: Provide write-combine allocations (2014-08-26 07:39:13 +0200)

----------------------------------------------------------------
Thierry Reding (2):
      s390: Implement dma_{alloc,free}_attrs()
      dma-mapping: Provide write-combine allocations

 arch/arm/include/asm/dma-mapping.h       | 16 ----------------
 arch/s390/Kconfig                        |  5 +----
 arch/s390/include/asm/dma-mapping.h      | 31 +++++++++++++++++++++----------
 include/asm-generic/dma-mapping-common.h |  8 --------
 include/linux/dma-mapping.h              | 26 ++++++++++++++++++++++++++
 5 files changed, 48 insertions(+), 38 deletions(-)
----------------------------------------------------------------

This pull request contains patches, which provide dma write coherent api
(available previously on ARM architecture) for all other architectures,
which use dma_ops-based dma mapping implementation. This lets one to use
the same code in the device drivers regardless of the selected
architecture.

Thanks!

Best regards
Marek Szyprowski
Samsung R&D Institute Poland
