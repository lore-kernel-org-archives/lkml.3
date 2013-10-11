Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759327Ab3JKTwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:52:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46440 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932781Ab3JKTmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:42:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joerg Kalisch <the_force@gmx.de>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 107/135] p54usb: add USB ID for Corega WLUSB2GTST USB adapter
Date: Fri, 11 Oct 2013 12:39:48 -0700
Message-Id: <20131011193956.912335441@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Lamparter <chunkeey@googlemail.com>

commit 1e43692cdb7cc445d6347d8a5207d9cef0c71434 upstream.

Added USB ID for Corega WLUSB2GTST USB adapter.

Reported-by: Joerg Kalisch <the_force@gmx.de>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/p54/p54usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -83,6 +83,7 @@ static struct usb_device_id p54u_table[]
 	{USB_DEVICE(0x06a9, 0x000e)},	/* Westell 802.11g USB (A90-211WG-01) */
 	{USB_DEVICE(0x06b9, 0x0121)},	/* Thomson SpeedTouch 121g */
 	{USB_DEVICE(0x0707, 0xee13)},   /* SMC 2862W-G version 2 */
+	{USB_DEVICE(0x07aa, 0x0020)},	/* Corega WLUSB2GTST USB */
 	{USB_DEVICE(0x0803, 0x4310)},	/* Zoom 4410a */
 	{USB_DEVICE(0x083a, 0x4521)},   /* Siemens Gigaset USB Adapter 54 version 2 */
 	{USB_DEVICE(0x083a, 0x4531)},	/* T-Com Sinus 154 data II */


