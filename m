Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbaDBFwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 01:52:23 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35604 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603AbaDBFwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 01:52:22 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-17-533ba59318f5
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [GIT PULL] DMA-mapping update for v3.15
Date: Wed, 02 Apr 2014 07:52:08 +0200
Message-id: <1396417928-5595-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPJMWRmVeSWpSXmKPExsVy+t/xa7qTl1oHG8yYxmFxedccNou1R+6y
	Wzzqe8vuwOxxYsZvFo++LasYPT5vkgtgjuKySUnNySxLLdK3S+DKeHDsP2PBUe6KF09OsTcw
	buPsYuTkkBAwkdixZBY7hC0mceHeerYuRi4OIYGljBIPb/1lgnD6mCROL9rNDFLFJmAo0fW2
	iw3EFhEwkvj84goriM0s4Ctx59UqFhBbWMBAoqnjHFgNi4CqxKeDZ8A28Aq4S7QdOQs0lANo
	m4LEnEk2Exi5FzAyrGIUTS1NLihOSs810itOzC0uzUvXS87P3cQI8fTXHYxLj1kdYhTgYFTi
	4ZW8ZBUsxJpYVlyZe4hRgoNZSYSXc5J1sBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbG3u+88w4z
	lV7qeOy/gH2h06XifXfv87Z9ZtWOaP9s1VBRm89guWF187S8ZerXruyddVztqrjHQo6JdxZZ
	h6vYH6xxW1gslbG8lklY8p7ukWe6i9MPbIiNvv46Ps8hyqLhMIuPmYPD3qgD0heLv2eGh0zW
	+M3IZyr+jXvD1Z7KB53/M3IrIyYqsRRnJBpqMRcVJwIAOUXR/dIBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I would like to ask You for pulling fixes for dma-mapping subsystem for
ARM for v3.15.

The following changes since commit cfbf8d4857c26a8a307fb7cd258074c9dcd8c691:

  Linux 3.14-rc4 (2014-02-23 17:40:03 -0800)

are available in the git repository at:

  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git for-3.15

for you to fetch changes up to 68efd7d2fb32c2606f1da318b6a851d933813f27:

  arm: dma-mapping: remove order parameter from arm_iommu_create_mapping() (2014-02-28 11:55:18 +0100)

----------------------------------------------------------------
Andreas Herrmann (1):
      arm: dma-mapping: Add support to extend DMA IOMMU mappings

Marek Szyprowski (1):
      arm: dma-mapping: remove order parameter from arm_iommu_create_mapping()

 arch/arm/include/asm/dma-iommu.h          |   12 ++-
 arch/arm/mm/dma-mapping.c                 |  144 +++++++++++++++++++++++------
 drivers/gpu/drm/exynos/exynos_drm_drv.h   |    2 -
 drivers/gpu/drm/exynos/exynos_drm_iommu.c |    6 +-
 drivers/gpu/drm/exynos/exynos_drm_iommu.h |    1 -
 drivers/iommu/shmobile-iommu.c            |    2 +-
 6 files changed, 124 insertions(+), 43 deletions(-)
----------------------------------------------------------------

This pull request contains extension for more efficient handling of io
address space for dma-mapping subsystem for ARM architecture.

Thanks!

Best regards
Marek Szyprowski
Samsung R&D Institute Poland
