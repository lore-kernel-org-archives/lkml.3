Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbbAKWgH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:36:07 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:41560 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbbAKWgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:36:03 -0500
From: "Gustavo A. R. Silva" <silvagustavosilva@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <silvagustavosilva@gmail.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] Staging: vt6656: Fixed typo in a macro name
Date: Sun, 11 Jan 2015 16:35:54 -0600
Message-Id: <1421015754-4242-1-git-send-email-silvagustavosilva@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed typo in a macro name in card.c and device.h files.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/staging/vt6656/card.c   | 2 +-
 drivers/staging/vt6656/device.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 9340f15..67ff13f 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -78,7 +78,7 @@ void vnt_set_channel(struct vnt_private *priv, u32 connection_channel)
 	/* Set Channel[7] = 0 to tell H/W channel is changing now. */
 	vnt_mac_reg_bits_off(priv, MAC_REG_CHANNEL, 0xb0);
 
-	vnt_control_out(priv, MESSAGE_TYPE_SELECT_CHANNLE,
+	vnt_control_out(priv, MESSAGE_TYPE_SELECT_CHANNEL,
 					connection_channel, 0, 0, NULL);
 
 	vnt_control_out_u8(priv, MESSAGE_REQUEST_MACREG, MAC_REG_CHANNEL,
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 5a7ca52..c051320 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -160,7 +160,7 @@
 #define MESSAGE_TYPE_CLRKEYENTRY	0x9
 #define MESSAGE_TYPE_WRITE_MISCFF	0xa
 #define MESSAGE_TYPE_SET_ANTMD		0xb
-#define MESSAGE_TYPE_SELECT_CHANNLE	0xc
+#define MESSAGE_TYPE_SELECT_CHANNEL	0xc
 #define MESSAGE_TYPE_SET_TSFTBTT	0xd
 #define MESSAGE_TYPE_SET_SSTIFS		0xe
 #define MESSAGE_TYPE_CHANGE_BBTYPE	0xf
-- 
1.9.1

