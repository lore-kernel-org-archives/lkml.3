Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbbABRgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 12:36:46 -0500
Received: from mx3.wp.pl ([212.77.101.9]:35955 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbbABRgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 12:36:45 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Jan 2015 12:36:45 EST
From: Jakub Kicinski <kubakici@wp.pl>
To: Ming Lei <ming.lei@canonical.com>
Cc: Jakub Kicinski <kubakici@wp.pl>, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fix kerneldoc of request_firmware_direct()
Date: Fri,  2 Jan 2015 18:29:50 +0100
Message-Id: <1420219790-695-1-git-send-email-kubakici@wp.pl>
X-Mailer: git-send-email 2.1.0
X-WP-DKIM-Status: good (id: wp.pl)                                      
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [4SNE]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix trivial copy/paste error.

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
---
 drivers/base/firmware_class.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 58470c3..96d994a 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -1194,7 +1194,7 @@ request_firmware(const struct firmware **firmware_p, const char *name,
 EXPORT_SYMBOL(request_firmware);
 
 /**
- * request_firmware: - load firmware directly without usermode helper
+ * request_firmware_direct: - load firmware directly without usermode helper
  * @firmware_p: pointer to firmware image
  * @name: name of firmware file
  * @device: device for which firmware is being loaded
-- 
2.1.0

