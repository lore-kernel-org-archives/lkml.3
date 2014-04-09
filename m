Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359AbaDIHYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 03:24:47 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.97]:34505 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758341AbaDIHYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 03:24:46 -0400
From: Christoph Jaeger <christophjaeger@linux.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: linux-kernel@vger.kernel.org, Christoph Jaeger <christophjaeger@linux.com>
Subject: [PATCH] mfd: cleanup asic3_init()
Date: Wed,  9 Apr 2014 09:24:37 +0200
Message-Id: <1397028277-30661-1-git-send-email-christophjaeger@linux.com>
X-Mailer: git-send-email 1.9.0
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove superfluous variable.

Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>
---
 drivers/mfd/asic3.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 9f6294f..b795184 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -1071,9 +1071,7 @@ static struct platform_driver asic3_device_driver = {
 
 static int __init asic3_init(void)
 {
-	int retval = 0;
-	retval = platform_driver_probe(&asic3_device_driver, asic3_probe);
-	return retval;
+	return platform_driver_probe(&asic3_device_driver, asic3_probe);
 }
 
 subsys_initcall(asic3_init);
-- 
1.9.0

