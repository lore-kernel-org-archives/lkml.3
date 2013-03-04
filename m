Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab3CDDsw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:48:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33158 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757345Ab3CDDot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:49 -0500
Message-Id: <20130304033711.335950961@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:45 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Tomasz Guszkowski <tsg@o2.pl>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 038/153] p54usb: corrected USB ID for T-Com Sinus 154 data II
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/p54/p54usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -84,8 +84,8 @@ static struct usb_device_id p54u_table[]
 	{USB_DEVICE(0x06b9, 0x0121)},	/* Thomson SpeedTouch 121g */
 	{USB_DEVICE(0x0707, 0xee13)},   /* SMC 2862W-G version 2 */
 	{USB_DEVICE(0x0803, 0x4310)},	/* Zoom 4410a */
-	{USB_DEVICE(0x083a, 0x4503)},	/* T-Com Sinus 154 data II */
 	{USB_DEVICE(0x083a, 0x4521)},   /* Siemens Gigaset USB Adapter 54 version 2 */
+	{USB_DEVICE(0x083a, 0x4531)},	/* T-Com Sinus 154 data II */
 	{USB_DEVICE(0x083a, 0xc501)},	/* Zoom Wireless-G 4410 */
 	{USB_DEVICE(0x083a, 0xf503)},	/* Accton FD7050E ver 1010ec  */
 	{USB_DEVICE(0x0846, 0x4240)},	/* Netgear WG111 (v2) */


