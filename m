Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab3KJSh5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 13:37:57 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:35849 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab3KJShu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 13:37:50 -0500
From: Michal Nazarewicz <mpn@google.com>
To: Felipe Balbi <balbi@ti.com>, Roger Quadros <rogerq@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: phy: remove dead code
Date: Sun, 10 Nov 2013 19:37:37 +0100
Message-Id: <1384108657-23349-1-git-send-email-mpn@google.com>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

---
 drivers/usb/phy/phy-am335x.c  | 2 --
 drivers/usb/phy/phy-generic.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/usb/phy/phy-am335x.c b/drivers/usb/phy/phy-am335x.c
index 6370e50..48d41ab 100644
--- a/drivers/usb/phy/phy-am335x.c
+++ b/drivers/usb/phy/phy-am335x.c
@@ -66,8 +66,6 @@ static int am335x_phy_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, am_phy);

 	return 0;
-
-	return ret;
 }

 static int am335x_phy_remove(struct platform_device *pdev)
diff --git a/drivers/usb/phy/phy-generic.c b/drivers/usb/phy/phy-generic.c
index fce3a9e..db4fc22 100644
--- a/drivers/usb/phy/phy-generic.c
+++ b/drivers/usb/phy/phy-generic.c
@@ -271,8 +271,6 @@ static int usb_phy_gen_xceiv_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, nop);

 	return 0;
-
-	return err;
 }

 static int usb_phy_gen_xceiv_remove(struct platform_device *pdev)
--
1.8.3.2
