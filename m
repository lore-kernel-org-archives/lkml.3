Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab3IFQs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 12:48:58 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53243 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab3IFQs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 12:48:56 -0400
From: Mark Brown <broonie@kernel.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: patches@opensource.wolfsonmicro.com, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@linaro.org>
Date: Fri,  6 Sep 2013 17:48:35 +0100
Message-Id: <1378486115-4926-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] mfd: wm8994: Remove unused irq_lock
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Since the conversion to regmap-irq irq_lock has been unused.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 include/linux/mfd/wm8994/core.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/mfd/wm8994/core.h b/include/linux/mfd/wm8994/core.h
index 3fbcf3d..eefafa6 100644
--- a/include/linux/mfd/wm8994/core.h
+++ b/include/linux/mfd/wm8994/core.h
@@ -56,8 +56,6 @@ struct irq_domain;
 #define WM8994_IRQ_GPIO(x) (x + WM8994_IRQ_TEMP_WARN)
 
 struct wm8994 {
-	struct mutex irq_lock;
-
 	struct wm8994_pdata pdata;
 
 	enum wm8994_type type;
-- 
1.8.4.rc3

