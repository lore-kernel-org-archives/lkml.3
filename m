Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaBCIaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 03:30:05 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:42004 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaBCIaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 03:30:03 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: kishon@ti.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 2/3] usb: phy: twl4030-usb: Remove redundant semicolon
Date: Mon,  3 Feb 2014 13:55:04 +0530
Message-Id: <1391415905-15341-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391415905-15341-1-git-send-email-sachin.kamat@linaro.org>
References: <1391415905-15341-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Semicolon after switch statement is not needed.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/phy/phy-twl4030-usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
index 254c72c94370..ab64182bafde 100644
--- a/drivers/phy/phy-twl4030-usb.c
+++ b/drivers/phy/phy-twl4030-usb.c
@@ -338,7 +338,7 @@ static void twl4030_usb_set_mode(struct twl4030_usb *twl, int mode)
 		dev_err(twl->dev, "unsupported T2 transceiver mode %d\n",
 				mode);
 		break;
-	};
+	}
 }
 
 static void twl4030_i2c_access(struct twl4030_usb *twl, int on)
-- 
1.7.9.5

