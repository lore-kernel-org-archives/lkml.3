Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760616Ab3B0BJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:09:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760067Ab3BZX5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomasz Guszkowski <tsg@o2.pl>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 049/150] p54usb: corrected USB ID for T-Com Sinus 154 data II
Date: Tue, 26 Feb 2013 15:55:06 -0800
Message-Id: <20130226235529.259764834@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


