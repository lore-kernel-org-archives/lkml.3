Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760336Ab3EXKIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 06:08:44 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752201Ab3EXKIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 06:08:43 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 May 2013 06:08:42 EDT
From: Richard Weinberger <richard@nod.at>
To: gregkh@linuxfoundation.org
Cc: bjorn@mork.no, dcbw@redhat.com, jhovold@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] serial: Add Option GTM681W to qcserial device table.
Date: Fri, 24 May 2013 12:01:51 +0200
Message-Id: <1369389711-4290-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Option GTM681W uses a qualcomm chip and can be
served by the qcserial device driver.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/usb/serial/qcserial.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 59b32b7..bd794b4 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -118,6 +118,7 @@ static const struct usb_device_id id_table[] = {
 	{USB_DEVICE(0x1199, 0x901b)},	/* Sierra Wireless MC7770 */
 	{USB_DEVICE(0x12D1, 0x14F0)},	/* Sony Gobi 3000 QDL */
 	{USB_DEVICE(0x12D1, 0x14F1)},	/* Sony Gobi 3000 Composite */
+	{USB_DEVICE(0x0AF0, 0x8120)},	/* Option GTM681W */
 
 	/* non Gobi Qualcomm serial devices */
 	{USB_DEVICE_INTERFACE_NUMBER(0x0f3d, 0x68a2, 0)},	/* Sierra Wireless MC7700 Device Management */
-- 
1.8.2.3

