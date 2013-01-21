Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab3AUOws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 09:52:48 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:39275 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab3AUOwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 09:52:46 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>
Subject: [PATCH] usb: musb: core: Add missing newline character
Date: Mon, 21 Jan 2013 20:22:35 +0530
Message-ID: <1358779955-4916-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change. Just added a missing newline character.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/musb/musb_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index f1c6c54..c534131 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -2301,7 +2301,7 @@ static int __init musb_init(void)
 	pr_info("%s: version " MUSB_VERSION ", "
 		"?dma?"
 		", "
-		"otg (peripheral+host)",
+		"otg (peripheral+host)\n",
 		musb_driver_name);
 	return platform_driver_register(&musb_driver);
 }
-- 
1.7.9.5

