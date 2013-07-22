Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab3GVAS2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 20:18:28 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36779 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754113Ab3GVASY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 20:18:24 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 17/18] MAINTAINERS: usb: phy: Update patterns
Date: Sun, 21 Jul 2013 17:15:44 -0700
Message-Id: <03123264ff230c6041bea4ee88ed3e7359ce85a4.1374451989.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1374451988.git.joe@perches.com>
References: <cover.1374451988.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit a0e631235a0 ("usb: phy: move all PHY drivers to drivers/usb/phy/")
deleted the files, remove the file pattern.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Felipe Balbi <balbi@ti.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d0c54ba..522ffed 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8642,7 +8642,6 @@ L:	linux-usb@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git
 S:	Maintained
 F:	drivers/usb/phy/
-F:	drivers/usb/otg/
 
 USB PRINTER DRIVER (usblp)
 M:	Pete Zaitcev <zaitcev@redhat.com>
-- 
1.8.1.2.459.gbcd45b4.dirty

