Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab3BEXKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 18:10:52 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:40846 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381Ab3BEXKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 18:10:50 -0500
From: Girish K S <girishks2000@gmail.com>
To: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/4] Add polling support for 64xx spi controller
Date: Tue,  5 Feb 2013 15:09:40 -0800
Message-Id: <1360105784-12282-1-git-send-email-ks.giri@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/4]: fixes the error handling in the interrupt handler
[PATCH 2/4]: The existing driver support partial polling mode.
	     This patch modifies the current driver to support
	     only polling mode.
[PATCH 3/4]: Adds quirk to support SoC's with dedicated i/o pins
[PATCH 4/4]: Adds the support for exynos5440 SoC, this SoC has
	     no support for dma transfer and consists of dedicated
	     i/o pins.

Girish K S (4):
  spi: s3c64xx: modified error interrupt handling and init
  spi: s3c64xx: added support for polling mode
  spi: s3c64xx: add gpio quirk for controller
  spi: s3c64xx: add support for exynos5440 spi

 drivers/spi/spi-s3c64xx.c |  157 ++++++++++++++++++++++++++++-----------------
 1 file changed, 98 insertions(+), 59 deletions(-)

-- 
1.7.10.4

