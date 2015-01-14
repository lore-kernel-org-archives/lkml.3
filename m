Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbbANIXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:23:12 -0500
Received: from mga03.intel.com ([134.134.136.65]:21261 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbbANIXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:23:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,754,1413270000"; 
   d="scan'208";a="661592431"
From: Ong Boon Leong <boon.leong.ong@intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: lpc_sch: enable WDT for Intel Quark X1000
Date: Wed, 14 Jan 2015 16:20:20 +0800
Message-Id: <1421223621-22385-2-git-send-email-boon.leong.ong@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421223621-22385-1-git-send-email-boon.leong.ong@intel.com>
References: <1421223621-22385-1-git-send-email-boon.leong.ong@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quark X1000 uses ie6xx_wdt driver for WDT. To enable WDT, we declare WDT IO
resource size for Quark X1000.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/mfd/lpc_sch.c |    1
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
index 5c38df3..a56e4ba 100644
--- a/drivers/mfd/lpc_sch.c
+++ b/drivers/mfd/lpc_sch.c
@@ -75,6 +75,7 @@ static struct lpc_sch_info sch_chipset_info[] = {
 	[LPC_QUARK_X1000] = {
 		.io_size_gpio = GPIO_IO_SIZE,
 		.irq_gpio = GPIO_IRQ_QUARK_X1000,
+		.io_size_wdt = WDT_IO_SIZE,
 	},
 };
 
-- 
1.7.9.5

