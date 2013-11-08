Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab3KHOGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 09:06:07 -0500
Received: from top.free-electrons.com ([176.31.233.9]:55354 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756613Ab3KHOGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 09:06:05 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] usb: phy: remove trivial dead code
Date: Fri,  8 Nov 2013 15:05:49 +0100
Message-Id: <1383919549-11129-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes trivial dead code from drivers/usb/phy/phy-am335x.c
and drivers/usb/phy/phy-generic.c

Found by Coverity (CID 1127232 and CID 1127231)

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/usb/phy/phy-am335x.c  | 2 --
 drivers/usb/phy/phy-generic.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/usb/phy/phy-am335x.c b/drivers/usb/phy/phy-am335x.c
index 6370e50649d7..48d41abd1b6b 100644
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
index fce3a9e9bb5d..db4fc22e4aa6 100644
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
1.8.1.2

