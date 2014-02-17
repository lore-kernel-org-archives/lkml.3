Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbaBQI7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:59:34 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48150 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbaBQI7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:59:32 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>
Subject: [PATCH 2/8] usb: phy: twl4030-usb: Remove redundant semicolon
Date: Mon, 17 Feb 2014 14:29:19 +0530
Message-ID: <1392627565-1829-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1392627565-1829-1-git-send-email-kishon@ti.com>
References: <1392627565-1829-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sachin Kamat <sachin.kamat@linaro.org>

Semicolon after switch statement is not needed.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-twl4030-usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
index 254c72c..ab64182 100644
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
1.7.10.4

