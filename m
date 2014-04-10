Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934967AbaDJEDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 00:03:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934835AbaDJDW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 3.4 075/134] USB: serial: Add Option GTM681W to qcserial device table.
Date: Wed,  9 Apr 2014 20:23:11 -0700
Message-Id: <20140410032309.587991327@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

commit 8a2f132a01c2dd4c3905fa560f92019761ed72b1 upstream.

The Option GTM681W uses a qualcomm chip and can be
served by the qcserial device driver.

Signed-off-by: Richard Weinberger <richard@nod.at>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/qcserial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -121,6 +121,7 @@ static const struct usb_device_id id_tab
 	{USB_DEVICE(0x1199, 0x9019)},	/* Sierra Wireless Gobi 3000 Modem device */
 	{USB_DEVICE(0x12D1, 0x14F0)},	/* Sony Gobi 3000 QDL */
 	{USB_DEVICE(0x12D1, 0x14F1)},	/* Sony Gobi 3000 Composite */
+	{USB_DEVICE(0x0AF0, 0x8120)},	/* Option GTM681W */
 	{ }				/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, id_table);


