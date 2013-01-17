Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759044Ab3AQDQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 22:16:01 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:64077 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758199Ab3AQDP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 22:15:57 -0500
Date: Wed, 16 Jan 2013 22:16:05 -0500
From: Jake Champlin <jake.champlin.27@gmail.com>
To: mfm@muteddisk.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        jake.champlin.27@gmail.com
Subject: [PATCH 2/2] Staging: usbip: usbipcommon: Fixed single line bracing
 issue
Message-ID: <20130117031600.GA1313@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issue with single line braces.

Signed-off-by: Jake Champlin <jake.champlin.27@gmail.com>
---
 drivers/staging/usbip/usbip_common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index 75189fe..75aa5bf 100644
--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -672,9 +672,8 @@ int usbip_recv_iso(struct usbip_device *ud, struct urb *urb)
 		return 0;
 
 	/* my Bluetooth dongle gets ISO URBs which are np = 0 */
-	if (np == 0) {
+	if (np == 0)
 		return 0;
-	}
 
 	buff = kzalloc(size, GFP_KERNEL);
 	if (!buff)
-- 
1.8.1.1


-- 
Jake Champlin
jake.champlin.27@gmail.com
8123742937
<MuttClient>
