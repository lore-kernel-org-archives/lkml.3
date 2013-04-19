Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030559Ab3DSMeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:34:11 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52374 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968302Ab3DSMeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:34:09 -0400
From: Taras Kondratiuk <taras@ti.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>
CC: Taras Kondratiuk <taras@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] MAINTAINERS: update Liam Girdwood email address
Date: Fri, 19 Apr 2013 15:28:17 +0300
Message-ID: <1366374499-21651-1-git-send-email-taras@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6b9cf5c2f286b6e86be8f1c509f6d84e675aa366
updated only one of Liam's TI address entries.
So update the other one.

There is one more Slimlogic address under WM97XX touchscreen
maintainers list, but this patch doesn't touch it.

Signed-off-by: Taras Kondratiuk <taras@ti.com>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8bdd7a7..c2d3458 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8712,7 +8712,7 @@ F:	drivers/scsi/vmw_pvscsi.c
 F:	drivers/scsi/vmw_pvscsi.h
 
 VOLTAGE AND CURRENT REGULATOR FRAMEWORK
-M:	Liam Girdwood <lrg@ti.com>
+M:	Liam Girdwood <lgirdwood@gmail.com>
 M:	Mark Brown <broonie@kernel.org>
 W:	http://opensource.wolfsonmicro.com/node/15
 W:	http://www.slimlogic.co.uk/?p=48
-- 
1.7.9.5

