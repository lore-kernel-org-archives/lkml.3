Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbaHFBNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 21:13:39 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:61962 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbaHFBNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 21:13:37 -0400
From: Dzonatans Melgalvis <dz.melgalvis@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Dzonatans Melgalvis <dz.melgalvis@gmail.com>
Subject: [PATCH] staging: comedi: drivers.c: fix checkpatch code style issue
Date: Wed,  6 Aug 2014 03:53:42 +0300
Message-Id: <1407286422-19733-1-git-send-email-dz.melgalvis@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing checkpatch warning - blank line missing after declaration.

Signed-off-by: Dzonatans Melgalvis <dz.melgalvis@gmail.com>
---
 drivers/staging/comedi/drivers.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 9ada130..00e01d0 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -440,6 +440,7 @@ static void *comedi_recognize(struct comedi_driver *driv, const char *name)
 static void comedi_report_boards(struct comedi_driver *driv)
 {
 	unsigned int i;
+
 	const char *const *name_ptr;
 
 	pr_info("comedi: valid board names for %s driver are:\n",
-- 
1.9.1

