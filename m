Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab3GXI0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 04:26:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44845 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab3GXI0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:26:50 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] regmap: irq: document mask/wake_invert flags
Date: Wed, 24 Jul 2013 10:26:48 +0200
Message-Id: <1374654408-4964-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.8.3.2
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 include/linux/regmap.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 99b211a..53c5d80 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -471,6 +471,8 @@ struct regmap_irq {
  * @wake_base:   Base address for wake enables.  If zero unsupported.
  * @irq_reg_stride:  Stride to use for chips where registers are not contiguous.
  * @init_ack_masked: Ack all masked interrupts once during initalization.
+ * @mask_invert: Inverted mask register: cleared bits are masked out.
+ * @wake_invert: Inverted wake register: cleared bits are wake enabled.
  * @runtime_pm:  Hold a runtime PM lock on the device when accessing it.
  *
  * @num_regs:    Number of registers in each control bank.
-- 
1.8.3.2

