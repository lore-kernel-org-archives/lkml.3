Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaEFRyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:54:39 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:56950 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbaEFRyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:54:38 -0400
X-Greylist: delayed 81516 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 May 2014 13:54:38 EDT
From: =?UTF-8?q?Cl=C3=A9ment=20Calmels?= <clement.calmels@free.fr>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: sep: fix coding style issue
Date: Tue,  6 May 2014 19:54:41 +0200
Message-Id: <1399398881-2611-1-git-send-email-clement.calmels@free.fr>
X-Mailer: git-send-email 2.0.0.rc0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to fix coding style issue found by
scripts/checkpatch.pl utility.

Signed-off-by: Clément Calmels <clement.calmels@free.fr>
---
 drivers/staging/sep/sep_dev.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/sep/sep_dev.h b/drivers/staging/sep/sep_dev.h
index 5f6a07f..5faeefa1 100644
--- a/drivers/staging/sep/sep_dev.h
+++ b/drivers/staging/sep/sep_dev.h
@@ -139,12 +139,14 @@ struct sep_queue_info {
 static inline void sep_write_reg(struct sep_device *dev, int reg, u32 value)
 {
 	void __iomem *addr = dev->reg_addr + reg;
+
 	writel(value, addr);
 }
 
 static inline u32 sep_read_reg(struct sep_device *dev, int reg)
 {
 	void __iomem *addr = dev->reg_addr + reg;
+
 	return readl(addr);
 }
 
@@ -152,6 +154,7 @@ static inline u32 sep_read_reg(struct sep_device *dev, int reg)
 static inline void sep_wait_sram_write(struct sep_device *dev)
 {
 	u32 reg_val;
+
 	do {
 		reg_val = sep_read_reg(dev, HW_SRAM_DATA_READY_REG_ADDR);
 	} while (!(reg_val & 1));
-- 
2.0.0.rc0

