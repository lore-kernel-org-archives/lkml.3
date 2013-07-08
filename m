Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3GHFDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 01:03:33 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:57423 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3GHFDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 01:03:31 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: plagnioj@jcrosoft.com, tomi.valkeinen@ti.com
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] drivers/video: remove unused parameter in Kconfig
Date: Mon,  8 Jul 2013 07:03:26 +0200
Message-Id: <1373259806-23067-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the FB_NUC900_DEBUG kernel configuration
parameter defined in drivers/video/Kconfig, but used nowhere
in the makefiles and source code.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/video/Kconfig | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 2e937bd..a9c0964 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -2098,13 +2098,6 @@ config GPM1040A0_320X240
         bool "Giantplus Technology GPM1040A0 320x240 Color TFT LCD"
         depends on FB_NUC900
 
-config FB_NUC900_DEBUG
-        bool "NUC900 lcd debug messages"
-        depends on FB_NUC900
-        help
-          Turn on debugging messages. Note that you can set/unset at run time
-          through sysfs
-
 config FB_SM501
 	tristate "Silicon Motion SM501 framebuffer support"
 	depends on FB && MFD_SM501
-- 
1.8.1.2

