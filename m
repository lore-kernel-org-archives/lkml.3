Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab3H0Phr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 11:37:47 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:48624 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab3H0Php (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 11:37:45 -0400
From: Masami Ichikawa <masami256@gmail.com>
To: IvDoorn@gmail.com, gwingerde@gmail.com, helmut.schaa@googlemail.com,
        linville@tuxdriver.com
Cc: Masami Ichikawa <masami256@gmail.com>, linux-wireless@vger.kernel.org,
        users@rt2x00.serialmonkey.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Add WLI-UC-G300HP's Product ID.
Date: Wed, 28 Aug 2013 00:37:23 +0900
Message-Id: <1377617843-28835-1-git-send-email-masami256@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support Bufallo WLI-UC-G300HP.

Signed-off-by: Masami Ichikawa <masami256@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 840833b..518277d 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -977,6 +977,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0411, 0x016f) },
 	{ USB_DEVICE(0x0411, 0x01a2) },
 	{ USB_DEVICE(0x0411, 0x01ee) },
+	{ USB_DEVICE(0x0411, 0x01a8) },
 	/* Corega */
 	{ USB_DEVICE(0x07aa, 0x002f) },
 	{ USB_DEVICE(0x07aa, 0x003c) },
-- 
1.8.3.1

