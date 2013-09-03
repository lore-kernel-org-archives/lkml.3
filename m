Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900Ab3ICMwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 08:52:10 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34691 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756Ab3ICMwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 08:52:08 -0400
From: Masami Ichikawa <masami256@gmail.com>
To: kvalo@adurom.com, IvDoorn@gmail.com, gwingerde@gmail.com,
        helmut.schaa@googlemail.com, linville@tuxdriver.com
Cc: Masami Ichikawa <masami256@gmail.com>, linux-wireless@vger.kernel.org,
        users@rt2x00.serialmonkey.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rt2x00: Add WLI-UC-G300HP's Product ID
Date: Tue,  3 Sep 2013 21:51:56 +0900
Message-Id: <1378212716-13525-1-git-send-email-masami256@gmail.com>
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

