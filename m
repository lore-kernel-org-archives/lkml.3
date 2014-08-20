Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaHTVXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 17:23:42 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:44524 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaHTVXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 17:23:40 -0400
From: Kieron Browne <kieron.browne@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lidza.louina@gmail.com, markh@compro.net,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Kieron Browne <kieron.browne@gmail.com>
Subject: [PATCH] staging: dgnc: Fix checkpatch include warning
Date: Wed, 20 Aug 2014 22:21:31 +0100
Message-Id: <1408569691-27843-1-git-send-email-kieron.browne@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch.pl fix. Use #include <linux/uaccess.h> instead of
<asm/uaccess.h>

Signed-off-by: Kieron Browne <kieron.browne@gmail.com>
---
 drivers/staging/dgnc/dgnc_tty.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/dgnc/dgnc_tty.c b/drivers/staging/dgnc/dgnc_tty.c
index 281491a..c844fac 100644
--- a/drivers/staging/dgnc/dgnc_tty.c
+++ b/drivers/staging/dgnc/dgnc_tty.c
@@ -47,7 +47,7 @@
 #include <linux/serial_reg.h>
 #include <linux/slab.h>
 #include <linux/delay.h>	/* For udelay */
-#include <asm/uaccess.h>	/* For copy_from_user/copy_to_user */
+#include <linux/uaccess.h>	/* For copy_from_user/copy_to_user */
 #include <linux/pci.h>
 
 #include "dgnc_driver.h"
-- 
1.9.1

