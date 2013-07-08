Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab3GHKnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 06:43:47 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53292 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab3GHKno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 06:43:44 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-omap@vger.kernel.org>,
        <kishon@ti.com>, <bigeasy@linutronix.de>, Ravi Babu <ravibabu@ti.com>
Subject: [PATCH 1/5] usb: musb: dsps: enable dual instance support for am33xx platform
Date: Mon, 8 Jul 2013 16:13:17 +0530
Message-ID: <1373280201-31785-2-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1373280201-31785-1-git-send-email-george.cherian@ti.com>
References: <1373280201-31785-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravi Babu <ravibabu@ti.com>

The dsps am33xx platform has two instances of musb controller,
enable the support for dual musb instances

Signed-off-by: Ravi Babu <ravibabu@ti.com>
---
 drivers/usb/musb/musb_dsps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index e1b661d..41f135a 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -747,7 +747,7 @@ static const struct dsps_musb_wrapper ti81xx_driver_data = {
 	.rxep_bitmap		= (0xfffe << 16),
 	.musb_core_offset	= 0x400,
 	.poll_seconds		= 2,
-	.instances		= 1,
+	.instances		= 2,
 };
 
 static const struct platform_device_id musb_dsps_id_table[] = {
-- 
1.8.1.4

