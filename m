Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbaAIXkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 18:40:46 -0500
Received: from 24c7.rev.megiteam.pl ([91.227.36.199]:49474 "EHLO
	vk1071.megiteam.com.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbaAIXko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 18:40:44 -0500
X-Greylist: delayed 780 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jan 2014 18:40:44 EST
From: Michal Kwiatkowski <michaelflowersky@geekingspree.com>
To: abbotti@mev.co.uk
Cc: hsweeten@visionengravers.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        michaelflowersky@geekingspree.com
Subject: [PATCH] Staging: comedi: amcc_s5933: "no space before tabs" coding style fixes.
Date: Thu,  9 Jan 2014 23:58:55 +0100
Message-Id: <1389308335-6724-1-git-send-email-michaelflowersky@geekingspree.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issues.

Signed-off-by: Michal Kwiatkowski <michaelflowersky@geekingspree.com>
---
 drivers/staging/comedi/drivers/amcc_s5933.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amcc_s5933.h b/drivers/staging/comedi/drivers/amcc_s5933.h
index b810d5f..2ba7364 100644
--- a/drivers/staging/comedi/drivers/amcc_s5933.h
+++ b/drivers/staging/comedi/drivers/amcc_s5933.h
@@ -145,12 +145,12 @@
 #define AINT_READ_COMPL		0x00008000
 #define AINT_WRITE_COMPL	0x00004000
 
-#define AINT_OMB_ENABLE 	0x00001000
-#define AINT_OMB_SELECT 	0x00000c00
+#define AINT_OMB_ENABLE		0x00001000
+#define AINT_OMB_SELECT		0x00000c00
 #define AINT_OMB_BYTE		0x00000300
 
-#define AINT_IMB_ENABLE 	0x00000010
-#define AINT_IMB_SELECT 	0x0000000c
+#define AINT_IMB_ENABLE		0x00000010
+#define AINT_IMB_SELECT		0x0000000c
 #define AINT_IMB_BYTE		0x00000003
 
 /* these are bits from various different registers, needs cleanup XXX */
-- 
1.7.9.5

