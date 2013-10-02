Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab3JBNBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 09:01:07 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48312 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab3JBNBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 09:01:04 -0400
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <luca@coelho.fi>
CC: <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH] net: wireless: wl1251: update firmware path
Date: Wed, 2 Oct 2013 08:00:48 -0500
Message-ID: <1380718848-26634-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.3.4.840.g6a90778
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TI firmwares are located under ti-connectivity
directory. Update path to make sure driver can
find and load firmware blob.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/net/wireless/ti/wl1251/wl1251.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/wl1251.h b/drivers/net/wireless/ti/wl1251/wl1251.h
index fd02060..2c3bd1b 100644
--- a/drivers/net/wireless/ti/wl1251/wl1251.h
+++ b/drivers/net/wireless/ti/wl1251/wl1251.h
@@ -424,8 +424,8 @@ void wl1251_disable_interrupts(struct wl1251 *wl);
 #define CHIP_ID_1271_PG10	           (0x4030101)
 #define CHIP_ID_1271_PG20	           (0x4030111)
 
-#define WL1251_FW_NAME "wl1251-fw.bin"
-#define WL1251_NVS_NAME "wl1251-nvs.bin"
+#define WL1251_FW_NAME "ti-connectivity/wl1251-fw.bin"
+#define WL1251_NVS_NAME "ti-connectivity/wl1251-nvs.bin"
 
 #define WL1251_POWER_ON_SLEEP 10 /* in milliseconds */
 
-- 
1.8.3.4.840.g6a90778

