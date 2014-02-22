Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaBVGCu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 01:02:50 -0500
Received: from fallback6.mail.ru ([94.100.176.134]:36894 "EHLO
	fallback6.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaBVGCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 01:02:49 -0500
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH] mfd: syscon: Move diagnostic messages to dev_dbg()
Date: Sat, 22 Feb 2014 10:02:25 +0400
Message-Id: <1393048945-15142-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.3.2
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves diagnostic messages used for debugging purposes
to dev_dbg().

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/mfd/syscon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index 71841f9..2620056 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -152,7 +152,7 @@ static int syscon_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, syscon);
 
-	dev_info(dev, "regmap %pR registered\n", res);
+	dev_dbg(dev, "regmap %pR registered\n", res);
 
 	return 0;
 }
-- 
1.8.3.2

