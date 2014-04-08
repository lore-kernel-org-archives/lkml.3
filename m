Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbaDHPcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:32:53 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:43603 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752AbaDHPcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:32:51 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging:Octeon-usb:octeon-hcd.c return value
Date: Tue,  8 Apr 2014 16:32:48 +0100
Message-Id: <1396971168-29605-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

return value instead of function.

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 drivers/staging/octeon-usb/octeon-hcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/octeon-usb/octeon-hcd.c b/drivers/staging/octeon-usb/octeon-hcd.c
index 8b8ce72..2d15001 100644
--- a/drivers/staging/octeon-usb/octeon-hcd.c
+++ b/drivers/staging/octeon-usb/octeon-hcd.c
@@ -3483,7 +3483,7 @@ static int octeon_usb_hub_status_data(struct usb_hcd *hcd, char *buf)
 	buf[0] = 0;
 	buf[0] = port_status.connect_change << 1;
 
-	return (buf[0] != 0);
+	return buf[0] != 0;
 }
 
 static int octeon_usb_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue, u16 wIndex, char *buf, u16 wLength)
-- 
1.8.3.2

