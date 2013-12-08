Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab3LHJuv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 04:50:51 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:41997 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab3LHJuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 04:50:06 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 1/3] rtc: rtc-cmos: Remove superfluous name cast
Date: Sun,  8 Dec 2013 10:49:55 +0100
Message-Id: <1386496197-20669-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_driver.name is "const char *"

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
---
 drivers/rtc/rtc-cmos.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index f14876256a4a..ed5540d78a80 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -1127,7 +1127,7 @@ static struct platform_driver cmos_platform_driver = {
 	.remove		= __exit_p(cmos_platform_remove),
 	.shutdown	= cmos_platform_shutdown,
 	.driver = {
-		.name		= (char *) driver_name,
+		.name		= driver_name,
 #ifdef CONFIG_PM
 		.pm		= &cmos_pm_ops,
 #endif
-- 
1.7.9.5

