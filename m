Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759902Ab3BMT0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 14:26:50 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:43205 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720Ab3BMT0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 14:26:49 -0500
From: Girish K S <girishks2000@gmail.com>
To: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        t.figa@samsung.com, broonie@opensource.wolfsonmicro.com
Subject: [PATCH V2 0/5]  Add polling support for 64xx spi controller
Date: Wed, 13 Feb 2013 11:25:26 -0800
Message-Id: <1360783531-32654-1-git-send-email-ks.giri@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/5]: fixes the error handling in the interrupt handler
[PATCH 2/5]: The existing driver support partial polling mode.
	     This patch modifies the current driver to support
	     only polling mode.
[PATCH 3/5]: provision to support SoC's with dedicated i/o pins
[PATCH 4/5]: provision to support dedicated cs pin
[PATCH 5/5]: support exynos5440 SoC in polling mode

Tested this patch on exynos5250 in dma mode, and exynos5440 in
polling mode.

Girish K S (5):
  spi: s3c64xx: modified error interrupt handling and init
  spi: s3c64xx: added support for polling mode
  spi: s3c64xx: Added provision for non-gpio i/o's
  spi: s3c64xx: Added provision for dedicated cs pin
  spi: s3c64xx: Added support for exynos5440 spi

 drivers/spi/spi-s3c64xx.c                 |  216 ++++++++++++++++++++---------
 include/linux/platform_data/spi-s3c64xx.h |    3 +
 2 files changed, 155 insertions(+), 64 deletions(-)

-- 
1.7.10.4

