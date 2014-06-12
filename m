Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbaFLUbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:31:32 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:60809 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaFLUbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:31:31 -0400
From: Marc Fite <marc@fite.cat>
To: gregkh@linuxfoundation.org, a.terekhov@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Marc Fite <marc@fite.cat>
Subject: [PATCH] staging: lustre: removed spaces at the start of a line
Date: Thu, 12 Jun 2014 22:31:15 +0200
Message-Id: <1402605075-25860-1-git-send-email-marc@fite.cat>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a patch in order to remove 2 lines with spaces at the start of the line.

Best Regards.

Signed-off-by: Marc Fite <marc@fite.cat>
---
 drivers/staging/lustre/lustre/obdecho/lproc_echo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdecho/lproc_echo.c b/drivers/staging/lustre/lustre/obdecho/lproc_echo.c
index 8fe9245..c972eb4 100644
--- a/drivers/staging/lustre/lustre/obdecho/lproc_echo.c
+++ b/drivers/staging/lustre/lustre/obdecho/lproc_echo.c
@@ -51,7 +51,7 @@ static struct lprocfs_vars lprocfs_echo_module_vars[] = {
 
 void lprocfs_echo_init_vars(struct lprocfs_static_vars *lvars)
 {
-    lvars->module_vars  = lprocfs_echo_module_vars;
-    lvars->obd_vars     = lprocfs_echo_obd_vars;
+	lvars->module_vars  = lprocfs_echo_module_vars;
+	lvars->obd_vars     = lprocfs_echo_obd_vars;
 }
 #endif /* LPROCFS */
-- 
2.0.0

