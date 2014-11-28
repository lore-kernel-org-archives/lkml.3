Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbaK1OQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 09:16:18 -0500
Received: from [85.220.129.38] ([85.220.129.38]:49482 "EHLO smtp3-1.goneo.de"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbaK1OQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 09:16:17 -0500
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Nov 2014 09:16:17 EST
X-Spam-Flag: NO
X-Spam-Score: -2.799
From: poeschel@lemonage.de
To: gregkh@linuxfoundation.org, santosh.shilimkar@ti.com, sandeep_n@ti.com,
        kheitke@codeaurora.org, bp@suse.de, johannes.thumshirn@men.de,
        andreas.noever@gmail.com, linux-kernel@vger.kernel.org
Cc: Lars Poeschel <poeschel@lemonage.de>
Subject: [PATCH] drivers/Kconfig: remove duplicate entry for soc
Date: Fri, 28 Nov 2014 15:08:40 +0100
Message-Id: <1417183720-16767-1-git-send-email-poeschel@lemonage.de>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>

For some reason there was the same menu entry in menuconfig twice. This
trivial patch leaves the one that is older as is and removes the other
entry.

Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
 drivers/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 1a693d3..5add358 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -132,8 +132,6 @@ source "drivers/staging/Kconfig"
 
 source "drivers/platform/Kconfig"
 
-source "drivers/soc/Kconfig"
-
 source "drivers/clk/Kconfig"
 
 source "drivers/hwspinlock/Kconfig"
-- 
2.1.3

