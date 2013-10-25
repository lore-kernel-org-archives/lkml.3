Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab3JYWEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 18:04:30 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:58944 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab3JYWE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 18:04:29 -0400
From: =?UTF-8?q?Jan=20Mat=C4=9Bjka?= <yac@blesmrt.net>
To: trivial@kernel.org
Cc: jkosina@suse.cz, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan=20Mat=C4=9Bjka?= <yac@blesmrt.net>
Subject: [PATCH] trivial: add manufacturer to menuconfig help
Date: Sat, 26 Oct 2013 00:03:49 +0200
Message-Id: <1382738629-24756-1-git-send-email-yac@blesmrt.net>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tested with vendor=0x04f3 product=0x002f

Signed-off-by: Jan Matějka <yac@blesmrt.net>
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

