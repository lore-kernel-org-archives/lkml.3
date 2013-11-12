Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab3KLTKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:10:37 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:35137 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab3KLTKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:10:35 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 07/12] staging: r8188eu: Remove superfluous name cast
Date: Tue, 12 Nov 2013 20:07:20 +0100
Message-Id: <1384283245-9419-8-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384283245-9419-1-git-send-email-geert@linux-m68k.org>
References: <1384283245-9419-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb_driver.name is "const char *"

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 7d14779310d3..b21b1566424b 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -71,7 +71,7 @@ struct rtw_usb_drv {
 };
 
 static struct rtw_usb_drv rtl8188e_usb_drv = {
-	.usbdrv.name = (char *)"r8188eu",
+	.usbdrv.name = "r8188eu",
 	.usbdrv.probe = rtw_drv_init,
 	.usbdrv.disconnect = rtw_dev_remove,
 	.usbdrv.id_table = rtw_usb_id_tbl,
-- 
1.7.9.5

