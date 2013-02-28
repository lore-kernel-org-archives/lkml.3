Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab3B1OrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:47:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42020 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420Ab3B1OrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:47:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tomasz Guszkowski <tsg@o2.pl>, "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 034/139] p54usb: corrected USB ID for T-Com Sinus 154 data II
Date: Thu, 28 Feb 2013 14:43:04 +0000
Message-Id: <1362062689-2567-35-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Guszkowski <tsg@o2.pl>

commit 008e33f733ca51acb2dd9d88ea878693b04d1d2a upstream.

Corrected USB ID for T-Com Sinus 154 data II. ISL3887-based. The
device was tested in managed mode with no security, WEP 128
bit and WPA-PSK (TKIP) with firmware 2.13.1.0.lm87.arm (md5sum:
7d676323ac60d6e1a3b6d61e8c528248). It works.

Signed-off-by: Tomasz Guszkowski <tsg@o2.pl>
Acked-By: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/p54/p54usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 4191294..3d4dd4d 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -84,8 +84,8 @@ static struct usb_device_id p54u_table[] = {
 	{USB_DEVICE(0x06b9, 0x0121)},	/* Thomson SpeedTouch 121g */
 	{USB_DEVICE(0x0707, 0xee13)},   /* SMC 2862W-G version 2 */
 	{USB_DEVICE(0x0803, 0x4310)},	/* Zoom 4410a */
-	{USB_DEVICE(0x083a, 0x4503)},	/* T-Com Sinus 154 data II */
 	{USB_DEVICE(0x083a, 0x4521)},   /* Siemens Gigaset USB Adapter 54 version 2 */
+	{USB_DEVICE(0x083a, 0x4531)},	/* T-Com Sinus 154 data II */
 	{USB_DEVICE(0x083a, 0xc501)},	/* Zoom Wireless-G 4410 */
 	{USB_DEVICE(0x083a, 0xf503)},	/* Accton FD7050E ver 1010ec  */
 	{USB_DEVICE(0x0846, 0x4240)},	/* Netgear WG111 (v2) */
-- 
1.8.1.2

