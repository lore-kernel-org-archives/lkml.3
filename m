Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbaJJNJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 09:09:36 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:39828 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbaJJNJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 09:09:33 -0400
From: Michal Sojka <sojkam1@fel.cvut.cz>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>
Subject: [PATCH] Update help of CONFIG_MTD_OF_PARTS
Date: Fri, 10 Oct 2014 15:06:17 +0200
Message-Id: <1412946377-18933-1-git-send-email-sojkam1@fel.cvut.cz>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The help text of CONFIG_MTD_OF_PARTS refers to additional documentation
in booting-without-of.txt but this documentation was moved to another
file in commit efcc2da3fd148c9acb7d7cf1d9800e0649f950fc (Stefan Roese:
Factor MTD physmap bindings out of booting-without-of). This updates the
help text to point to the right place.

Signed-off-by: Michal Sojka <sojkam1@fel.cvut.cz>
---
 drivers/mtd/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
index 94b8210..fa8371a 100644
--- a/drivers/mtd/Kconfig
+++ b/drivers/mtd/Kconfig
@@ -133,7 +133,7 @@ config MTD_OF_PARTS
 	help
 	  This provides a partition parsing function which derives
 	  the partition map from the children of the flash node,
-	  as described in Documentation/devicetree/booting-without-of.txt.
+	  as described in Documentation/devicetree/bindings/mtd/mtd-physmap.txt.
 
 config MTD_AR7_PARTS
 	tristate "TI AR7 partitioning support"
-- 
2.1.1

