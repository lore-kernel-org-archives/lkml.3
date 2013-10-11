Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab3JKKoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:44:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58755 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab3JKKoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:44:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 081/100] p54usb: add USB ID for Corega WLUSB2GTST USB adapter
Date: Fri, 11 Oct 2013 11:41:51 +0100
Message-Id: <1381488130-30235-82-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Lamparter <chunkeey@googlemail.com>

commit 1e43692cdb7cc445d6347d8a5207d9cef0c71434 upstream.

Added USB ID for Corega WLUSB2GTST USB adapter.

Reported-by: Joerg Kalisch <the_force@gmx.de>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/p54/p54usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 3d4dd4d..a8f1702d 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -83,6 +83,7 @@ static struct usb_device_id p54u_table[] = {
 	{USB_DEVICE(0x06a9, 0x000e)},	/* Westell 802.11g USB (A90-211WG-01) */
 	{USB_DEVICE(0x06b9, 0x0121)},	/* Thomson SpeedTouch 121g */
 	{USB_DEVICE(0x0707, 0xee13)},   /* SMC 2862W-G version 2 */
+	{USB_DEVICE(0x07aa, 0x0020)},	/* Corega WLUSB2GTST USB */
 	{USB_DEVICE(0x0803, 0x4310)},	/* Zoom 4410a */
 	{USB_DEVICE(0x083a, 0x4521)},   /* Siemens Gigaset USB Adapter 54 version 2 */
 	{USB_DEVICE(0x083a, 0x4531)},	/* T-Com Sinus 154 data II */
-- 
1.8.3.2

