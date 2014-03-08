Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbaCHJjL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 04:39:11 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:52759 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbaCHJ3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 04:29:36 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/28] usb: phy: twl4030-usb: Remove redundant semicolon
Date: Sat, 8 Mar 2014 14:59:03 +0530
Message-ID: <1394270969-11851-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394270969-11851-1-git-send-email-kishon@ti.com>
References: <1394270969-11851-1-git-send-email-kishon@ti.com>
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
index 6c7cec7..2e0e9b3 100644
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

