Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab3EGOTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:19:44 -0400
Received: from ip4-83-240-18-99.cust.nbox.cz ([83.240.18.99]:59361 "EHLO
	anemoi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752731Ab3EGOSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:18:06 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-geode@lists.infradead.org, linux-fbdev@vger.kernel.org
Subject: [PATCH 12/15] geodefb: Depend on X86_32
Date: Tue,  7 May 2013 16:18:20 +0200
Message-Id: <1367936303-13386-12-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367936303-13386-1-git-send-email-jslaby@suse.cz>
References: <1367936303-13386-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Mahoney <jeffm@suse.com>

Geode is 32-bit only so only enable it for X86_32.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-geode@lists.infradead.org
Cc: linux-fbdev@vger.kernel.org
---
 drivers/video/geode/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/geode/Kconfig b/drivers/video/geode/Kconfig
index 21e351a..7d8dcb4 100644
--- a/drivers/video/geode/Kconfig
+++ b/drivers/video/geode/Kconfig
@@ -3,7 +3,7 @@
 #
 config FB_GEODE
 	bool "AMD Geode family framebuffer support"
-	depends on FB && PCI && X86
+	depends on FB && PCI && X86_32
 	---help---
 	  Say 'Y' here to allow you to select framebuffer drivers for
 	  the AMD Geode family of processors.
-- 
1.8.2.1

