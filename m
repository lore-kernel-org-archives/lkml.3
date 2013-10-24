Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab3JXNIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 09:08:18 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:47353 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381Ab3JXNIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 09:08:16 -0400
From: yac@blesmrt.net
To: linux-kernel@vger.kernel.org
Cc: yac <yac@blesmrt.net>
Subject: [PATCH] tested with vendor=0x04f3 product=0x002f
Date: Thu, 24 Oct 2013 15:07:57 +0200
Message-Id: <1382620077-25476-1-git-send-email-yac@blesmrt.net>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: yac <yac@blesmrt.net>

---
 drivers/hid/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index c91d547..30ed82a 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -437,6 +437,7 @@ config HID_MULTITOUCH
 	  - Chunghwa panels
 	  - CVTouch panels
 	  - Cypress TrueTouch panels
+	  - Elan Microelectronics touch panels
 	  - Elo TouchSystems IntelliTouch Plus panels
 	  - GeneralTouch 'Sensing Win7-TwoFinger' panels
 	  - GoodTouch panels
-- 
1.8.1.5

