Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbbASLG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 06:06:26 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:48344 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbbASLGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 06:06:25 -0500
Date: Mon, 19 Jan 2015 13:05:52 -0900
From: Ahmad Hassan <ahmad.hassan612@gmail.com>
To: devel@driverdev.osuosl.org
Cc: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com,
        gclement@baobob.org, joe@perches.com, guido@vanguardiasur.com.ar,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: vt6655: fix space prohibted before that ','
 Signed-off-by: Ahmad Hassan <ahmad.hassan612@gmail.com>
Message-ID: <20150119220552.GA28271@Arch-Thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/vt6655/device_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index f5cc78e..34e3a76 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1090,7 +1090,7 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 	// Must do this after doing rx/tx, cause ISR bit is slow
 	// than RD/TD write back
 	// update ISR counter
-	STAvUpdate802_11Counter(&pDevice->s802_11Counter, &pDevice->scStatistic , dwMIBCounter);
+	STAvUpdate802_11Counter(&pDevice->s802_11Counter, &pDevice->scStatistic, dwMIBCounter);
 	while (pDevice->dwIsr != 0) {
 		STAvUpdateIsrStatCounter(&pDevice->scStatistic, pDevice->dwIsr);
 		MACvWriteISR(pDevice->PortOffset, pDevice->dwIsr);
-- 
2.2.1

