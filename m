Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777AbaDVVZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:25:33 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37043 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758748AbaDVVXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:23:51 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH v3 6/6] Staging: rts5139: More appropriate use of sizeof operand
Date: Tue, 22 Apr 2014 23:23:04 +0200
Message-Id: <1398201784-7602-7-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398201784-7602-1-git-send-email-fabio.falzoi84@gmail.com>
References: <1398201784-7602-1-git-send-email-fabio.falzoi84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the pointer rts51x to get the size of the struct.

Signed-off-by: Fabio Falzoi <fabio.falzoi84@gmail.com>
---
 drivers/staging/rts5139/rts51x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rts5139/rts51x.c b/drivers/staging/rts5139/rts51x.c
index 6120410..8529cba 100644
--- a/drivers/staging/rts5139/rts51x.c
+++ b/drivers/staging/rts5139/rts51x.c
@@ -719,7 +719,7 @@ static int rts51x_probe(struct usb_interface *intf,
 
 	pr_debug("%s detected\n", RTS51X_NAME);
 
-	rts51x = kzalloc(sizeof(struct rts51x_usb), GFP_KERNEL);
+	rts51x = kzalloc(sizeof(*rts51x), GFP_KERNEL);
 	if (!rts51x)
 		return -ENOMEM;
 
-- 
1.9.1

