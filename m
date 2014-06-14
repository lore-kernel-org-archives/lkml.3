Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaFNTkO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 15:40:14 -0400
Received: from honeydew.cs.uni-dortmund.de ([129.217.4.43]:60203 "EHLO
	honeydew.cs.uni-dortmund.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142AbaFNTkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 15:40:11 -0400
From: Benedict Boerger <benedict.boerger@cs.tu-dortmund.de>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        Benedict Boerger <benedict.boerger@cs.tu-dortmund.de>
Subject: [PATCH] staging: keucr: fix Missing blank line after declarations
Date: Sat, 14 Jun 2014 21:39:53 +0200
Message-Id: <1402774793-17224-1-git-send-email-benedict.boerger@cs.tu-dortmund.de>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix two Missing blank line after declarations issue reported by checkpatch.pl

Done to complete an eudyptula task.

Signed-off-by: Benedict Boerger <benedict.boerger@cs.tu-dortmund.de>
---
 drivers/staging/keucr/usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/keucr/usb.c b/drivers/staging/keucr/usb.c
index 12ebde7..dbbd63f 100644
--- a/drivers/staging/keucr/usb.c
+++ b/drivers/staging/keucr/usb.c
@@ -37,6 +37,7 @@ MODULE_DEVICE_TABLE(usb, eucr_usb_ids);
 static int eucr_suspend(struct usb_interface *iface, pm_message_t message)
 {
 	struct us_data *us = usb_get_intfdata(iface);
+
 	pr_info("--- eucr_suspend ---\n");
 	/* Wait until no command is running */
 	mutex_lock(&us->dev_mutex);
@@ -53,6 +54,7 @@ static int eucr_resume(struct usb_interface *iface)
 	u8    tmp = 0;
 
 	struct us_data *us = usb_get_intfdata(iface);
+
 	pr_info("--- eucr_resume---\n");
 	mutex_lock(&us->dev_mutex);
 
-- 
1.9.1

