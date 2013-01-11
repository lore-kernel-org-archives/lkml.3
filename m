Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab3AKWJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 17:09:44 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:45385 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab3AKWIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 17:08:36 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Laurent Navet <laurent_navet@yahoo.com>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 2/6] staging: line6: wrap comment to 80 chars in driver.c
Date: Fri, 11 Jan 2013 23:08:10 +0100
Message-Id: <1357942094-11495-3-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1357942094-11495-1-git-send-email-stefanha@gmail.com>
References: <1357942094-11495-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following checkpatch.pl warning:

  WARNING: line over 80 characters
  #1107: FILE: staging/line6/driver.c:523:
  +       /* Wait for data length. We'll get a couple of 0xff until length arrives. */

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index 96cfbc9..1b05633 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -520,7 +520,7 @@ int line6_read_data(struct usb_line6 *line6, int address, void *data,
 		return ret;
 	}
 
-	/* Wait for data length. We'll get a couple of 0xff until length arrives. */
+	/* Wait for data length. We'll get 0xff until length arrives. */
 	do {
 		ret = usb_control_msg(usbdev, usb_rcvctrlpipe(usbdev, 0), 0x67,
 				      USB_TYPE_VENDOR | USB_RECIP_DEVICE |
-- 
1.8.0.2

